//
//  PickerWindowView.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 2017/2/17.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectedPickerRowDelegate <NSObject>

- (void)selectedPickerRow:(NSInteger)row;

@end

@interface PickerWindowView : UIView

@property (nonatomic, strong) NSArray *yearArray;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *tureBut;
@property (nonatomic, strong) UIButton *cancelBut;

@property (nonatomic, weak) id <SelectedPickerRowDelegate> delegate;

@end
