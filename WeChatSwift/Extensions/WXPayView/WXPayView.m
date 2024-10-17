//
//  WXPayView.m
//  WXPayView
//
//  Created by apple on 16/1/6.
//  Copyright © 2016年 apple. All rights reserved.
//  微信红包支付界面模拟


#import "WXPayView.h"
#import "WXInputView.h"

@interface WXPayView()

@property (weak, nonatomic) IBOutlet WXInputView *inputView; // 密码输入框
@property (weak, nonatomic) IBOutlet UILabel *cardMessageL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardMessageConstraintW;//银行卡信息视图宽度
@property (weak, nonatomic) IBOutlet UILabel *moneyL;

@property (nonatomic,copy) WXPayViewCompletion completion;
@property (nonatomic,copy) NSString *cardMessage;
@property (nonatomic,assign) CGFloat money;

@property (nonatomic,strong) UIView *cover;

@end

@implementation WXPayView

- (instancetype)initWithMoney:(CGFloat)money cardMessage:(NSString *)cardMessage completion:(WXPayViewCompletion)completion{

    self = [[[NSBundle mainBundle] loadNibNamed:@"WXPayView" owner:nil options:nil] lastObject];

    if (self == nil) {
        return nil;
    }
    
    _money = money;
    _cardMessage = cardMessage;
    _completion = completion;
    
    [self setupContents];

    return self;
}

- (void)awakeFromNib{
    self.layer.cornerRadius = 10;

   // 默认6位
    self.inputView.places = 6;
}

- (void)setupContents{
    
    self.moneyL.text = [NSString stringWithFormat:@"￥%.2f",self.money];
    
    self.cardMessageL.text = self.cardMessage;
    NSString *cardMessage = [NSString stringWithFormat:@"%@ 更换",self.cardMessage];
    CGSize size = [cardMessage sizeWithAttributes:@{NSFontAttributeName: self.cardMessageL.font}];
    self.cardMessageConstraintW.constant = size.width;
    
    __weak typeof(self) weakSelf = self;
    self.inputView.WXInputViewDidCompletion = ^(NSString *text){
        if (weakSelf.completion) {
            weakSelf.completion(text);
        }
    };
}

- (void)setPlaces:(NSInteger)places{
    _places = places;
    self.inputView.places = places;
}

- (IBAction)exitButtonClicked {
    if (self.exitBtnClicked) {
        self.exitBtnClicked();
    }
}

- (IBAction)changeCard {
    if (self.switchCardBtnClicked) {
        self.switchCardBtnClicked();
    }
}

- (void)show{
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    [window addSubview:self.cover];
    [window addSubview:self];
    
    // 设置微信支付界面出现动画及位置
    self.transform = CGAffineTransformMakeScale(0.6, 0.6);
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.cover.alpha = 1;
        self.alpha = 1;
    }];
    self.center = CGPointMake(window.center.x, (window.frame.size.height - 216) * 0.5);
    
    // 适配小屏幕
    if (window.frame.size.width == 320) {
        self.bounds = CGRectMake(0, 0, self.bounds.size.width * 0.9, self.bounds.size.height);
    }
    
    // 弹出键盘
    [self.inputView beginInput];
}

- (void)hidden{
    
    // 设置微信支付界面消失动画
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeScale(0.6, 0.6);
        self.alpha = 0;
        self.cover.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.cover removeFromSuperview];
    }];
    
    // 退下键盘
    [self.inputView endInput];
}

- (UIView *)cover{
    if (_cover == nil) {
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        _cover = [[UIView alloc] initWithFrame:window.bounds];
        CGFloat rgb = 83 / 255.0;
        _cover.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.7];
        _cover.alpha = 0;
    }
    return _cover;
}


@end
