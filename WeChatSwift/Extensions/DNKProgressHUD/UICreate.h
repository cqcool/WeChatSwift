//
//  UICreate.h
//  NewSmart
//
//  Created by Aliens on 2022/1/21.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "WXDevice.h"

NS_ASSUME_NONNULL_BEGIN

/// 快速创建view 工具类
@interface UICreate : NSObject
+ (UILabel *)labelWithText:(nullable NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)color;
+ (UILabel *)labelWithText:(nullable NSString *)text font:(UIFont *)font textColor:(UIColor *)color;

#pragma mark - UIButton -- image 为普通image
+ (UIButton *)buttonWithNormalTitle:(nullable NSString *)title
                           fontSize:(CGFloat)fontSize
                         titleColor:(UIColor *)color
                          addTarget:(nullable id)target
                             action:(nullable SEL)action;
+ (UIButton *)buttonWithNormalTitle:(nullable NSString *)title
                         normalFont:(UIFont *)normalFont
                        normalColor:(UIColor *)normalColor
                      selectedTitle:(nullable NSString *)selectedTitle
                       selectedFont:(nullable UIFont *)normalFont
                      selectedColor:(nullable UIColor *)selectedColor
                          addTarget:(nullable id)target
                             action:(nullable SEL)action;
+ (UIButton *)buttonWithImage:(UIImage * _Nullable)image
                        title:(nullable NSString *)title
                     fontSize:(CGFloat)fontSize
                   titleColor:(UIColor *)color
                    addTarget:(nullable id)target action:(nullable SEL)action;

+ (UIButton *)buttonWithNormalImage:(UIImage * _Nullable)normalImage
                       seletedImage:(UIImage * _Nullable)selectedImage
                          addTarget:(nullable id)target 
                             action:(nullable SEL)action;
+ (UIButton *)buttonWithNormalImage:(UIImage *)normalImage
                         stateImage:(nullable UIImage *)stateImage
                              state:(UIControlState)state
                          addTarget:(nullable id)target
                             action:(nullable SEL)action;
+ (UIButton *)buttonWithNormalImage:(nullable UIImage *)normalImage
                        normalTitle:(NSString *)normalTitle
                       seletedImage:(nullable UIImage *)selectedImage
                       seletedTitle:(NSString *)selectedTitle
                               font:(UIFont *)font
                        normalColor:(UIColor *)normalColor
                      selectedColor:(UIColor *)selectedColor
                          addTarget:(nullable id)target
                             action:(nullable SEL)action;


+ (UIButton *)buttonWithNormalImage:(UIImage * _Nullable)normalImage
                       seletedImage:(UIImage * _Nullable)selectedImage
                      disabledImage:(UIImage * _Nullable)disabledImg
                          addTarget:(nullable id)target action:(nullable SEL)action;

#pragma mark -
#pragma mark -- image 为  backgroundImage
+ (UIButton *)buttonWithNormalBgImg:(UIImage *)normalImage seletedBgImg:(UIImage *)selectedImage addTarget:(nullable id)target action:(nullable SEL)action;
+ (UIButton *)buttonWithNormalBgImg:(nullable UIImage *)normalImage
                        normalTitle:(NSString *)normalTitle
                       seletedBgImg:(nullable UIImage *)selectedImage
                       seletedTitle:(NSString *)selectedTitle
                               font:(UIFont *)font
                        normalColor:(UIColor *)normalColor
                      selectedColor:(UIColor *)selectedColor
                          addTarget:(nullable id)target
                             action:(nullable SEL)action;



/// @param title 快速创建一个带背景色 和 文字描述的Button
/// @param fontSize 字体大小
/// @param titleColor 字体颜色
/// @param bgColor 按钮背景色
/// @param target target
/// @param action 动作
+ (UIButton *)buttonWithNormalTitle:(nullable NSString *)title
                           fontSize:(CGFloat)fontSize
                         titleColor:(UIColor *)titleColor backgroudColor:(UIColor *)bgColor
                          addTarget:(nullable id)target
                             action:(nullable SEL)action;
  
/// 创建一个适用TextField 的带图片的leftView
/// @param imageName 图片名称
+ (UIView *)leftViewWithImage:(NSString *)imageName;

/// 灰色下划线
+ (UIView *)grayUnderline;
#pragma mark - UIImageView
/// 向右的灰色尖头图标
+ (UIImageView *)grayArrowView;
+ (UIImageView *)grayBigArrowView;
+ (UIImageView *)imageViewWithImgName:(NSString *)imageName;
#pragma mark - UISwtich
+ (UISwitch *)switchButton;
+ (UISwitch *)switchWithTarget:(nullable id)target action:(nullable SEL)action;
#pragma mark - UIView
/// 导航栏底下的分隔视图，frame(0, navigationHeight, width, 10)
+ (UIView *)separatorView;
+ (UIView *)dotViewWithColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius;
@end

NS_ASSUME_NONNULL_END
