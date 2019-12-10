//
//  VETVoipSdkPrc.m
//  MobileVoip
//
//  Created by Liu Yang on 26/04/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETVoipManager.h"
#import <pjsip.h>
#import <pjsua-lib/pjsua.h>
#import <pjmedia.h>
#import <pjsua-lib/pjsua_internal.h>
#import "VETVoipConfig.h"
#import "VETVoipAccount.h"
#import "NSString+VETVoipExtension.h"
#import "VETVoipCall.h"
#import "VETVoipCallbacks.h"
#import "VETVoipConstants.h"
#import "VETVoipCodecInfo.h"
#import "LYAppInfoTools.h"
#import "LYXIPV6Helper.h"
#import "pj-nat64.h"

NSString * const VETVoipManagerDidFinishStartingNotification = @"VETVoipManagerDidFinishStartingNotification";

// Posted when the user agent finishes stopping.
NSString * const VETVoipManagerDidFinishStoppingNotification = @"VETVoipManagerDidFinishStoppingNotification";

NSString * const VETVoipManagerAccountRegisterStatusNotification = @"VETVoipManagerAccountRegisterStatusNotification";

const NSInteger kVETVoipManagerInvalidIdentifier = PJSUA_INVALID_ID;

enum {
    kVETRingbackFrequency1  = 440,
    kVETRingbackFrequency2  = 480,
    kVETRingbackOnDuration  = 2000,
    kVETRingbackOffDuration = 4000,
    kVETRingbackCount       = 1,
    kVETRingbackInterval    = 4000
};

static const NSInteger kVETVoipDefaultLogLevel = 3;
static const NSInteger kVETVoipDefaultConsoleLogLevel = 0;
static const NSInteger kVETVoipDefaultTransportPort = 0;


#define THIS_FILE "VETVoipManager.m"
const size_t MAX_SIP_ID_LENGTH = 50;
const size_t MAX_SIP_REG_URI_LENGTH = 50;

@interface VETVoipManager ()
{
@private
     VETVoipManagerCallData _callData[PJSUA_MAX_CALLS];
     pj_thread_desc _descriptor;
     pjsua_acc_id _accountId;
     pjsua_transport_id     tp_id;
}

// Read-write redeclarations.
@property(nonatomic) VETVoipAgentState state;

@property (nonatomic, retain) NSMutableArray *accounts;

@property (nonatomic, readonly) NSThread *thread;

// Ringback slot.
@property(nonatomic, assign) pjsua_conf_port_id ringbackSlot;

// Ringback port.
@property(nonatomic, assign) pjmedia_port *ringbackPort;

// Ringback count.
@property(nonatomic, assign) NSInteger ringbackCount;

@property(nonatomic, copy) VETVoipConfig *config;

@end

@implementation VETVoipManager

+ (instancetype)sharedManager
{
    static VETVoipManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VETVoipManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if (self == [super init]) {
        _accounts = [NSMutableArray array];
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(thread_main) object:nil];
        
        // 默认为0号端口
        [self setTransportPort:kVETVoipDefaultTransportPort];

        // 创建一个子线程
        // NSQualityOfServiceUserInitiated：由用户发起的并且需要立即得到结果的任务，比如滑动scroll view时去加载数据用于后续cell的显示，这些任务通常跟后续的用户交互相关，在几秒或者更短的时间内完成
        _thread.qualityOfService = NSQualityOfServiceUserInitiated;
        [_thread start];
    }
    return self;
}

- (void)setTransportPort:(NSUInteger)port {
    if (port > 0 && port < 65535) {
        _transportPort = port;
    } else {
        _transportPort = kVETVoipDefaultTransportPort;
    }
}

