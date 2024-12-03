//
//  WXProgressHUD.m
//  NewSmart
//
//  Created by Aliens on 2022/1/14.
//

#import "WXProgressHUD.h"
#import <MBProgressHUD.h>
#import "UICreate.h"
#import "DNKCircleProgress.h"
#import <Masonry.h>
@interface WXProgressHUD ()

@property(strong, nonatomic) MBProgressHUD *hud;
@property (weak, nonatomic) DNKCircleProgress *circleProgress;

@end

@implementation WXProgressHUD

+ (WXProgressHUD *)sharedInstance {
    static WXProgressHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WXProgressHUD alloc] init];
    });
    return instance;
}
+ (void)showProgress {
    [WXProgressHUD showProgressMsg:nil];
}
+ (void)showProgressMsg:(nullable NSString *)message {
    return [WXProgressHUD showProgressMsg:message maskView:nil];
}
+ (void)showProgressMsg:(nullable NSString *)message maskView:(nullable UIView *)maskView {
    [self hiddenProgressHUD];
    maskView = [self maskViewWithMaskView:maskView];
    //bugly 上报 有的时候keywindow 为nil 导致崩溃
    if (maskView == nil) {
        return ;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:maskView animated:YES];
    [WXProgressHUD sharedInstance].hud = hud;
    hud.label.text = message;
    hud.label.numberOfLines = 2;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor=[UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.8];
    hud.contentColor=[UIColor whiteColor];//字的颜色
    [hud showAnimated:YES];
//    [hud addBounceAnimationWithInitialScale:0 peakScale:0.5];
}
+ (void)setProgressMessage:(NSString *)message {
    [WXProgressHUD sharedInstance].hud.label.text = message;
}
+ (void)hiddenProgressHUD {
    [self hiddenProgressHUDWithDelay:-1];
}
+ (void)hiddenProgressHUDWithDelay:(NSInteger)delay {
    WXProgressHUD *sharedHUD = [WXProgressHUD sharedInstance];
    if (delay) {
        [sharedHUD.hud hideAnimated:YES afterDelay:delay];
        return;
    }
    [sharedHUD.hud hideAnimated:YES];
}
/// toast提示
+ (void)brieflyProgressMsg:(nullable NSString *)message {
    [WXProgressHUD brieflyProgressMsg:message duration:0];
}
+ (void)brieflyProgressMsg:(nullable NSString *)message duration:(NSTimeInterval)duration {
    dispatch_async(dispatch_get_main_queue(), ^{
        [WXProgressHUD brieflyProgressMsg:message maskView:nil duration:duration];
    });
}
+ (void)brieflyProgressMsg:(nullable NSString *)message maskView:(nullable UIView *)maskView duration:(NSTimeInterval)duration {
    if (message == nil || message.length == 0) {
        return;
    }
    [WXProgressHUD hiddenProgressHUD];
    if (duration == 0) {
        NSInteger length = (message.length - 6);
        duration = (length > 0) ? (1.5+length*0.1) : 1;
        duration = duration < 10 ? duration : 10;
    }
    [[WXProgressHUD sharedInstance] progressMsg:message maskView:maskView duration:duration];
}
- (void)progressMsg:(NSString *)message maskView:(nullable UIView *)maskView duration:(NSTimeInterval)duration {
    maskView = [WXProgressHUD maskViewWithMaskView:maskView];
    // bugly 上报 有的时候keywindow 为nil 导致崩溃
    if (!maskView) {
        return;
    }
    NSString *text = message ?: @"";
    self.hud = [MBProgressHUD showHUDAddedTo:maskView animated:YES];
    self.hud.label.text = text;
    self.hud.label.numberOfLines = -1;
    self.hud.mode = MBProgressHUDModeText;
    // 黑色背景白字
    self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.bezelView.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.8];
    //字的颜色
    self.hud.contentColor = [UIColor whiteColor];
    self.hud.userInteractionEnabled = NO;
    [self.hud hideAnimated:YES afterDelay:duration];
//    [self.hud addBounceAnimationWithInitialScale:0 peakScale:0.5];
}

 
#pragma mark - loading progress
+ (void)loadingViewMsg:(nullable NSString *)message maskView:(nullable UIView *)maskView {
    [self hiddenProgressHUD];
    maskView = [self maskViewWithMaskView:maskView];
    //bugly 上报 有的时候keywindow 为nil 导致崩溃
     if (maskView == nil) {
        return;
    }
    [[WXProgressHUD sharedInstance] loadingViewMsg:message maskView:maskView];
    return;
}
- (void)loadingViewMsg:(nullable NSString *)message maskView:(nullable UIView *)maskView  {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:maskView animated:YES];
    self.hud = hud;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [self buildLoadingProgressViewWithMsg:message];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
}
- (UIView *)buildLoadingProgressViewWithMsg:(NSString *)msg {
    UIView *customView = UIView.new;
    DNKCircleProgress *circleProgress = [[DNKCircleProgress alloc] initWithTrackWidth:8];
    [customView addSubview:circleProgress];
    self.circleProgress = circleProgress;
    circleProgress.backgroundColor = UIColor.clearColor;
    circleProgress.percentLbl.textColor = UIColor.whiteColor;
    if (msg != nil) {
        [circleProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(74, 74));
            make.edges.equalTo(customView);
        }];
        return customView;
    }
    [circleProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(74, 74));
        make.top.offset(8);
        make.centerX.equalTo(customView);
    }];
    UIFont *font = [UIFont systemFontOfSize:14];
    CGFloat msgWidth = [msg sizeWithAttributes:@{NSFontAttributeName:font}].width + 1;
    CGFloat customWidth = msgWidth > 74 ? msgWidth : 74;
    UILabel *tipsLbl = [UICreate labelWithText:msg font:font textColor:UIColor.whiteColor];
    [customView addSubview:tipsLbl];
    tipsLbl.numberOfLines = 0;
    tipsLbl.textAlignment = NSTextAlignmentCenter;
    [tipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(circleProgress.mas_bottom).offset(15);
        make.left.right.offset(0);
        make.bottom.offset(-8);
        make.width.offset(customWidth);
    }];
    
    return customView;
}
+ (void)setProgress:(CGFloat)progress {
    if ([WXProgressHUD sharedInstance].hud.mode == MBProgressHUDModeCustomView) {
        [WXProgressHUD sharedInstance].circleProgress.progress = progress;
        return;
    }
    [WXProgressHUD sharedInstance].hud.progress = progress;
}
+(UIView *)maskViewWithMaskView:(UIView *)maskView {
    return maskView ?: [UIApplication sharedApplication].keyWindow;
}

@end
