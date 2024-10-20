//
//  DNKApiUtils.h
//  smarthome
//
//  Created by 陈群 on 2021/6/24.
//  Copyright © 2021 dnake. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DNKApiUtils : NSObject

+(NSString *)deviceId;

+ (NSString *)encryptKey;
+ (NSString *)sign;
+ (NSString *)authorization;
+ (NSString *)rc4Key;
+ (NSString *)aesKey;


///// 解密i商家2.0 规程加密字符串
///// @param string 加密字符串
//+ (NSString *)dnk_decodeCloudRc4HexString:(NSString *)string;

/// 检测网络是否真正可用 (比如连上未插入网线的路由器WiFi时,网络并不真正可用)
/// @param completion 完成回调
+ (void)checkNetworkActuallyAvailable:(void(^)(BOOL available))completion;

@end

NS_ASSUME_NONNULL_END
