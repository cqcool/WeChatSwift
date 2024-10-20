//
//  DNKApiUtils.m
//  smarthome
//
//  Created by 陈群 on 2021/6/24.
//  Copyright © 2021 dnake. All rights reserved.
//

#import "DNKApiUtils.h"
#import <CommonCrypto/CommonCryptor.h>
static NSString * identifierForVendorTag = @"identifierForVendor";

@implementation DNKApiUtils

//+(NSString *)deviceId
//{
//    static NSString * uniqueIdentifier = nil;
//    if (uniqueIdentifier != nil) {
//        return uniqueIdentifier;
//    }
//    uniqueIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:identifierForVendorTag];
//    if( !uniqueIdentifier ) {
//#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
//        uniqueIdentifier = [UIDevice currentDevice].identifierForVendor.UUIDString;
//#endif
//        [[NSUserDefaults standardUserDefaults] setObject:uniqueIdentifier forKey:identifierForVendorTag];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//    
//    return uniqueIdentifier;
//}


+ (NSString *)encryptKey {
    return @"df1acb570370615d7ee86de73cf66c6e";
}
+ (NSString *)sign {
    return @"d780d5f3c706851ad386e7d7acdaf6f7df1acb570370615d7ee86de73cf66c6e";
}
+ (NSString *)authorization {
    return @"d780d5f3c706851ad386e7d7acdaf6f7";
}
+ (NSString *)rc4Key {
    return @"df1acb570370615d7ee86de73cf66c6e";
}

+ (NSString *)aesKey {
    return @"0a42f19954864f40a82fa853deaa24b0";
}


#define DomainOfAppleToCheckNetwork @"http://captive.apple.com"
#pragma mark - 检测网络是否真正可用
/// 检测网络是否真正可用 (比如连上未插入网线的路由器WiFi时,网络并不真正可用)
/// @param completion 完成回调
+ (void)checkNetworkActuallyAvailable:(void(^)(BOOL available))completion {
    // 创建请求
    NSString *urlStr = DomainOfAppleToCheckNetwork;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:3];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0 || __MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_10
    
    // 创建请求任务
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!data) {
            if (completion) {
                completion(NO);
            }
            return;
        }
        
        NSString *htmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        // 解析HTML页面内容
        NSString *content = [self fetchContentFromHTMLString:htmlString];
        BOOL success = [content isEqualToString:@"SuccessSuccess"];
        if (completion) {
            completion(success);
        }
    }];
    [task resume];
    
#else
    
    NSOperationQueue *queue = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!data) {
            if (completion) {
                completion(NO);
            }
            return;
        }
        
        NSString *htmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        // 解析HTML页面内容
        NSString *content = [self fetchContentFromHTMLString:htmlString];
        BOOL success = [content isEqualToString:@"SuccessSuccess"];
        if (completion) {
            completion(success);
        }
    }];
    
#endif
}

/// 取出HTML的内容
/// @param htmlString HTML字符串
+ (NSString *)fetchContentFromHTMLString:(NSString *)htmlString {
    /* HTML字符串格式如下:
     
        <html>
            <head>
                <title>
                    Success
                </title>
            </head>
            <body>
                Success
            </body>
        </html>
     
    */
    
    // 剔除HTML字符串中的标签,以获取内容
    NSString *content = [self replacingMatchesInString:htmlString withPattern:@"<[\\w/]*?>" withTemplate:@""];
    return content;
}

/// 替换字符串中的匹配字符串为目标字符串
/// @param string 要替换的字符串
/// @param pattern 模式字符串
/// @param template 目标字符串
+ (NSString *)replacingMatchesInString:(NSString *)string withPattern:(NSString *)pattern withTemplate:(NSString *)template {
    NSError *error = nil;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"正则表达式: %@ 无效! error: %@", pattern, error.localizedDescription);
        return string;
    }
    
    NSString *newString = [regex stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:template];
    return newString;
}



@end
