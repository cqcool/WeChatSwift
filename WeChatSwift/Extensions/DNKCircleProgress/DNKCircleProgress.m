//
//  DNKCircleProgress.m
//  NewSmart
//
//  Created by 陈群 on 2022/6/24.
//

#import "DNKCircleProgress.h"

@interface DNKCircleProgress ()

@end
@implementation DNKCircleProgress

- (instancetype)initWithTrackWidth:(CGFloat)trackWidth
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.trackWidth = trackWidth;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        self.trackWidth = 6;
//        self.progressColor = UIColor.mainBlueColor;
//        self.progressBgColor = UIColor.lightGrayBackgroundColorTow;
//        UILabel *percentLbl = [UICreate labelWithText:@"0.0%" fontSize:13 textColor:UIColor blak];
//        [self addSubview:percentLbl];
//        _percentLbl = percentLbl;
//        [percentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self);
//        }];
    }
    return self;
}
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.percentLbl.text = [NSString stringWithFormat:@"%.0f%%", roundf(progress * 100)];
    [self setNeedsDisplay];
} 
- (void)drawRect:(CGRect)rect {
    UIBezierPath *backgroundPath = [[UIBezierPath alloc] init];
    backgroundPath.lineWidth = self.trackWidth;
    
    [self.progressBgColor set];
//    backgroundPath.lineCapStyle = kCGLineCapRound;
//    backgroundPath.lineJoinStyle = kCGLineJoinRound;
//    CGFloat width = MIN(self.width, self.height);
//    CGFloat radius = (width - self.trackWidth)/2.0;
//    [backgroundPath addArcWithCenter:CGPointMake(self.width/2.0, self.height/2.0) radius:radius startAngle:1.5*M_PI endAngle:1.5*M_PI+2*M_PI clockwise:YES];
//    [backgroundPath stroke];
//    UIBezierPath *progressPath = UIBezierPath.bezierPath;
//    progressPath.lineWidth = self.trackWidth;
//    [self.progressColor set];
//    progressPath.lineCapStyle = kCGLineCapRound;
//    progressPath.lineJoinStyle = kCGLineJoinRound;
//    [progressPath addArcWithCenter:CGPointMake(self.width/2.0, self.height/2.0) radius:radius startAngle:1.5*M_PI endAngle:1.5*M_PI+2*M_PI*self.progress clockwise:YES];
//    [progressPath stroke];
}

@end