- (void)setupConfig:(VETVoipConfig *)config
{
    if (!config.userAgentString) {
        NSString *bundleName = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
        NSString *bundleShortVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
        NSString *deviceType = [LYAppInfoTools iphoneType];
        config.userAgentString = [NSString stringWithFormat:@"%@/%@-%@/%@", bundleName, deviceType, [LYAppInfoTools phoneVersion], bundleShortVersion];
    }
    if (config.logLevel == 0 || config.logLevel > 5) {
        config.logLevel = kVETVoipDefaultLogLevel;
    }
    if (config.consoleLogLevel == 0 || config.consoleLogLevel > 5) {
        config.consoleLogLevel = kVETVoipDefaultConsoleLogLevel;
    }
    if (config.transportPort > 65535) {
        config.transportPort = kVETVoipDefaultTransportPort;
    }
    if (config.volumeScale == 0) {
        config.volumeScale = 2.0;
    }
    _config = config;
}

- (void)thread_main {
    @autoreleasepool {
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }
}

- (VETVoipManagerCallData *)callData {
    return _callData;
}

- (BOOL)isStarted {
    return _state == VETVoipAgentStateStarted;
}

- (void)start {
    if (_state != VETVoipAgentStateStopped) {
        return;
    }
    if (pj_init() != PJ_SUCCESS) {
        NSLog(@"Error initializing PJSIP");
        return;
    }
    self.state = VETVoipAgentStateStarting;
    void (^completion)(BOOL) = ^(BOOL didStart) {
        self.state = didStart ? VETVoipAgentStateStarted : VETVoipAgentStateStopped;
        [[NSNotificationCenter defaultCenter] postNotificationName:VETVoipManagerDidFinishStartingNotification object:self];
    };
    [self performSelector:@selector(thread_startWithCompletion:) onThread:self.thread withObject:completion waitUntilDone:NO];
}

- (void)stop {
    if (_state != VETVoipAgentStateStarted) {
        return;
    }
    self.state = VETVoipAgentStateStopping;
    [self performSelector:@selector(thread_stopWithCompletion:) onThread:self.thread withObject:^{[self finishStopping];} waitUntilDone:NO];
}

- (void)stopAndWait {
    if (_state != VETVoipAgentStateStopped) {
        return;
    }
    self.state = VETVoipAgentStateStopping;
    [self performSelector:@selector(thread_stop) onThread:self.thread withObject:nil waitUntilDone:YES];
    [self finishStopping];
}

- (void)finishStopping {
    pj_shutdown();
    [self.accounts removeAllObjects];
    self.state = VETVoipAgentStateStopped;
    [[NSNotificationCenter defaultCenter] postNotificationName:VETVoipManagerDidFinishStoppingNotification object:self];
}

