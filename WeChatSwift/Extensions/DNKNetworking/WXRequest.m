//
//  WXRequest.m
//  smarthome
//
//  Created by 陈群 on 2021/6/28.
//  Copyright © 2021 dnake. All rights reserved.
//

#import "WXRequest.h"
#import "RSAUtil.h"
#import "WXApiUtils.h"
#import "WeChatSwift-Swift.h"

@interface WXRequest()
@end

@implementation WXRequest {
    NSDictionary *_param;
    NSDictionary *_encryptParam;
}

#pragma mark - Override

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        NSLog(@"request class: %@", self.class);
//    }
//    return self;
//}

- (NSString *)baseUrl {
    return @"http://47.237.119.236:6001";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (NSTimeInterval)requestTimeoutInterval {
    return 10;
}

- (nullable id)requestArgument {
    _param = [self dnk_dynamicBuildParameter];
    if (_param == nil) {
        return nil;
    }
    NSLog(@"\n*** request \n*** Url:%@ \n*** params:%@",self.requestUrl, _param.mj_JSONString);
    if ([GlobalManager manager].isEncry && [self requestMethod] == YTKRequestMethodPOST) {
        YTKRequestMethod method = [self requestMethod];
        if (method == YTKRequestMethodPOST) {
            NSString *json = _param.mj_JSONString;
            NSString *sign = [RSAUtil encryptString:json publicKey:WXApiUtils.encryptKey];
            if (sign != nil) {
                return @{@"sign": sign};
            }
            return _param;
        }
    }
    return _param;
}

- (NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary {
    NSMutableDictionary *headerMap = [self dnk_requestHeader].mutableCopy;
    if ([GlobalManager manager].isEncry &&
        [self requestMethod] == YTKRequestMethodGET) {
        NSDictionary *params = [self requestArgument];
        if (params != nil && params.count > 0) {
            NSArray *sortedArray = [_param.allKeys sortedArrayUsingComparator:^NSComparisonResult(id string1, id string2) {
                return [string1 compare:string2 options:NSCaseInsensitiveSearch];
            }];
            // p1=v1&p2=v2&p3=v3&
            NSMutableArray *keyValues = NSMutableArray.array;
            for (NSString *key in sortedArray) {
                [keyValues addObject:[NSString stringWithFormat:@"%@=%@", key, params[key]]];
            }
            [keyValues addObject:[WXApiUtils getEncryptKey]];
            NSString *paramsString = [keyValues componentsJoinedByString:@"&"];
            NSString *sign = [[paramsString md5Encrpt] lowercaseString];
            headerMap[@"sign"] = sign;
        }
    }
    NSLog(@"\n*** request \n*** Url:%@ \n*** header:%@",self.requestUrl, headerMap.mj_JSONString);
    return headerMap;
}

- (BOOL)statusCodeValidator {
    BOOL status = [super statusCodeValidator];
    if (status && (self.apiCode == 200)) {
        return YES;
    }
    return NO;
}
- (void)requestCompleteFilter {
    NSLog(@"\nsuccess *** Url:%@ \n*** reponseData:%@",self.requestUrl, [self.responseJSONObject mj_JSONString]);
}

- (void)requestFailedFilter {
    [DNKProgressHUD hiddenProgressHUD];
    NSInteger code = self.apiCode;
    if (code == TOKEN_ERROR ||
        code == ERROR_USER_STATUS) {
        [[GlobalManager manager] logout];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *apiMsg = self.apiMessage;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showAlertViewOnLoginUI" object:nil userInfo:@{@"msg": apiMsg}];
        });
        return;
    }
    // 重新刷新token
    if (code == REFRESH_TOKEN_TIMEOUT) {
        [self start];
        return;
    }
}

- (void)requestFailedPreprocessor {     // 服务器校验失败
    if ([super statusCodeValidator]) {
        NSLog(@"\nfail *** Url:%@ \n*** reponseData:%@",self.requestUrl, [self.responseJSONObject mj_JSONString]);
    }
    // 接口请求失败
    if (self.responseObject) {
        NSLog(@"\nfail*** Url:%@ \n*** error:%@",self.requestUrl, [self.responseObject mj_JSONString]);
    } else {
        NSLog(@"\nfail*** Url:%@ \n*** error:%@",self.requestUrl, self.error.localizedDescription);
    }
    //个别情况 存在 code = 400 但是token 也失效的情况
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [GlobalManager checkApiCode:self.apiCode];
    //    });
    return;
    
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}


- (BOOL)greenLight {
    return false;
}
@end
