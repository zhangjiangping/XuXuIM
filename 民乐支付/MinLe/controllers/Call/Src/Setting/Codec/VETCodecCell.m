//
//  VETCodecCellTest.m
//  MobileVoip
//
//  Created by Liu Yang on 01/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETCodecCell.h"
#import "VETVoip.h"

/***********************************************************
 *  VETCodecInfo
 ***********************************************************/
@implementation VETCodecInfo

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.codecId = [aDecoder decodeObjectForKey:@"codecId"];
        self.priority = [aDecoder decodeObjectForKey:@"priority"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.codecId forKey:@"codecId"];
    [aCoder encodeObject:self.priority forKey:@"priority"];
}

- (instancetype)initWithCodecId:(NSString *)codecId priority:(NSUInteger)priority
{
    if (self == [super init]) {
        _codecId = codecId;
        _priority = [NSNumber numberWithInteger:priority];
    }
    return self;
}

@end

/***********************************************************
 *  VETCodecCell
 ***********************************************************/
@interface VETCodecCell ()

@end

@implementation VETCodecCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)setCodecInfo:(VETCodecInfo *)codecInfo
{
    _codecInfo = codecInfo;
    self.switchBtn.on = [codecInfo.priority integerValue] > 0 ? YES : NO;
    [[self textLabel] setText:codecInfo.codecId];
}

- (void)tapSwitch:(id)sender
{
    UISwitch *switchButton = (UISwitch *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapSwitch:cell:)]) {
        [self.delegate tapSwitch:switchButton cell:self];
    }
}

@end