- (void)thread_startWithCompletion:(void (^ _Nonnull)(BOOL didStart))completion
{
    pj_status_t status;
    if (!pj_thread_is_registered()) {
        pj_thread_t *thread;
        status = pj_thread_register("AKSIPUserAgent-pjsip-control", _descriptor, &thread);
        if (status != PJ_SUCCESS) {
            NSLog(@"Error registering thread at PJSUA");
            [self thread_callOnMain:completion withFlag:NO];
            return;
        }
    }
    
    status = pjsua_create();
    if (status != PJ_SUCCESS) {
        NSLog(@"Error creating PJSUA");
        [self thread_callOnMain:completion withFlag:NO];
        return;
    }
    
    // Create pool for PJSUA.
    self.pool = pjsua_pool_create("AKSIPUserAgent-pjsua", 1000, 1000);
    if (!self.pool) {
        NSLog(@"Could not create memory pool");
        [self thread_stop];
        [self thread_callOnMain:completion withFlag:NO];
        return;
    }
    
    pjsua_logging_config loggingConfig;
    pjsua_media_config mediaConfig;
    pjsua_transport_config transportConfig;
    pjsua_config userAgentConfig;
    tp_id = -1;
    
    pjsua_config_default(&userAgentConfig);
    pjsua_logging_config_default(&loggingConfig);
    pjsua_media_config_default(&mediaConfig);
    pjsua_transport_config_default(&transportConfig);
    
    // 最大可接听数
    userAgentConfig.max_calls = (unsigned)kAKSIPCallsMax;
    userAgentConfig.use_timer = PJSUA_SIP_TIMER_INACTIVE;
    userAgentConfig.user_agent = [_config.userAgentString pjString];
    
    loggingConfig.log_filename = [[_config.logFileName stringByExpandingTildeInPath] pjString];
    
    loggingConfig.level = (unsigned)_config.logLevel;
    loggingConfig.console_level = (unsigned)_config.consoleLogLevel;
    loggingConfig.msg_logging = YES;
    
    mediaConfig.snd_auto_close_time = 1;
    mediaConfig.clock_rate = 8000;
    mediaConfig.snd_clock_rate = 0;
    mediaConfig.ec_tail_len = 0;
    
    // Network port to use for SIP transport. Set 0 for any available port.
    // Default: 0.
    transportConfig.port = 0;
    
    userAgentConfig.cb.on_incoming_call = &PJSUAOnIncomingCall;
    userAgentConfig.cb.on_call_state = &PJSUAOnCallState;
    userAgentConfig.cb.on_call_media_state = &PJSUAOnCallMediaState;
    userAgentConfig.cb.on_call_transfer_status = &PJSUAOnCallTransferStatus;
    userAgentConfig.cb.on_call_replaced = &PJSUAOnCallReplaced;
    userAgentConfig.cb.on_reg_state = &PJSUAOnAccountRegistrationState;
    
//    userAgentConfig.outbound_proxy[0] = pj_str("sip:103.234.220.234:5070;transport=tcp");
    
    // Initialize PJSUA.
    status = pjsua_init(&userAgentConfig, &loggingConfig, &mediaConfig);
    if (status != PJ_SUCCESS) {
        NSLog(@"Error initializing PJSUA");
        [self thread_stop];
        [self thread_callOnMain:completion withFlag:NO];
        return;
    }
    
    // Create ringback tones.
    unsigned i, samplesPerFrame;
    pjmedia_tone_desc tone[kVETRingbackCount];
    pj_str_t name;
    
    samplesPerFrame = mediaConfig.audio_frame_ptime * mediaConfig.clock_rate * mediaConfig.channel_count / 1000;
    
    name = pj_str("ringback");
    pjmedia_port *aRingbackPort;
    status = pjmedia_tonegen_create2([self pool],
                                     &name,
                                     mediaConfig.clock_rate,
                                     mediaConfig.channel_count,
                                     samplesPerFrame,
                                     16,
                                     PJMEDIA_TONEGEN_LOOP,
                                     &aRingbackPort);
    if (status != PJ_SUCCESS) {
        NSLog(@"Error creating ringback tones");
        [self thread_stop];
        [self thread_callOnMain:completion withFlag:NO];
        return;
    }
    
    [self setRingbackPort:aRingbackPort];
    
    pj_bzero(&tone, sizeof(tone));
    for (i = 0; i < kVETRingbackCount; ++i) {
        tone[i].freq1 = kVETRingbackFrequency1;
        tone[i].freq2 = kVETRingbackFrequency2;
        tone[i].on_msec = kVETRingbackOnDuration;
        tone[i].off_msec = kVETRingbackOffDuration;
    }
    tone[kVETRingbackCount - 1].off_msec = kVETRingbackInterval;
    
    pjmedia_tonegen_play([self ringbackPort], kVETRingbackCount, tone, PJMEDIA_TONEGEN_LOOP);
    
    pjsua_conf_port_id aRingbackSlot;
    status = pjsua_conf_add_port([self pool], [self ringbackPort], &aRingbackSlot);
    if (status != PJ_SUCCESS) {
        NSLog(@"Error adding media port for ringback tones");
        [self thread_stop];
        [self thread_callOnMain:completion withFlag:NO];
        return;
    }
    [self setRingbackSlot:aRingbackSlot];
    
    // Add UDP transport.
    if ([LYXIPV6Helper isIpv6]) {
        LYLog(@"当前网络环境IPv6");
        status = pjsua_transport_create(PJSIP_TRANSPORT_UDP6, &transportConfig, &tp_id);
        pj_nat64_enable_rewrite_module();
    }
    else {
        LYLog(@"当前网络环境IPv4");
        status = pjsua_transport_create(PJSIP_TRANSPORT_UDP, &transportConfig, &tp_id);
    }
    
    if (status != PJ_SUCCESS) {
        NSLog(@"Error creating UDP transport");
        [self thread_stop];
        [self thread_callOnMain:completion withFlag:NO];
        return;
    }
    
    // Get transport port chosen by PJSUA.
    if (_config.transportPort == 0) {
        pjsua_transport_info transportInfo;
        status = pjsua_transport_get_info(tp_id, &transportInfo);
        if (status != PJ_SUCCESS) {
            NSLog(@"Error getting transport info");
        }
        _config.transportPort = transportInfo.local_name.port;
        // Set chosen port back to transportConfig to add TCP transport below.
        transportConfig.port = (unsigned)_config.transportPort;
    }
    
    // Add TCP transport. Don't return, just leave a log message on error.
//    status = pjsua_transport_create(PJSIP_TRANSPORT_TCP, &transportConfig, NULL);

    // IPV6
//     status = pjsua_transport_create(PJSIP_TRANSPORT_TCP6, &transportConfig, &tp_id);
    
    // Update codecs.
    [self settingDefaultCodecs];
    
    // Start PJSUA.
    status = pjsua_start();
    if (status != PJ_SUCCESS) {
        NSLog(@"Error starting PJSUA");
        [self thread_stop];
        [self thread_callOnMain:completion withFlag:NO];
        return;
    }
    
#if defined(PJ_HAS_IPV6) && PJ_HAS_IPV6 == 1
    pj_nat64_enable_rewrite_module();
#endif
    
    [self thread_callOnMain:completion withFlag:YES];
}

