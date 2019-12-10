//
//  VETCallCell.m
//  MobileVoip
//
//  Created by Liu Yang on 01/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETCallCell.h"

@implementation VETCallCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)tapSwitch:(id)sender
{
    UISwitch *switchButton = (UISwitch *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapSwitch:cell:)]) {
        [self.delegate tapSwitch:switchButton cell:self];
    }
}

@end
