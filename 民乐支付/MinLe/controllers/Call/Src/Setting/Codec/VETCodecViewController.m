//
//  VETCodecViewController.m
//  VETEphone
//
//  Created by Liu Yang on 05/04/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import "VETCodecViewController.h"
#import "VETCodecCell.h"
#import "VETVoip.h"

@interface VETCodecViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, VETCodecCellDelegate>

@property (nonatomic, strong) NSMutableArray *codecArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation VETCodecViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Audio", @"Settings");
    
    _codecArray = [[NSMutableArray alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame
                                   style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
    
    [self setupDatas];
}

- (void)setupDatas
{
//    NSArray *gsCodecArray = [[VETVoipManager sharedManager] queryCodec];
//    NSMutableArray *codecArray = [NSMutableArray array];
//    for (VETVoipCodecInfo *remoteCodec in gsCodecArray) {
//        VETCodecInfo *localCodec = [[VETCodecInfo alloc] initWithCodecId:remoteCodec.codecId priority:remoteCodec.priority];
//        [codecArray addObject:localCodec];
//    }
//    [[VETUserManager sharedInstance] insertOrUpdateCodecArray:[codecArray copy]];
    [_codecArray addObjectsFromArray:[[VETUserManager sharedInstance] queryCodec]];
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_codecArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellId = @"codec";
    VETCodecCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[VETCodecCell alloc] initWithStyle:UITableViewCellStyleValue1
                   reuseIdentifier:cellId];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    VETCodecInfo *codec = [_codecArray objectAtIndex:[indexPath row]];
    cell.codecInfo = codec;
    return cell;
}

- (void)tapSwitch:(UISwitch *)codecSwitch cell:(VETCodecCell *)cell
{
    UISwitch *switchButton = codecSwitch;
    BOOL isButtonOn = [switchButton isOn];
    VETCodecInfo *codec = cell.codecInfo;
    if (isButtonOn) {
        BOOL status = [[VETVoipManager sharedManager] updatePriorityWithCodecId:codec.codecId priority:[self priorityForCodec:codec.codecId]];
        if (status) {
            [[VETUserManager sharedInstance] setCodecInfo:cell.codecInfo priority:[self priorityForCodec:codec.codecId]];
        }
        else {
           // [self showHint:NSLocalizedString(@"Setting error", @"Alert text")];
            [switchButton setOn:!isButtonOn];
        }
    }else {
        BOOL status = [[VETVoipManager sharedManager] updatePriorityWithCodecId:codec.codecId priority:0];
        if (status) {
            [[VETUserManager sharedInstance] setCodecInfo:cell.codecInfo priority:0];
        }
        else {
           // [self showHint:NSLocalizedString(@"Setting error", @"Alert text")];
            [switchButton setOn:!isButtonOn];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    VETCodecInfo *codec = [_codecArray objectAtIndex:[indexPath row]];
//    [[GSUserAgent sharedAgent] modifyCodecInfo:codec.codecId priority:110];
//    [self reloadData];
//    
//    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 300)];
//    [self.view addSubview:pickerView];
//    NSUInteger i = [pickerView numberOfRowsInComponent:4];
//    pickerView.dataSource = self;
//    [pickerView ]
}

//- (void)reloadData
//{
//    NSArray *gsCodecArray = [[GSUserAgent sharedAgent] arrayOfAvailableCodecs];
//    //  查询新增VETCodecInfo
//    if (_codecArray == nil || [_codecArray count] == 0) {
//        for (NSUInteger i = 0; i < gsCodecArray.count; i++) {
//            GSCodecInfo *codeInfo = gsCodecArray[i];
//            VETCodecInfo *vetCodec = [[VETCodecInfo alloc] initWithCodecId:[[NSString alloc] initWithString:codeInfo.codecId] priority:codeInfo.priority];
//            [_codecArray addObject:vetCodec];
//        }
//    }
//    //  更新优先级
//    else {
//        for (VETCodecInfo *vetCodec in _codecArray) {
//            for (GSCodecInfo *gsCodec in gsCodecArray) {
//                if ([gsCodec.codecId isEqualToString:vetCodec.codecId]) {
//                    vetCodec.priority = gsCodec.priority;
//                }
//            }
//        }
//    }
//    [_tableView reloadData];
//}

#pragma mark - picker view

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"wefwef";
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 4;
}

@end
