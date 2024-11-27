//
//  UIButton+Ext.h
//  NewSmart
//
//  Created by Aliens on 2022/2/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// UIButton 分类
@interface UIButton (Ext)

/// 调整带文字和图片Button 上图下文 之间的间距
/// @param space 间距
- (void)adjustVerticalContentSpace:(CGFloat)space;
/// 调整图像和文本间距
/// @param space 间距大小
/// @param isLeft YES: 左图右文 ， NO：左文右图
- (void)adjustContentSpace:(CGFloat)space
               imageInLeft:(BOOL)isLeft;


/// 便携初始化方法
/// @param image image
/// @param title title
/// @param fontSize fontSize
/// @param color color
/// @param target target
/// @param action action 
+ (instancetype)initWithWithImage:(nullable UIImage *)image title:(nullable NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)color addTarget:(nullable id)target action:(nullable SEL)action;
@end

@interface UIButton (EnlargedEdge)
/// 扩大button点击区域，扩大边际区域各个边距值相同
@property (nonatomic,assign) CGFloat enlargeEdge;

@end
NS_ASSUME_NONNULL_END
