//
//  YTKBaseRequest+DNKProgressHUD.h
//  smarthome
//
//  Created by 陈群 on 2021/7/1.
//  Copyright © 2021 dnake. All rights reserved.
//

#import "YTKBaseRequest.h"
#import "DNKProgressHUD.h"
NS_ASSUME_NONNULL_BEGIN

@interface YTKBaseRequest (DNKProgressHUD)

/// 接口请求中，是否显示loading HUD
/// @param networkingHUD YES显示，NO不显示
- (void)setNetworkingHUD:(BOOL)networkingHUD;
/// 接口请求响应错误，是否显示提示框
/// @param showFailureHUD YES显示，NO不显示
- (void)setShowFailureHUD:(BOOL)showFailureHUD;
/// 显示错误消息 Toast
- (void)showApiMsgHUD:(NSString *)msg;
- (void)showApiMsgHUD;


@end

NS_ASSUME_NONNULL_END