- (void)thread_stopWithCompletion:(void (^ _Nonnull)(void))completion {
    [self thread_stop];
    dispatch_async(dispatch_get_main_queue(), completion);
}

- (void)thread_stop {
    if (self.ringbackPort && self.ringbackSlot != kVETVoipManagerInvalidIdentifier) {
        pjsua_conf_remove_port(self.ringbackSlot);
        self.ringbackSlot = kVETVoipManagerInvalidIdentifier;
        pjmedia_port_destroy(self.ringbackPort);
        self.ringbackPort = NULL;
    }
    if (self.pool) {
        pj_pool_release(self.pool);
        self.pool = NULL;
    }
    if (pjsua_destroy() != PJ_SUCCESS) {
        NSLog(@"Error stopping SIP user agent");
    }
}

- (void)thread_callOnMain:(void (^ _Nonnull)(BOOL))block withFlag:(BOOL)flag {
    dispatch_async(dispatch_get_main_queue(), ^{ block(flag); });
}

pjsua_acc_config accountConfig;

- (BOOL)addAccount:(VETVoipAccount *)anAccount
{
//    if ([[self delegate] respondsToSelector:@selector(SIPUserAgentShouldAddAccount:)]) {
//        if (![[self delegate] SIPUserAgentShouldAddAccount:anAccount]) {
//            return NO;
//        }
//    }
    BOOL isAccountAdded = anAccount.accountId != kVETVoipManagerInvalidIdentifier;
    
    // 不用重复添加，直接设置为YES。
    if (isAccountAdded) {
        [anAccount setRegistered:YES];
        return YES;
    }
    
    pjsua_acc_config_default(&accountConfig);
    
    NSString *fullSIPURL = [NSString stringWithFormat:@"%@ <sip:%@>", [anAccount fullName], [anAccount SIPAddress]];
    accountConfig.id = [fullSIPURL pjString];
    
    NSString *registerURI ;
    if (anAccount.encryptionType == VETAccountEncryptionTypeRC4) {
        registerURI = [NSString stringWithFormat:@"sip:%@:%d", [anAccount domain], 5070];
    }
    else {
        registerURI = [NSString stringWithFormat:@"sip:%@", [anAccount domain]];
    }
//    NSString *registerURI = [NSString stringWithFormat:@"sip:%@;transport=tcp", [anAccount domain]];
    accountConfig.reg_uri = [registerURI pjString];
    
    accountConfig.cred_count = 1;
    if ([[anAccount realm] length] > 0) {
        accountConfig.cred_info[0].realm = [[anAccount realm] pjString];
    }
    else {
        accountConfig.cred_info[0].realm = pj_str("*");
    }
    
    accountConfig.cred_info[0].scheme = pj_str("digest");
    accountConfig.cred_info[0].username = [anAccount.username pjString];
    accountConfig.cred_info[0].data_type = PJSIP_CRED_DATA_PLAIN_PASSWD;
    accountConfig.cred_info[0].data = [anAccount.password pjString];
    accountConfig.cred_info[0].isVosEncrypt = anAccount.encryptionType == VETAccountEncryptionTypeRC4 ? true : false;
    
    accountConfig.rtp_cfg.port = 0;
    
    accountConfig.reg_timeout = (unsigned)[anAccount reregistrationTime];
    
    accountConfig.allow_via_rewrite = NO;
    
//    accountConfig.proxy[accountConfig.proxy_cnt++] = pj_str("sip:sip.talk2all.net;transport=udp");
    
    // IPV6
    if ([LYXIPV6Helper isIpv6]) {
//        accountConfig.ipv6_media_use = PJSUA_IPV6_ENABLED;
    }
    
    accountConfig.transport_id = tp_id;
    NSLog(@"accountId:%d", _accountId);
    pj_status_t status = PJ_FALSE;
    if (_accountId >= 0 && _accountId < 3) {
        status = pjsua_acc_add(&accountConfig, PJ_FALSE, &_accountId);
    }
    
    if (status != PJ_SUCCESS) {
        NSLog(@"Error adding account %@ with status %d", anAccount.fullName, status);
        return NO;
    }
    
    [anAccount updateAccountId:_accountId];
    [anAccount setThread:self.thread];
    
    [_accounts addObject:anAccount];
    
    /*
     *  set online
     */
    pjsua_acc_set_registration(_accountId, PJ_TRUE);
    pjsua_acc_set_online_status(_accountId, PJ_TRUE);
    return YES;
}

