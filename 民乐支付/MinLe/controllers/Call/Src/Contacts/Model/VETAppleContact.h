//
//  VETAppleContacts.h
//  VETEphone
//
//  Created by Liu Yang on 30/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VETMobileModel;
@interface VETAppleContact : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;

// fullname is firstName + lastName
@property (nonatomic, copy) NSString *fullName;

//  mobile model array
@property (nonatomic, retain) NSArray *mobileArray;

@property (nonatomic, copy) NSString *searchText;

@end

@interface VETMobileModel : NSObject

@property (nonatomic, retain) NSString *mobileType;
@property (nonatomic, retain) NSString *mobileContent;

- (instancetype)initWithMobileType:(NSString *)mobileType mobileNumber:(NSString *)mobileContent;

@end
