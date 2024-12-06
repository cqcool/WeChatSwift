//
//  WXDevice.h
//  NewSmart
//
//  Created by Aliens on 2022/1/19.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//以6/6s为准宽度缩小系数
#define WidthScale [UIScreen mainScreen].bounds.size.width/375.0
#define HeightScale [UIScreen mainScreen].bounds.size.height/667.0 
 
static inline CGFloat wScale(void) {
    return [UIScreen mainScreen].bounds.size.width/375.0;
}
static inline CGFloat hScale(void) {
    return [UIScreen mainScreen].bounds.size.height/667.0;
}
@interface WXDevice : NSObject

+ (CGFloat)widthScale;
+ (CGFloat)heightScale;

+ (CGRect)bounds;
/// 屏幕宽度
+ (CGFloat)screenWidth;
/// 屏幕高度
+ (CGFloat)screenHeight;
/// 屏幕中心点
+ (CGPoint)center;
/// 导航栏高度
+ (CGFloat)navigationHeight;
/// 状态栏高度，状态栏被隐藏后，高度为0
+ (CGFloat)statusHeight;
/// tabBar高度
+ (CGFloat)tabBarHeight;
/// tabBar高度 + 底部安全区域
+ (CGFloat)tabBarAreaHeight;
/// 底部安全区域高度
+ (CGFloat)bottomSafeArea;

#pragma mark -
/// 系统版本
+ (CGFloat)systemVersion;

//判断刘海屏
+ (BOOL)isBangDevice;
///手机型号
+ (NSString *)phoneModel;

/// 应用版本信息
+ (NSString *)appVersion;

+ (CGFloat)hScale;

@end

NS_ASSUME_NONNULL_END
