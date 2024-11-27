//
//  UIButton+Ext.m
//  NewSmart
//
//  Created by Aliens on 2022/2/9.
//

#import "UIButton+Ext.h"
#import <objc/runtime.h>

@implementation UIButton (Ext)
- (void)adjustVerticalContentSpace:(CGFloat)space {
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    CGFloat labelWidth = self.titleLabel.intrinsicContentSize.width;
    CGFloat labelHeight = self.titleLabel.intrinsicContentSize.height;
    
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}
- (void)adjustContentSpace:(CGFloat)space imageInLeft:(BOOL)isLeft {
    UIEdgeInsets imageEdgeInsets, labelEdgeInsets;
    if (!isLeft) {
        CGFloat imageWith = self.imageView.image.size.width;
        CGFloat labelWidth = self.titleLabel.intrinsicContentSize.width;
        imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + space, 0, -labelWidth);
        labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith - space, 0, imageWith);
    } else {
        imageEdgeInsets = UIEdgeInsetsMake(0, -space/2, 0, space/2);
        labelEdgeInsets = UIEdgeInsetsMake(0, space/2, 0, -space/2);
    }
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}
/// 便携初始化方法
/// @param image image
/// @param title title
/// @param fontSize fontSize
/// @param color color
/// @param target target
/// @param action action
+ (instancetype)initWithWithImage:(nullable UIImage *)image
                            title:(NSString *)title
                         fontSize:(CGFloat)fontSize
                       titleColor:(UIColor *)color
                        addTarget:(id)target
                           action:(SEL)action {
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if(image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end


static char topEdgeKey;
static char leftEdgeKey;
static char bottomEdgeKey;
static char rightEdgeKey;

@implementation UIButton (EnlargedEdge)

- (void)setEnlargeEdge:(CGFloat)enlargeEdge {
    
    [self setEnlargeEdgeWithTop:enlargeEdge left:enlargeEdge bottom:enlargeEdge right:enlargeEdge];
    
}
-(void)setEnlargeEdgeWithTop:(CGFloat)top left:(CGFloat)left
                      bottom:(CGFloat)bottom right:(CGFloat)right {
    
    objc_setAssociatedObject(self, &topEdgeKey, [NSNumber numberWithFloat:top], 1);
    objc_setAssociatedObject(self, &leftEdgeKey, [NSNumber numberWithFloat:left], 1);
    objc_setAssociatedObject(self, &bottomEdgeKey, [NSNumber numberWithFloat:bottom], 1);
    objc_setAssociatedObject(self, &rightEdgeKey, [NSNumber numberWithFloat:right], 1);
    
}
- (CGFloat)enlargeEdge {
    
    return [(NSNumber *)objc_getAssociatedObject(self, &topEdgeKey) floatValue];
    
}

-(CGRect)enlargedRect {
    NSNumber *topEdge = objc_getAssociatedObject(self, &topEdgeKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &leftEdgeKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomEdgeKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &rightEdgeKey);
    if (topEdge && leftEdge && bottomEdge && rightEdge)
    {
        CGRect enlargeRect = CGRectMake(self.bounds.origin.x - leftEdge.floatValue, self.bounds.origin.y - topEdge.floatValue, self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue, self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
        return enlargeRect;
    }
    
    return self.bounds;
}
//hittest确定点击的对象
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.alpha <= 0.01 || !self.userInteractionEnabled || self.hidden)
    {
        return nil;
    }
    CGRect enlargedRect = [self enlargedRect];
    return CGRectContainsPoint(enlargedRect, point)?self:nil;
    
}
@end


