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
#import "WeChatSwift-Swift.h"
#import "UIColor+Ext.h"
#import <Masonry.h>
@interface WXProgressHUD ()

@property(strong, nonatomic) MBProgressHUD *hud;
@property (weak, nonatomic) DNKCircleProgress *circleProgress;
@property (weak, nonatomic) LoadingCircle *circleView;

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
    [WXProgressHUD showProgressMsg:@"正在加载"];
}
+ (void)showProgressMsg:(nullable NSString *)message {
    return [WXProgressHUD showProgressMsg:message maskView:nil];
}
+ (void)showProgressMsg:(nullable NSString *)message maskView:(nullable UIView *)maskView {
    [self hiddenProgressHUD];
    
    [self loadingCircleViewMsg:message maskView:maskView];
    
    //    maskView = [self maskViewWithMaskView:maskView];
    //    //bugly 上报 有的时候keywindow 为nil 导致崩溃
    //    if (maskView == nil) {
    //        return ;
    //    }
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:maskView animated:YES];
    //    [WXProgressHUD sharedInstance].hud = hud;
    //    hud.label.text = message;
    //    hud.label.numberOfLines = 2;
    //    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //    hud.bezelView.backgroundColor=[UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.8];
    //    hud.contentColor=[UIColor whiteColor];//字的颜色
    //    [hud showAnimated:YES];
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
    if ([WXProgressHUD sharedInstance].circleView) {
        [[WXProgressHUD sharedInstance].circleView stop];
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
+ (void)loadingCircleViewMsg {
    [self loadingCircleViewMsg:@"正在加载" maskView:nil];
}
+ (void)loadingCircleViewMsg:(nullable NSString *)message maskView:(nullable UIView *)maskView {
    
    [self hiddenProgressHUD];
    maskView = [self maskViewWithMaskView:maskView];
    //bugly 上报 有的时候keywindow 为nil 导致崩溃
    if (maskView == nil) {
        return;
    }
    [[WXProgressHUD sharedInstance] loadingCircleViewMsg:message maskView:maskView];
    return;
}
- (void)loadingCircleViewMsg:(nullable NSString *)message maskView:(nullable UIView *)maskView  {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:maskView animated:YES];
    self.hud = hud;
    hud.minSize = CGSizeMake(132, 132);
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [self buildLoadingCircleViewWithMsg:message];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithHexString: @"#4E4C4F"];
}
- (UIView *)buildLoadingCircleViewWithMsg:(NSString *)msg {
    UIView *customView = UIView.new;
    LoadingCircle *circleView = [[LoadingCircle alloc] initWithCircleWidth:5 circleColor:UIColor.whiteColor];
    self.circleView = circleView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [circleView start];
    });
    [customView addSubview:circleView];
    circleView.backgroundColor = UIColor.clearColor;
    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.offset(8);
        make.centerX.equalTo(customView);
    }];
    UIFont *font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    CGFloat msgWidth = [msg sizeWithAttributes:@{NSFontAttributeName:font}].width + 1;
    CGFloat customWidth = msgWidth > 74 ? msgWidth : 74;
    UILabel *tipsLbl = [UICreate labelWithText:msg font:font textColor:UIColor.whiteColor];
    [customView addSubview:tipsLbl];
    tipsLbl.numberOfLines = 0;
    tipsLbl.textAlignment = NSTextAlignmentCenter;
    [tipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(circleView.mas_bottom).offset(15);
        make.left.right.offset(0);
        make.bottom.offset(-8);
        make.width.offset(customWidth);
    }];
    return customView;
}

+ (void)wxPayProgress {
    [self hiddenProgressHUD];
    UIView *maskView = [self maskViewWithMaskView:nil];
    //bugly 上报 有的时候keywindow 为nil 导致崩溃
    if (maskView == nil) {
        return;
    }
    [[WXProgressHUD sharedInstance] loadingWXPayView:maskView];
}
- (void)loadingWXPayView:(nullable UIView *)maskView  {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:maskView animated:YES];
    self.hud = hud;
    hud.minSize = CGSizeMake(132, 132);
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [self buildLoadingCircleViewWithSuperView:hud];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithHexString: @"#4E4C4F"];
}
- (UIView *)buildLoadingCircleViewWithSuperView:(MBProgressHUD *)hud {
    UIView *customView = UIView.new;
    UIView *contentView = UIView.new;
    [customView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(customView);
    }];
        
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WCPayOfflinePay_Pay_23x23_"]];
    [contentView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.centerX.equalTo(contentView);
    }];
    
    UILabel *label = [WXCreate labelWithText:@"微信支付" textColor:UIColor.whiteColor fontSize:17 weight:UIFontWeightMedium];
    [contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(iconView.mas_bottom).offset(20);
    }];
//        .makeConstraints { make in
//        make.center.equalToSuperview()
//        make.size.equalTo(CGSize(width: 70, height: 70))
    UIView *dotsContainerView = UIView.new;
    [contentView addSubview:dotsContainerView];
    dotsContainerView.backgroundColor = UIColor.blueColor;
    [dotsContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(15);
        make.bottom.equalTo(contentView);
        make.centerX.equalTo(contentView);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    TypingLoaderView *dotVIew = [[TypingLoaderView alloc] initWithColor:UIColor.whiteColor superView:dotsContainerView];
    [dotVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(dotsContainerView);
    }];
    dotVIew.backgroundColor = UIColor.redColor;
    
    return customView;
//    UIView *viewToAnimate = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 12, 12)];
//    viewToAnimate.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
//
//    return viewToAnimate;
    
//    UIView *customView = UIView.new;
//    LoadingCircle *circleView = [[LoadingCircle alloc] initWithCircleWidth:5 circleColor:UIColor.whiteColor];
//    self.circleView = circleView;
//    [circleView start];
//    [customView addSubview:circleView];
//    circleView.backgroundColor = UIColor.clearColor;
//    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(40, 40));
//        make.top.offset(8);
//        make.centerX.equalTo(customView);
//    }];
//    UIFont *font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
//    CGFloat msgWidth = [msg sizeWithAttributes:@{NSFontAttributeName:font}].width + 1;
//    CGFloat customWidth = msgWidth > 74 ? msgWidth : 74;
//    UILabel *tipsLbl = [UICreate labelWithText:msg font:font textColor:UIColor.whiteColor];
//    [customView addSubview:tipsLbl];
//    tipsLbl.numberOfLines = 0;
//    tipsLbl.textAlignment = NSTextAlignmentCenter;
//    [tipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(circleView.mas_bottom).offset(15);
//        make.left.right.offset(0);
//        make.bottom.offset(-8);
//        make.width.offset(customWidth);
//    }];
//    return customView;
}

@end
