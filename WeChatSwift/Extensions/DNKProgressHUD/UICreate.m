//
//  UICreate.m
//  NewSmart
//
//  Created by 陈群 on 2022/1/21.
//

#import "UICreate.h"
#import "UIButton+Ext.h"


@implementation UICreate
#pragma mark - UILabel
+ (UILabel *)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)color {
    return [self labelWithText:text font:[UIFont systemFontOfSize:fontSize] textColor:color];
}
+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color {
    UILabel *label = UILabel.new;
    label.text = text;
    label.textColor = color;
    label.font = font;
    return label;
} 

#pragma mark - UIButton
+ (UIButton *)buttonWithNormalTitle:(nullable NSString *)title
                           fontSize:(CGFloat)fontSize
                         titleColor:(UIColor *)color
                          addTarget:(nullable id)target
                             action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIButton *)buttonWithNormalTitle:(NSString *)title
                         normalFont:(UIFont *)normalFont
                        normalColor:(UIColor *)normalColor
                      selectedTitle:(NSString *)selectedTitle
                       selectedFont:(UIFont *)selectedFont
                      selectedColor:(UIColor *)selectedColor
                          addTarget:(id)target 
                             action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:selectedTitle forState:UIControlStateSelected];
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:selectedColor forState:UIControlStateSelected];
    button.titleLabel.font = normalFont;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIButton *)buttonWithImage:(UIImage * _Nullable)image
                        title:(nullable NSString *)title
                     fontSize:(CGFloat)fontSize
                   titleColor:(UIColor *)color
                    addTarget:(nullable id)target
                       action:(nullable SEL)action {
    UIButton *button = [self buttonWithNormalTitle:title fontSize:fontSize titleColor:color addTarget:target action:action];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIButton *)buttonWithNormalImage:(UIImage *)normalImage 
                       seletedImage:(UIImage *)selectedImage
                          addTarget:(nullable id)target
                             action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    if (normalImage) {
        [button setImage:normalImage forState:UIControlStateNormal];
    }
    if (selectedImage) {
        [button setImage:selectedImage forState:UIControlStateSelected];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIButton *)buttonWithNormalImage:(UIImage *)normalImage
                         stateImage:(nullable UIImage *)stateImage
                              state:(UIControlState)state
                          addTarget:(nullable id)target action:(nullable SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    if (normalImage) {
        [button setImage:normalImage forState:UIControlStateNormal];
    }
    if (stateImage) {
        [button setImage:stateImage forState:state];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIButton *)buttonWithNormalImage:(UIImage *)normalImage
                       seletedImage:(UIImage *)selectedImage
                      disabledImage:(UIImage *)disabledImg
                          addTarget:(nullable id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    [button setImage:normalImage forState:UIControlStateNormal];
    if (selectedImage) {
        [button setImage:selectedImage forState:UIControlStateSelected];
    }
    if (disabledImg) {
        [button setImage:disabledImg forState:UIControlStateDisabled];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIButton *)buttonWithNormalImage:(UIImage *)normalImage normalTitle:(NSString *)normalTitle
                       seletedImage:(UIImage *)selectedImage seletedTitle:(NSString *)selectedTitle
                               font:(UIFont *)font
                        normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor
                          addTarget:(nullable id)target action:(SEL)action; {
    UIButton *button = [self buttonWithNormalImage:normalImage seletedImage:selectedImage addTarget:target action:action];
    [button setTitle:normalTitle forState:UIControlStateNormal];
    [button setTitle:selectedTitle forState:UIControlStateSelected];
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:selectedColor forState:UIControlStateSelected];
    button.titleLabel.font = font;
    return button;
}

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
                             action:(nullable SEL)action {
    
    UIButton *button = [self buttonWithNormalTitle:title fontSize:fontSize titleColor:titleColor addTarget:target action:action];
    button.backgroundColor = bgColor;
    return button;
}

#pragma mark -
#pragma mark -- image 为  backgroundImage

+ (UIButton *)buttonWithNormalBgImg:(UIImage *)normalImage seletedBgImg:(UIImage *)selectedImage addTarget:(nullable id)target action:(nullable SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    if (normalImage) {
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    }
    if (selectedImage) {
        [button setBackgroundImage:selectedImage forState:UIControlStateSelected];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)buttonWithNormalBgImg:(nullable UIImage *)normalImage normalTitle:(NSString *)normalTitle
                       seletedBgImg:(nullable UIImage *)selectedImage seletedTitle:(NSString *)selectedTitle
                               font:(UIFont *)font
                        normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor
                          addTarget:(nullable id)target action:(nullable SEL)action {
    UIButton *button = [self buttonWithNormalBgImg:normalImage seletedBgImg:selectedImage addTarget:target action:action];
    [button setTitle:normalTitle forState:UIControlStateNormal];
    [button setTitle:selectedTitle forState:UIControlStateSelected];
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:selectedColor forState:UIControlStateSelected];
    button.titleLabel.font = font;
    return button;
}



 
/// 创建一个适用TextField 的带图片的leftView
/// @param imageName 图片名称
+ (UIView *)leftViewWithImage:(NSString *)imageName {
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 55, 27.5)];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 27.5, 27.5)];
    imgView.image = [UIImage imageNamed:imageName];
    [leftView addSubview:imgView];
    return leftView;
}

/// 灰色下划线
+ (UIView *)grayUnderline {
    UIView *lineView = UIView.new;
    lineView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    return lineView;
}
#pragma mark - UIImageView
/// 向右的灰色尖头图标
+(UIImageView *)grayArrowView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_one"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}
/// 向右的灰色尖头图标
+(UIImageView *)grayBigArrowView {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_two"]];
    imgView.contentMode = UIViewContentModeCenter;
    return imgView;
}

+ (UIImageView *)imageViewWithImgName:(NSString *)imageName {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
}
#pragma mark - UISwtich
+ (UISwitch *)switchButton {
    return [self switchWithTarget:nil action:nil];
}
+ (UISwitch *)switchWithTarget:(nullable id)target action:(SEL)action {
    UISwitch *switchBtn = UISwitch.new;
//    switchBtn.onTintColor = UIColor.mainBlueColor;
    switchBtn.transform = CGAffineTransformMakeScale(1, 0.9);
    [switchBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return switchBtn;
}
#pragma mark - UIView
+ (UIView *)separatorView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, DNKDevice.navigationHeight, DNKDevice.screenWidth, 10)];
//    view.backgroundColor = UIColor.lightGrayBackgroundColor;
    return view;
}
+ (UIView *)dotViewWithColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius {
    UIView *dotView = UIView.new;
    dotView.backgroundColor = backgroundColor;
    dotView.layer.cornerRadius = cornerRadius;
    dotView.layer.masksToBounds = YES;
    return dotView;
}
@end
