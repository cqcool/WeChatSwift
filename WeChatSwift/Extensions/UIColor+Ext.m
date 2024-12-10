//
//  UIColor+Ext.m
//  NewSmart
//
//  Created by 陈群 on 2022/1/25.
//

#import "UIColor+Ext.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIColor (Ext)

#pragma mark - common
+ (UIColor *)mainBlueColor {
    
    return hexColor(0x466FF7);
}
+ (UIColor *)disableBlueColor {
    return hexAColor(0x466FF7, .5);
}
/// 辅助色（浅一点的橙色）
+ (UIColor *)mainOrangeColor {
    return hexColor(0xFB9B5B);
}
+ (UIColor *)minorOrangeColor {
    return hexColor(0xFFA544);
}
/// 警告色（红）
+ (UIColor *)warnColor {
    return hexColor(0xB22323);
}
+ (UIColor *)warnYellowColor {
    return hexColor(0xF3CB45);
}
/// 浅绿色
+ (UIColor *)tintGreentColor {
    return hexColor(0x51BE46);
}
/// tabbar灰色
+ (UIColor *)mainGrayColor {
    return hexColor(0xEEF1F4);
}
/// 间隔色（亮灰）
+ (UIColor *)lightGrayBackgroundColor {
    return hexColor(0xEEEEEE);
}
+ (UIColor *)lightGrayTitleColor {
    return hexColor(0xBFBFBF);
}
/// F4F4F4
+ (UIColor *)lightGrayBackgroundColorTow {
    return hexColor(0xF4F4F4);
}
/// 红色
+ (UIColor *)mainRedColor {
    return hexColor(0xD92D2D);
} 

+ (UIColor *)mainTextColor {
    return hexColor(0x333333);
}
+ (UIColor *)minorTextColor {
    return hexColor(0x666666);
}
+ (UIColor *)assistTextColor {
    return hexColor(0x999999);
}
+ (UIColor *)offlineTextColor {
    return hexColor(0xC3C3C3);
}

+ (UIColor *)color2B2B2B {
    return hexColor(0x2B2B2B);
} 
+ (UIColor *)color9D9D9D {
    return hexColor(0x9d9d9d);
}
#pragma mark bg
+ (UIColor *)colorF5F6FA {
    return hexColor(0xF5F6FA);
}
+ (UIColor *)colorEEEEEE {
    return hexColor(0xEEEEEE);
}
+ (UIColor *)colorD0D0D0 {
    return hexColor(0xD0D0D0);
}
+ (UIColor *)colorF7F7F7 {
    return hexColor(0xF7F7F7);
}
#pragma mark line bg
+ (UIColor *)lightLineColor {
    return hexColor(0xF7F7F7);
}
+ (UIColor *)darkLineColor {
    return hexColor(0x7D7D7D);
}


+ (NSString *)hexFromUIColor:(UIColor *)color {
    
    CGFloat r,g,b;
    if ([color getRed:&r green:&g blue:&b alpha:NULL]) {
        return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
                lroundf(r * 255),
                lroundf(g * 255),
                lroundf(b * 255)];
    }
    
    return @"#FFFFFF";
}
+ (UIColor *)colorWithHexString:(NSString *)hexStirng alpha:(CGFloat)alpha {
    hexStirng = hexStirng.uppercaseString;
    // Remove `#` and `0x`
    hexStirng = [hexStirng stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSString *hex = [hexStirng stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    // Invalid if not 3, 6, or 8 characters
    NSUInteger length = [hex length];
    if (length != 3 && length != 6 && length != 8) {
        return nil;
    }
    // Make the string 8 characters long for easier parsing
    if (length == 3) {
        NSString *r = [hex substringWithRange:NSMakeRange(0, 1)];
        NSString *g = [hex substringWithRange:NSMakeRange(1, 1)];
        NSString *b = [hex substringWithRange:NSMakeRange(2, 1)];
        hex = [NSString stringWithFormat:@"%@%@%@%@%@%@ff",
               r, r, g, g, b, b];
    } else if (length == 6) {
        hex = [hex stringByAppendingString:@"ff"];
    }
    //分别取RGB的值
    NSRange range;
    range.length = 2;
    range.location = 0;
    NSString *rString = [hex substringWithRange:range];
    range.location = 2;
    NSString *gString = [hex substringWithRange:range];
    range.location = 4;
    NSString *bString = [hex substringWithRange:range];
    range.location = 6;
    NSString *aString = [hex substringWithRange:range];
    unsigned int r, g, b, a;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
    //转换为UIColor
    float red   = (float) r / 255.0f;
    float green = (float) g / 255.0f;
    float blue  = (float) b / 255.0f;
//    float alpha = (float) a / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hexStirng {
    return [self colorWithHexString:hexStirng alpha:1];
}

@end