- (BOOL)removeAccount:(VETVoipAccount *)anAccount
{
    if (![self isStarted] ||
        [anAccount accountId] == kVETVoipManagerInvalidIdentifier) {
        return NO;
    }
    
//    [anAccount.delegate voipAccountWillRemove:anAccount];
    
    [anAccount removeAllCalls];
    
    pj_status_t status = pjsua_acc_del((pjsua_acc_id)anAccount.accountId);
    if (status != PJ_SUCCESS) {
        return NO;
    }
    if ([[self accounts] containsObject:anAccount]) {
        [[self accounts] removeObject:anAccount];
    }
    [anAccount updateAccountId:kVETVoipManagerInvalidIdentifier];
    return YES;
}

- (VETVoipAccount *)accountWithAccountId:(NSInteger)accountId {
    for (VETVoipAccount *account in self.accounts) {
        if (account.accountId == accountId) {
            return account;
        }
    }
    return nil;
}

- (VETVoipAccount *)accountWithUsername:(NSString *)username
{
    for (VETVoipAccount *account in self.accounts) {
        if ([account.username isEqualToString:username]) {
            return account;
        }
    }
    return nil;
}

- (VETVoipCall *)callWithCallId:(NSInteger)callId
{
    for (VETVoipAccount *account in self.accounts) {
        VETVoipCall *call = [account callWithCallId:callId];
        if (call) {
            return call;
        }
    }
    return nil;
}

- (void)hangUpAllCalls
{
    pjsua_call_hangup_all();
}

- (void)startRingbackForCall:(VETVoipCall *)call
{
    if (self.callData[call.callId].ringbackOn) {
        return;
    }
    
    self.callData[call.callId].ringbackOn = PJ_TRUE;
    
    self.ringbackCount = self.ringbackCount + 1;
    if (self.ringbackCount == 1 && self.ringbackSlot != kVETVoipManagerInvalidIdentifier) {
        pjsua_conf_connect(self.ringbackSlot, 0);
    }
}

