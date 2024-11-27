//
//  WXApiUtils.h
//  smarthome
//
//  Created by Aliens on 2021/6/24.
//  Copyright © 2021 dnake. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXApiUtils : NSObject

+(NSString *)deviceId;

+ (NSString *)getEncryptKey;
+ (NSString *)encryptKey;
+ (NSString *)decryptAESKey;
+ (NSString *)decryptAESOffset;


+ (NSString *)decryptDESOffset;


 
 
/// 检测网络是否真正可用 (比如连上未插入网线的路由器WiFi时,网络并不真正可用)
/// @param completion 完成回调
+ (void)checkNetworkActuallyAvailable:(void(^)(BOOL available))completion;


+ (NSData *)decryptResponseData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
