//
//  MCNetWorking.m
//  MizuCloud
//
//  Created by SZVETRON-iMAC on 16/8/24.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MCNetWorking.h"
#import <AFNetworking/AFNetworking.h>
#import "AFNetworkReachabilityManager.h"
#import "MBProgressHUD.h"
#import "CCUtity.h"

@interface MCNetWorking ()
{
    AFNetworkReachabilityStatus _status;
}
@end

@implementation MCNetWorking

- (instancetype)init
{
    self = [super init];
    if (self) {
        _status = AFNetworkReachabilityStatusUnknown;
    }
    return self;
}

+ (MCNetWorking *)sharedInstance {
    static MCNetWorking *netWorking = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWorking = [[MCNetWorking alloc] init];
    });
    return netWorking;
}

//Get请求
- (void)createGetWithUrlString:(NSString *)urlString withParameter:(NSDictionary *)params withComplection:(Complection)complection withFailure:(Failure)failure
{
    [self checkNetwork];
    if (_status == AFNetworkReachabilityStatusNotReachable) {
        //网络无连接的提示
        [[MBProgressHUD shareManager] ShowMessage:[CommenUtil LocalizedString:@"NoNetworkMsg"] showView:nil];
    } else {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([CCUtity requestJSONIsNotNil:responseObject]) {
                NSDictionary *dic = [CCUtity requestJSONOfDictionary:responseObject];
                if (complection) {
                    complection(dic);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    }
}

//不带菊花的
- (void)myPostWithUrlString:(NSString *)urlString withParameter:(NSDictionary *)params withComplection:(Complection)complection withFailure:(Failure)failure
{
    [self checkNetwork];
    if (_status == AFNetworkReachabilityStatusNotReachable) {
        //网络无连接的提示
        [[MBProgressHUD shareManager] ShowMessage:[CommenUtil LocalizedString:@"NoNetworkMsg"] showView:nil];
    } else {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([CCUtity requestJSONIsNotNil:responseObject]) {
                NSDictionary *dic = [CCUtity requestJSONOfDictionary:responseObject];
                if (complection) {
                    complection(dic);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    }
}

//带菊花的
- (void)createPostWithUrlString:(NSString *)urlString withParameter:(NSDictionary *)params withComplection:(Complection)complection withFailure:(Failure)failure
{
    [self checkNetwork];
    if (_status == AFNetworkReachabilityStatusNotReachable) {
        //网络无连接的提示
        [[MBProgressHUD shareManager] ShowMessage:[CommenUtil LocalizedString:@"NoNetworkMsg"] showView:nil];
    } else {
        MBProgressHUD *hud = [[MBProgressHUD shareInstance] showLoding:[CommenUtil LocalizedString:@"Loading..."] showView:nil];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"-----------%@",str);
            if ([CCUtity requestJSONIsNotNil:responseObject]) {
                NSDictionary *dic = [CCUtity requestJSONOfDictionary:responseObject];
                if (complection) {
                    complection(dic);
                }
                [hud hide:YES];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
            [hud hide:YES];
        }];
    }
}

//自定义带菊花和加载文字的
- (void)createPostWithLoading:(NSString *)loadString withUrlString:(NSString *)urlString withParameter:(NSDictionary *)params withComplection:(Complection)complection withFailure:(Failure)failure
{
    [self checkNetwork];
    if (_status == AFNetworkReachabilityStatusNotReachable) {
        //网络无连接的提示
        [[MBProgressHUD shareManager] ShowMessage:[CommenUtil LocalizedString:@"NoNetworkMsg"] showView:nil];
    } else {
        MBProgressHUD *hud = [[MBProgressHUD shareInstance] showLoding:loadString showView:nil];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([CCUtity requestJSONIsNotNil:responseObject]) {
                NSDictionary *dic = [CCUtity requestJSONOfDictionary:responseObject];
                if (complection) {
                    complection(dic);
                }
                [hud hide:YES];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
            [hud hide:YES];
        }];
    }
}

//循环post
- (void)createPostWithUrlArray:(NSArray *)urlArray withParameter:(NSArray *)paramsArray withComplection:(Complection)complection withFailure:(Failure)failure
{
    [self checkNetwork];
    if (_status == AFNetworkReachabilityStatusNotReachable) {
        //网络无连接的提示
        [[MBProgressHUD shareManager] ShowMessage:[CommenUtil LocalizedString:@"NoNetworkMsg"] showView:nil];
    } else {
        MBProgressHUD *hud = [[MBProgressHUD shareInstance] showLoding:[CommenUtil LocalizedString:@"Loading..."] showView:nil];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        for (int i = 0; i < urlArray.count; i++) {
            [manager POST:urlArray[i] parameters:paramsArray[i] progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([CCUtity requestJSONIsNotNil:responseObject]) {
                    NSDictionary *dic = [CCUtity requestJSONOfDictionary:responseObject];
                    if (complection) {
                        complection(dic);
                    }
                    [hud hide:YES];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(error);
                [hud hide:YES];
            }];
        }
    }
}

//上传图片
- (void)myImageRequestWithUrlString:(NSString *)urlString withParameter:(NSDictionary *)params withKey:(NSString *)keyStr withImageArray:(NSArray *)imageArray withComplection:(Complection)complection withFailure:(Failure)failure
{
    [self checkNetwork];
    if (_status == AFNetworkReachabilityStatusNotReachable) {
        //网络无连接的提示
        [[MBProgressHUD shareManager] ShowMessage:[CommenUtil LocalizedString:@"NoNetworkMsg"] showView:nil];
    } else {
        MBProgressHUD *hud = [[MBProgressHUD shareInstance] showLoding:[CommenUtil LocalizedString:@"HardCross..."] showView:nil];
        //表单请求，上传文件
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
        //manager.requestSerializer.timeoutInterval = 8;
        [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
            for (int i = 0; i < imageArray.count; i++) {
                //压缩图片
                NSMutableData *imageData = [UIImageJPEGRepresentation(imageArray[i], 1) mutableCopy];
                float imgLenth = imageData.length;
                float minImgLenth = 200*1024;//最小图片上传大小
                imageData = [UIImageJPEGRepresentation(imageArray[i],minImgLenth/imgLenth) mutableCopy];
                //可以在上传时使用当前的系统事件作为文件名
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat =@"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                //上传的参数(上传图片，以文件流的格式)
                if (imageArray.count == 1) {
                    [formData appendPartWithFileData:imageData
                                                name:[NSString stringWithFormat:@"%@",keyStr]//服务器要的参数名
                                            fileName:[NSString stringWithFormat:@"%@.jpg",str]
                                            mimeType:@"image/jpeg"];
                } else {
                    [formData appendPartWithFileData:imageData
                                                name:[NSString stringWithFormat:@"%@%d",keyStr,i]//服务器要的参数名
                                            fileName:[NSString stringWithFormat:@"%@%d.jpg",str, i]
                                            mimeType:@"image/jpeg"];
                }
            }
        } progress:^(NSProgress *_Nonnull uploadProgress) {
            //打印下上传进度
            NSLog(@"%@", uploadProgress);
        } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            [hud hide:YES];
            //上传成功
            if ([CCUtity requestJSONIsNotNil:responseObject]) {
                NSDictionary *dic = [CCUtity requestJSONOfDictionary:responseObject];
                if (complection) {
                    complection(dic);
                }
                
            }
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
            [hud hide:YES];
            //上传失败
            if (failure) {
                failure(error);
            }
        }];
    }
}