- (void)stopRingbackForCall:(VETVoipCall *)call
{
    if (self.callData[call.callId].ringbackOn) {
        self.callData[call.callId].ringbackOn = PJ_FALSE;
        
        pj_assert(self.ringbackCount > 0);
        
        self.ringbackCount = self.ringbackCount - 1;
        
        if (self.ringbackCount == 0 && self.ringbackSlot != kVETVoipManagerInvalidIdentifier) {
            pjsua_conf_disconnect(self.ringbackSlot, 0);
            pjmedia_tonegen_rewind(self.ringbackPort);
        }
    }
}

# pragma mark - Callbacks

/*
 *  Registration状态回调
 */
void PJSUAOnAccountRegistrationState(pjsua_acc_id accountID) {
    dispatch_async(dispatch_get_main_queue(), ^{
        VETVoipAccount *account1 = [[VETVoipManager sharedManager] accountWithAccountId:accountID];
//        pjsua_acc_info info;
        NSLog(@"Account :%@, Register state:%@", account1.username, VETAccountStatusString(account1.accountStatus));
        [[NSNotificationCenter defaultCenter] postNotificationName:VETVoipManagerAccountRegisterStatusNotification object:account1];
    });
    if ([LYXIPV6Helper isIpv6]) {
        accountConfig.ipv6_media_use = PJSUA_IPV6_ENABLED;
        pj_nat64_set_options(NAT64_REWRITE_ROUTE_AND_CONTACT);
    }
}

/*
 *  来电回调
 */
void PJSUAOnIncomingCall(pjsua_acc_id accountID, pjsua_call_id callID, pjsip_rx_data *invite) {
    PJ_LOG(3, (THIS_FILE, "Incoming call for account %d", accountID));
    dispatch_async(dispatch_get_main_queue(), ^{
        VETVoipAccount *account = [[VETVoipManager sharedManager] accountWithAccountId:accountID];
        VETVoipCall *call = [account addCallWithCallId:callID];
        [account.delegate voipAccount:account didReceiveCall:call];
        [[NSNotificationCenter defaultCenter] postNotificationName:VETVoipCallIncomingNotification object:call];
    });
}

- (int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

#pragma mark - codec

- (void)settingDefaultCodecs {
    if (self.state == VETVoipAgentStateStopped || self.state == VETVoipAgentStateStopping) {
        return;
    }
    const unsigned kCodecInfoSize = 64;
    pjsua_codec_info codecInfo[kCodecInfoSize];
    unsigned codecCount = kCodecInfoSize;
    pj_status_t status = pjsua_enum_codecs(codecInfo, &codecCount);
    if (status != PJ_SUCCESS) {
        NSLog(@"Error getting list of codecs");
    } else {
        static NSString * const kPCMU = @"PCMU/8000/1";
        static NSString * const kPCMA = @"PCMA/8000/1";
        for (NSUInteger i = 0; i < codecCount; i++) {
            NSString *codecIdentifier = [NSString stringWithPJString:codecInfo[i].codec_id];
            pj_uint8_t defaultPriority = (pj_uint8_t)[self priorityForCodec:codecIdentifier];
            if (self.usesG711Only) {
                pj_uint8_t priority = 0;
                if ([codecIdentifier isEqualToString:kPCMU] || [codecIdentifier isEqualToString:kPCMA]) {
                    priority = defaultPriority;
                }
                status = pjsua_codec_set_priority(&codecInfo[i].codec_id, priority);
                if (status != PJ_SUCCESS) {
                    NSLog(@"Error setting codec priority to zero");
                }
            } else {
                status = pjsua_codec_set_priority(&codecInfo[i].codec_id, defaultPriority);
                if (status != PJ_SUCCESS) {
                    NSLog(@"Error setting codec priority to the default value");
                }
            }
        }
    }
}

- (NSUInteger)priorityForCodec:(NSString *)identifier {
    static NSDictionary *priorities = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        priorities = @{
                       @"speex/16000/1": @(130),
                       @"speex/8000/1":  @(129),
                       @"speex/32000/1": @(128),
                       @"opus/48000/2":  @(127),
                       @"iLBC/8000/1":   @(126),
                       @"GSM/8000/1":    @(125),
                       @"PCMU/8000/1":   @(124),
                       @"PCMA/8000/1":   @(123),
                       @"G722/16000/1":  @(122)
                       };
    });
    return [priorities[identifier] unsignedIntegerValue];
}

