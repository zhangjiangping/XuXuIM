//
//  VETSIPURI.m
//  MobileVoip
//
//  Created by Liu Yang on 02/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETSIPURI.h"
#import "VETVoipManager.h"
#import "NSString+VETVoipExtension.h"

@implementation VETSIPURI

+ (instancetype)SIPURIWithUser:(NSString *)aUser host:(NSString *)aHost displayName:(NSString *)aDisplayName {
    return [[self alloc] initWithUser:aUser host:aHost displayName:aDisplayName];
}

+ (instancetype)SIPURIWithString:(NSString *)SIPURIString {
    return [[self alloc] initWithString:SIPURIString];
}

- (instancetype)initWithRemoteUri:(NSString *)remoteUri displayName:(NSString *)aDisplayName
{
    if (self = [super init]) {
        //_remoteUri = remoteUri;
        _displayName = aDisplayName;
        NSArray *seperateArr = [remoteUri componentsSeparatedByString:@"@"];
        if (seperateArr && [seperateArr isKindOfClass:[NSArray class]] &&seperateArr.count > 0) {
            _user = seperateArr[0];
            if (seperateArr.count > 1) {
                NSString *address = seperateArr[1];
                NSArray *addressSeperateArr = [address componentsSeparatedByString:@":"];
                if (addressSeperateArr && [addressSeperateArr isKindOfClass:[NSArray class]] && addressSeperateArr.count > 0) {
                    _address = addressSeperateArr[0];
                    if (seperateArr.count > 1) {
                        _port = [addressSeperateArr[1] integerValue];
                    }
                }
                else {
                    _address = address;
                }
            }
        }
    }
    return self;
}

// Designated initializer.
- (instancetype)initWithUser:(NSString *)aUser host:(NSString *)aHost displayName:(NSString *)aDisplayName {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    [self setDisplayName:aDisplayName];
    [self setUser:aUser];
    [self setAddress:aHost];
    return self;
}

- (instancetype)initWithString:(NSString *)SIPURIString {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES '.+\\\\s<sip:(.+@)?.+>'"];
    if ([predicate evaluateWithObject:SIPURIString]) {
        NSRange delimiterRange = [SIPURIString rangeOfString:@" <"];
        
        NSMutableCharacterSet *trimmingCharacterSet = [[NSCharacterSet whitespaceCharacterSet] mutableCopy];
        [trimmingCharacterSet addCharactersInString:@"\""];
        [self setDisplayName:[[SIPURIString substringToIndex:delimiterRange.location]
                              stringByTrimmingCharactersInSet:trimmingCharacterSet]];
        
        NSRange userAndHostRange = [SIPURIString rangeOfString:@"<sip:" options:NSCaseInsensitiveSearch];
        userAndHostRange.location += 5;
        userAndHostRange.length = [SIPURIString length] - userAndHostRange.location - 1;
        NSString *userAndHost = [SIPURIString substringWithRange:userAndHostRange];
        
        NSRange atSignRange = [userAndHost rangeOfString:@"@" options:NSBackwardsSearch];
        if (atSignRange.location != NSNotFound) {
            [self setUser:[userAndHost substringToIndex:atSignRange.location]];
            [self setHost:[userAndHost substringFromIndex:(atSignRange.location + 1)]];
        } else {
            [self setHost:userAndHost];
        }
        
        return self;
    }
    
    if (![[VETVoipManager sharedManager] isStarted]) {
        return nil;
    }
    
    pjsip_name_addr *nameAddr;
    nameAddr = (pjsip_name_addr *)pjsip_parse_uri([[VETVoipManager sharedManager] pool],
                                                  (char *)[SIPURIString cStringUsingEncoding:NSUTF8StringEncoding],
                                                  [SIPURIString length], PJSIP_PARSE_URI_AS_NAMEADDR);
    if (nameAddr == NULL) {
        return nil;
    }
    
    [self setDisplayName:[NSString stringWithPJString:nameAddr->display]];
    
    pj_str_t *schemePJString = (pj_str_t *)pjsip_uri_get_scheme(nameAddr);
    NSString *scheme = [NSString stringWithPJString:*schemePJString];
    
    if ([scheme isEqualToString:@"sip"] || [scheme isEqualToString:@"sips"]) {
        pjsip_sip_uri *uri = (pjsip_sip_uri *)pjsip_uri_get_uri(nameAddr);
        
        [self setUser:[NSString stringWithPJString:uri->user]];
        [self setPassword:[NSString stringWithPJString:uri->passwd]];
        [self setHost:[NSString stringWithPJString:uri->host]];
        [self setPort:uri->port];
        [self setUserParameter:[NSString stringWithPJString:uri->user_param]];
        [self setMethodParameter:[NSString stringWithPJString:uri->method_param]];
        [self setTransportParameter:[NSString stringWithPJString:uri->transport_param]];
        [self setTTLParameter:uri->ttl_param];
        [self setLooseRoutingParameter:uri->lr_param];
        [self setMaddrParameter:[NSString stringWithPJString:uri->maddr_param]];
        
    } else if ([scheme isEqualToString:@"tel"]) {
        // TODO(eofster): we really must have some kind of AKTelURI here instead.
        pjsip_tel_uri *uri = (pjsip_tel_uri *)pjsip_uri_get_uri(nameAddr);
        
        [self setUser:[NSString stringWithPJString:uri->number]];
        
    } else {
        return nil;
    }
    
    return self;
}

- (NSString *)remoteUri
{
    if ([self.user length] > 0) {
        return [NSString stringWithFormat:@"%@@%@", self.user, self.address];
    }
    else {
        return self.address;
    }
}

- (NSString *)description {
    if ([self.remoteUri length] > 0) {
        if (_port > 0) {
            return [NSString stringWithFormat:@"\"%@\" <sip:%@:%ld>", [self displayName], self.remoteUri, (long)_port];
        }
        else {
            return [NSString stringWithFormat:@"\"%@\" <sip:%@>", [self displayName], self.remoteUri];
        }
    } else {
        return [NSString stringWithFormat:@"<sip:%@>", self.remoteUri];
    }
}

@end
