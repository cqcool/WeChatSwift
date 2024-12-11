//
//  WXProgressHUD.h
//  NewSmart
//
//  Created by Aliens on 2022/1/14.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXProgressHUD : NSObject
+ (void)showProgress;
+ (void)showProgressMsg:(nullable NSString *)message;
+ (void)showProgressMsg:(nullable NSString *)message maskView:(nullable UIView *)maskView;
+ (void)showCircleProgressMsg:(nullable NSString *)message;
/// 更改HUD显示的消息，已经显示load HUD才能正常执行
+ (void)setProgressMessage:(NSString *)message;
+ (void)hiddenProgressHUD;
+ (void)hiddenProgressHUDWithDelay:(NSInteger)delay;
/// toast提示
+ (void)brieflyProgressMsg:(nullable NSString *)message;
+ (void)brieflyProgressMsg:(nullable NSString *)message duration:(NSTimeInterval)duration;
/// @Param duration 为0时，使用默认逻辑设置时间
+ (void)brieflyProgressMsg:(nullable NSString *)message maskView:(nullable UIView *)maskView duration:(NSTimeInterval)duration;

/// 显示无权限弹框
+ (void)showNoPermission;
#pragma mark - loading progress
+ (void)loadingViewMsg:(nullable NSString *)message maskView:(nullable UIView *)maskView;
+ (void)setProgress:(CGFloat)progress;

+ (void)loadingCircleViewMsg:(nullable NSString *)message maskView:(nullable UIView *)maskView ;

+ (void)wxPayProgress;

@end

NS_ASSUME_NONNULL_END
