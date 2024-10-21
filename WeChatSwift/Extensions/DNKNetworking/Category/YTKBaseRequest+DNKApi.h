//
//  YTKBaseRequest+DNKApi.h
//  smarthome
//
//  Created by 陈群 on 2021/6/24.
//  Copyright © 2021 dnake. All rights reserved.
//

#import "YTKBaseRequest.h"
#import <YTKNetwork.h>
#import "YTKBaseRequest+DNKProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN



@interface YTKBaseRequest (DNKApi) 

- (id)apiData;
/// 服务端返回的请求结果失败时，返回服务端的描述信息
///
/// @Note apiSuccess返回YES时，返回值为nil。请求完成时可用
///
/// @return 服务端返回的msg内容
- (NSString *)apiMessage;

/// 服务器 请求时 接口返回的code
- (NSInteger)apiCode;

/// 请求服务器是否成功、并且接口返回正确的数据
- (BOOL)apiSuccess;
- (NSError *)dnkError;
/// 动态构建接口参数(未加密)
- (NSDictionary *)dnk_dynamicBuildParameter;

//- (NSDictionary *)dnk_encryptParm:(NSString *)parmJson; 
/// 请求头
- (NSDictionary<NSString *, NSString *> *)dnk_requestHeader;

/// YES：服务端校验api参数引起的失败   NO：请求失败
- (BOOL)apiValidateFailureOfService;

/// 开始请求接口
/// @param showNetworkingHUD YES：显示 loading hud，NO：不显示
/// @param showFailureHUD YES：接口相应失败时弹窗，NO：不弹窗 目前设置没效果。debug 模式显示 错误弹窗 非debug模式不显示错误弹窗
/// @param success 成功执行的block
/// @param failure 失败执行的block
- (void)startWithNetworkingHUD:(BOOL)showNetworkingHUD
                showFailureHUD:(BOOL)showFailureHUD
                       success:(nullable YTKRequestCompletionBlock)success
                       failure:(nullable YTKRequestCompletionBlock)failure;

@end

NS_ASSUME_NONNULL_END
