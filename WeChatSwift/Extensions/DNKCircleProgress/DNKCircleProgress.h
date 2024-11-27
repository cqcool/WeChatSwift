//
//  DNKCircleProgress.h
//  NewSmart
//
//  Created by Aliens on 2022/6/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DNKCircleProgress : UIView
@property (readonly, weak, nonatomic) UILabel *percentLbl;
@property (nonatomic,assign) CGFloat trackWidth;
@property (nonatomic, strong) UIColor *progressColor;  //进度条颜色
@property (nonatomic, strong) UIColor *progressBgColor;  //进度条背景颜色

@property (nonatomic,assign) CGFloat progress;  // 0.0 .. 1.0, default is

- (instancetype)initWithTrackWidth:(CGFloat)trackWidth; 
@end

NS_ASSUME_NONNULL_END