- (NSArray *)queryCodec
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    unsigned int count = 255;
    pjsua_codec_info codecs[count];
    pj_status_t status = pjsua_enum_codecs(codecs, &count);
    if (status != PJ_SUCCESS) {
        NSLog(@"get codes error");
        return nil;
    }
    for (NSUInteger i = 0; i < count; i++) {
        pjsua_codec_info pjCodec = codecs[i];
        VETVoipCodecInfo *codec = [[VETVoipCodecInfo alloc] initWithCodecId:[NSString stringWithPJString:pjCodec.codec_id] priority:pjCodec.priority];
        [arr addObject:codec];
    }
    return [arr copy];
}

- (BOOL)updatePriorityWithCodecId:(NSString *)codecId priority:(NSUInteger)priority
{
    pj_str_t pj_codecId = [codecId pjString];
    pj_status_t status = pjsua_codec_set_priority(&pj_codecId, priority);
    if (status != PJ_SUCCESS) {
        NSLog(@"Error setting codec(%@) priority to the %d value", codecId, priority);
    }
    return YES;
}

#pragma mark - query banlance

void (^balanceCompletion) (NSString *balance);
- (void)queryBalanceBalanceCompletion:(void (^) (NSString *balance))completion
{
    if (completion) {
        if (!balanceCompletion) {
            balanceCompletion = completion;
        }
    }
    pj_status_t status = PJ_FALSE;
    
    char *msgText = (char *)[[NSString stringWithFormat:@"<sip:queryaccount@%@>", SERVER_ADDRESS] UTF8String];
    
    pj_str_t dst_uri = pj_str(msgText);
    pjsip_method method;
    pjsip_tx_data *tdata;
    pjsip_endpoint *endpt;
    
    endpt = pjsua_get_pjsip_endpt();
    pjsip_method_set(&method, PJSIP_OPTIONS_METHOD);
    
//    pj_bool_t result = pjsua_acc_is_valid(accountId);
//    if (result == PJ_TRUE) {
    status = pjsua_acc_create_request(pjsua_acc_is_valid(10), &method, &dst_uri, &tdata);
//    }
    
    if (status != PJ_SUCCESS) {
        pjsua_perror(THIS_FILE, "pjsua_acc_create_request failed", status);
        NSLog(@"---> Error 1 <---");
        return;
    }
    status = pjsip_endpt_send_request(endpt, tdata, -1, NULL, cb_balance_options);
    if (status != PJ_SUCCESS) {
        pjsua_perror(THIS_FILE, "pjsip_endpt_send_request failed", status);
        NSLog(@"---> Error 2<---");
        return;
    }
}

void cb_balance_options(void *token, pjsip_event *e)
{
    NSString *bal;
    
#define VET_UM_BALANCE @"VET_UM_BALANCE"
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if (e->body.rx_msg.rdata == NULL) {
        bal = @"N/A";
    }
    else if (e->body.rx_msg.rdata->tp_info.op_key.rdata == NULL) {
        bal = @"N/A";
    }
    else if (e->body.rx_msg.rdata->tp_info.op_key.rdata->msg_info.msg == NULL) {
        bal = @"N/A";
    }
    else if(e->body.rx_msg.rdata->tp_info.op_key.rdata->msg_info.msg->line.status.code == 200) {
        pj_str_t balance = e->body.rx_msg.rdata->tp_info.op_key.rdata->msg_info.msg->line.status.reason;
        bal =  [NSString stringWithFormat:@"%.*s", balance.slen, balance.ptr];
        NSLog(@"balance --: %@", bal);
        [userDefault setObject:bal forKey:VET_UM_BALANCE];
        [userDefault synchronize];
        balanceCompletion(bal);
    }
    else {
        bal = @"N/A";
    }
    [userDefault setObject:bal forKey:VET_UM_BALANCE];
    [userDefault synchronize];
}

@end
