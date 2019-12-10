//
//  VETDialpadButton.m
//  VETEphone
//
//  Created by young on 17/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import "VETDialpadButton.h"

@implementation VETDialpadButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
    }
    return self;
}

- (void)setSubText:(NSString *)subText
{
    _subText = subText;
    float offset = -5;
    double fontSize = 14;
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        offset = -3;
        fontSize = 12;
    }
    [self formatLabelForButton:self withHeight:self.frame.size.height andVerticalOffset:offset andText:subText withFontSize:fontSize withFontColor:MAINTHEMECOLOR andBoldFont:NO withTag:1000];
}

- (void) formatLabelForButton: (UIButton *) button withHeight: (double) height andVerticalOffset:(double) offset andText: (NSString *) labelText withFontSize: (double) fontSize withFontColor: (UIColor *) color andBoldFont:(BOOL) formatAsBold withTag: (NSInteger) tagNumber {
    
    // Get width of button
    
    // Initialize buttonLabel
//    UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, offset, 50, 21)];
    UILabel *subLabel = [UILabel new];

    // Set font size and weight of label
    if (formatAsBold) {
        subLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    }
    else {
        subLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    
    // set font color of label
    subLabel.textColor = color;
    
    // Set background color, text, tag, and font
    subLabel.backgroundColor = [UIColor clearColor];
    subLabel.text = labelText;
    subLabel.tag = tagNumber;
    
    // Center label
    subLabel.textAlignment = NSTextAlignmentCenter;
    
    // Add label to button
    [button addSubview:subLabel];
    
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        subLabel.adjustsFontSizeToFitWidth = YES;
        subLabel.contentMode = UIViewContentModeScaleAspectFill;
    }

    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button.titleLabel.mas_bottom).offset(offset).priorityHigh();
        make.centerX.mas_equalTo(button.mas_centerX);
        make.bottom.mas_equalTo(button.mas_bottom).offset(0).priorityLow();
    }];
} // End formatLabelForButton

@end
