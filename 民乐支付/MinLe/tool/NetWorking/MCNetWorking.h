//
//  MCNetWorking.h
//  MizuCloud
//
//  Created by SZVETRON-iMAC on 16/8/24.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Complection)(NSDictionary *responseObject);
typedef void(^Failure)(NSError *error);

@interface MCNetWorking : NSObject

+ (MCNetWorking *)sharedInstance;
//Get请求
- (void)createGetWithUrlString:(NSString *)urlString withParameter:(NSDictionary *)params withComplection:(Complection)complection withFailure:(Failure)failure;
//自定义post请求
- (void)createPostWithUrlString:(NSString *)urlString withParameter:(NSDictionary *)params withComplection:(Complection)complection withFailure:(Failure)failure;
//循环post
- (void)createPostWithUrlArray:(NSArray *)urlArray withParameter:(NSArray *)paramsArray withComplection:(Complection)complection withFailure:(Failure)failure;
//不带加载菊花的
- (void)myPostWithUrlString:(NSString *)urlString withParameter:(NSDictionary *)params withComplection:(Complection)complection withFailure:(Failure)failure;
//自定义带菊花和加载文字的
- (void)createPostWithLoading:(NSString *)loadString withUrlString:(NSString *)urlString withParameter:(NSDictionary *)params withComplection:(Complection)complection withFailure:(Failure)failure;
//上传图片数组
- (void)myImageRequestWithUrlString:(NSString *)urlString withParameter:(NSDictionary *)params withKey:(NSString *)keyStr withImageArray:(NSArray *)imageArray withComplection:(Complection)complection withFailure:(Failure)failure;
//上传图片(没有加载框的)
- (void)reloadImageRequestWithUrlString:(NSString *)urlString withParameter:(NSDictionary *)params withKey:(NSString *)keyStr withImageArray:(NSArray *)imageArray withComplection:(Complection)complection withFailure:(Failure)failure;
//post请求html代码
- (void)htmlPostWithUrlString:(NSString *)urlString withParameter:(NSDictionary *)params withComplection:(Complection)complection withFailure:(Failure)failure;
@end
