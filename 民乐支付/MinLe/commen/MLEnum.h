//
//  MLEnum.h
//  weifoupay
//
//  Created by JP on 2017/11/7.
//  Copyright © 2017年 Zu Hai Hu. All rights reserved.
//

#ifndef MLEnum_h
#define MLEnum_h

//认证状态
typedef NS_ENUM(NSUInteger, AuthState) {
    AuthStateNomarl = 0,       /**< 默认 */
    AuthStateNoProfile = 1,    /**< 信息认证没通过 */
    AuthStateT0NoOpen = 2,     /**< T0通道没缴纳开通费 */
    AuthStateNoCardNoRegister = 3, /**< 无卡没注册 */
    AuthStateSuccess = 4,       /**< 认证正常，可以交易 */
    AuthStateError = 5       /**< 异常错误 */
};

//T0通道认证状态
typedef NS_ENUM(NSUInteger, T0State) {
    T0StateNomarl = 0,       /**< 默认 */
    T0StateError = 1,    /**< T0通道认证没通过 */
    T0StateSuccess = 2     /**< T0通道认证已开通 */
};

#endif /* MLEnum_h */
