//
//  UIColor+Ext.h
//  NewSmart
//
//  Created by 陈群 on 2022/1/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 根据颜色16进制值 + 透明度获取对应的UIColor 对象
/// - Parameters:
///   - hex: 颜色16进制值
///   - alpha: 透明度
static inline UIColor* hexAColor(NSInteger hex, CGFloat alpha) {
    CGFloat red = ((hex & 0xFF0000) >> 16) / 255.0;
    CGFloat green = ((hex & 0xFF00) >> 8) / 255.0;
    CGFloat blue = (hex & 0xFF) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

/// 根据颜色16进制值 获取对应的UIColor 对象
/// - Parameter hex: 颜色16 进制值
static inline UIColor* hexColor(NSInteger hex) {
    return hexAColor(hex, 1);
}

/// 颜色 类别
@interface UIColor (Ext)
/// 标准蓝色（0x466FF7）
+ (UIColor *)mainBlueColor;
/// 禁用时显示的蓝色（0x466FF7） alpha 0.5
+ (UIColor *)disableBlueColor;
/// 辅助色（浅一点的橙色 FB9B5B）
+ (UIColor *)mainOrangeColor;
/// 次要橙色 0xFFA544
+ (UIColor *)minorOrangeColor;
/// 浅绿色 0x51BE46
+ (UIColor *)tintGreentColor;
/// tabbar灰色 0xEEF1F4
+ (UIColor *)mainGrayColor;
/// 图标默认底色（灰）  EEEEEE
+ (UIColor *)lightGrayBackgroundColor;
/// 浅灰色背景色拖 F4F4F4
+ (UIColor *)lightGrayBackgroundColorTow; 
/// 警告色（红） 0xB22323
+ (UIColor *)warnColor;
/// 警告色 （黄） 0xF3CB45
+ (UIColor *)warnYellowColor;
/// 红色 0xD92D2D
+ (UIColor *)mainRedColor;
#pragma mark text
/// 一级文字颜色 （333333）
+ (UIColor *)mainTextColor;
/// 二级文字颜色 （666666）
+ (UIColor *)minorTextColor;
/// 辅助文字颜色 （999999）
+ (UIColor *)assistTextColor;
/// 设备离线文本颜色 0xC3C3C3
+ (UIColor *)offlineTextColor;

+ (UIColor *)color2B2B2B;
+ (UIColor *)color9D9D9D;
+ (UIColor *)lightGrayTitleColor;


#pragma mark bg
+ (UIColor *)colorF5F6FA;
+ (UIColor *)colorEEEEEE;
+ (UIColor *)colorD0D0D0;
+ (UIColor *)colorF7F7F7;

#pragma mark line bg

/// 0xF7F7F7
+ (UIColor *)lightLineColor;

/// 0x7D7D7D
+ (UIColor *)darkLineColor;

/// UIColor 转16进制颜色
/// @param color UIColor 对象
+ (NSString *)hexFromUIColor:(UIColor *)color;

/// 16进制字符串转颜色
/// @param hexStirng 16进制字符串
/// @param alpha 透明度
+ (UIColor *)colorWithHexString:(NSString *)hexStirng
                          alpha:(CGFloat)alpha;

/// 16 进制字符串转颜色
/// @param hexStirng 16 进制字符串
+ (UIColor *)colorWithHexString:(NSString *)hexStirng;
@end

NS_ASSUME_NONNULL_END