//上传图片(没有加载框的)
- (void)reloadImageRequestWithUrlString:(NSString *)urlString withParameter:(NSDictionary *)params withKey:(NSString *)keyStr withImageArray:(NSArray *)imageArray withComplection:(Complection)complection withFailure:(Failure)failure
{
    [self checkNetwork];
    if (_status == AFNetworkReachabilityStatusNotReachable) {
        //网络无连接的提示
        [[MBProgressHUD shareManager] ShowMessage:[CommenUtil LocalizedString:@"NoNetworkMsg"] showView:nil];
    } else {
        //表单请求，上传文件
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
        //manager.requestSerializer.timeoutInterval = 8;
        [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
            for (int i = 0; i < imageArray.count; i++) {
                //压缩图片
                NSMutableData *imageData = [UIImageJPEGRepresentation(imageArray[i], 1) mutableCopy];
                float imgLenth = imageData.length;
                float minImgLenth = 200*1024;//最小图片上传大小
                imageData = [UIImageJPEGRepresentation(imageArray[i],minImgLenth/imgLenth) mutableCopy];
                //可以在上传时使用当前的系统事件作为文件名
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat =@"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                //上传的参数(上传图片，以文件流的格式)
                if (imageArray.count == 1) {
                    [formData appendPartWithFileData:imageData
                                                name:[NSString stringWithFormat:@"%@",keyStr]//服务器要的参数名
                                            fileName:[NSString stringWithFormat:@"%@.jpg",str]
                                            mimeType:@"image/jpeg"];
                } else {
                    [formData appendPartWithFileData:imageData
                                                name:[NSString stringWithFormat:@"%@%d",keyStr,i]//服务器要的参数名
                                            fileName:[NSString stringWithFormat:@"%@%d.jpg",str, i]
                                            mimeType:@"image/jpeg"];
                }
            }
        } progress:^(NSProgress *_Nonnull uploadProgress) {
            //打印下上传进度
            NSLog(@"%@", uploadProgress);
        } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            //上传成功
            if ([CCUtity requestJSONIsNotNil:responseObject]) {
                NSDictionary *dic = [CCUtity requestJSONOfDictionary:responseObject];
                if (complection) {
                    complection(dic);
                }
                
            }
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
            //上传失败
            if (failure) {
                failure(error);
            }
        }];
    }
}

//检查网络状况
- (void)checkNetwork
{
    //网络连接单例
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    //打开检测
    [reachabilityManager startMonitoring];
    //检测网络连接的代码块回调
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        _status = status;
    }];
}

//post请求html代码
- (void)htmlPostWithUrlString:(NSString *)urlString withParameter:(NSDictionary *)params withComplection:(Complection)complection withFailure:(Failure)failure
{
    [self checkNetwork];
    if (_status == AFNetworkReachabilityStatusNotReachable) {
        //网络无连接的提示
        [[MBProgressHUD shareManager] ShowMessage:[CommenUtil LocalizedString:@"NoNetworkMsg"] showView:nil];
    } else {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSData *data = responseObject;
            if (data && data.length > 0) {
                NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSDictionary *dic = @{@"html":str};
                if (complection) {
                    complection(dic);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    }
}

@end















