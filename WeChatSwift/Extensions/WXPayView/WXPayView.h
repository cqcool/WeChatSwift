//
//  WXPayView.h
//  WXPayView
//
//  Created by apple on 16/1/6.
//  Copyright © 2016年 apple. All rights reserved.
//  微信红包支付界面模拟

#import <UIKit/UIKit.h>

typedef void(^WXPayViewCompletion)(NSString *password);

@interface WXPayView : UIView

// 密码输入框位数（默认6位）
@property (nonatomic,assign) NSInteger places;

@property (nonatomic,copy) void (^exitBtnClicked)();
@property (nonatomic,copy) void (^switchCardBtnClicked)();

- (instancetype)initWithMoney:(CGFloat)money cardMessage:(NSString *)cardMessage completion:(WXPayViewCompletion)completion;

- (void)show;
- (void)hidden;

@end
