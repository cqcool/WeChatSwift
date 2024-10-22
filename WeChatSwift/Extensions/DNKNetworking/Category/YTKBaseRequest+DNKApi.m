//
//  YTKBaseRequest+DNKApi.m
//  smarthome
//
//  Created by 陈群 on 2021/6/24.
//  Copyright © 2021 dnake. All rights reserved.
//

#import "YTKBaseRequest+DNKApi.h"
#import <CommonCrypto/CommonCryptor.h>
#import "DNKApiUtils.h"
#import "NSObject+DNKKeyValue.h"
#import "WeChatSwift-Swift.h"
#import <MJExtension.h>

@implementation YTKBaseRequest (DNKApi)
 
- (BOOL)apiSuccess {
    return [self statusCodeValidator];
}
- (id)wxResponseObject {
    return self.responseObject[@"data"];
}

- (NSData *)wxResponseData {
    return [self.wxResponseObject mj_JSONData];
}

- (NSString *)apiMessage {
    if ([self.responseObject isKindOfClass:[NSData class]]) {
        NSString *string = [[NSString alloc] initWithData:self.responseObject encoding:NSUTF8StringEncoding];
        return string;
    }
    if (self.responseObject && self.responseObject[@"msg"]) {
        return self.responseObject[@"msg"];
    }
//    if(self.apiCode == DNKCodeFamilyHasEngineering) {
//        return Localized(@"已授权给工程师，无法解绑网关。请确保工程师已完成操作后，\n从“家庭管理-家庭成员”里删除工程师后再解绑”。");
//    }
//    if(self.apiCode == DNKCodeIrMacNotFound) {
//        return Localized(@"请先将数据同步至服务端后再使用！");
//    }
    if (self.error) {
        NSInteger code = self.error.code;
//        NSString *msg = [ModuleUtil errorMessageWithCode:(int)code];
//        if (msg.isNonEmpty) {
//            return msg;
//        }
        return [NSString stringWithFormat:@"%@(%zd)", @"请检查网络并重试", code];
    }
    return @"请检查网络并重试";
}
- (NSInteger)apiCode {
    if (self.responseObject && self.responseObject[@"code"]) {
        return [self.responseObject[@"code"] intValue];
    }
    return self.error.code;
} 
- (NSError *)dnkError {
    
    NSError *error = [NSError errorWithDomain:@"DNKRquestDomain" code:self.apiCode userInfo:@{NSLocalizedDescriptionKey:self.apiMessage}];
    return error;
}
- (NSDictionary *)dnk_dynamicBuildParameter {
    return self.dnk_keyValue;
}

 
- (NSDictionary<NSString *, NSString *> *)dnk_requestHeader {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"h"] = @"011001010001";
    dict[@"isEnabled"] = ([GlobalManager manager].isEncry) ? @"true": @"false";
    if ([GlobalManager manager].refreshToken != nil) {
        dict[@"t1"] = [GlobalManager manager].refreshToken;
    }
    if ([GlobalManager manager].token != nil) {
        dict[@"t"] = [GlobalManager manager].token;
    }
    return dict;
}

- (BOOL)apiValidateFailureOfService {
    return self.responseObject ? YES : NO;
}
- (void)startWithNetworkingHUD:(BOOL)showNetworkingHUD
                showFailureHUD:(BOOL)showFailureHUD
                       success:(nullable YTKRequestCompletionBlock)success
                       failure:(nullable YTKRequestCompletionBlock)failure {
    [self setNetworkingHUD:showNetworkingHUD];
    [self setShowFailureHUD:showFailureHUD];
    [self startWithCompletionBlockWithSuccess:success failure:failure];
}
  

- (NSString *)convertDataToHexStr:(NSData *)data {
    return  [YTKBaseRequest convertDataToHexStr:data];
}

+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

- (NSString *)dateStyleFromDateStringTypeYMDHMS:(NSDate *)date {
    //转换时间格式
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString* s1 = [df stringFromDate:date];
    
    NSDate* dateValue = [df dateFromString:s1];
    
    //转换时间格式
    NSDateFormatter*df2 = [[NSDateFormatter alloc]init];//格式化
    
    [df2 setDateFormat:@"yyyyMMddHHmmss"];
    
    [df2 setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    
    return [df2 stringFromDate:dateValue];
}
+ (void)mj_enumerateClasses:(MJClassesEnumeration)enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = self;
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        if ([c isEqual:YTKRequest.class]) break;
        // 4.1.执行操作
        enumeration(c, &stop);
        // 4.2.获得父类
        c = class_getSuperclass(c);
        if ([MJFoundation isClassFromFoundation:c]) break;
    }
}
@end
