//
//  VETCountryViewController.h
//  VETEphone
//
//  Created by Liu Yang on 28/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VETCountryBaseTableController.h"
#import "VETCountry.h"

typedef void(^SelectedCountryBlock)(VETCountry *country);

@interface VETCountryViewController : VETCountryBaseTableController

@property (nonatomic, assign) BOOL isSaveCountry;//是否保存点击后的国家城市

@property (nonatomic, copy) SelectedCountryBlock countryBlock;

@end
