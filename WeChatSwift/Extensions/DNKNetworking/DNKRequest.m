//
//  DNKRequest.m
//  smarthome
//
//  Created by 陈群 on 2021/6/28.
//  Copyright © 2021 dnake. All rights reserved.
//

#import "DNKRequest.h"
#import "RSAUtil.h"
#import "DNKApiUtils.h"
#import "WeChatSwift-Swift.h"
 
@interface DNKRequest()
@end

@implementation DNKRequest {
    NSDictionary *_param;
    NSDictionary *_encryptParam;
}

#pragma mark - Override

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
    if ([GlobalManager manager].isEncry) {
        YTKRequestMethod method = [self requestMethod];
        if (method == YTKRequestMethodPOST) {
            NSString *json = _param.mj_JSONString;
            NSLog(@"%@", json);
            NSString *sign = [RSAUtil encryptString:json publicKey:DNKApiUtils.encryptKey];
            if (sign != nil) {
                return @{@"sign": sign};
            }
            return _param;
        }
    }
    
    
    // 使用排序选择器进行排序
//    NSArray *sortedArray = [_param.allKeys sortedArrayUsingComparator:^NSComparisonResult(id string1, id string2) {
//        return [string1 compare:string2 options:NSCaseInsensitiveSearch];
//    }];
    
    // 输出排序后的数组
//    NSLog(@"Sorted array: %@", sortedArray);
//    NSMutableString *mStr = [NSMutableString string];
//    [_param.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        [mStr appendFormat:@"%@%=@"];
//    }];
    
//    NSLog(@"\n*** request \n*** Url:%@ \n*** params:%@",self.requestUrl, _param.mj_JSONString);
//    _encryptParam = [self dnk_encryptParm:_param.mj_JSONString];
    return _param;
}

- (NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary {
    NSDictionary *headerMap = [self dnk_requestHeader].mutableCopy;
    NSLog(@"\n*** request \n*** Url:%@ \n*** header:%@",self.requestUrl, headerMap.mj_JSONString);
//    YTKRequestMethod method = [self requestMethod];
//    if (method == YTKRequestMethodGET) {
//        NSDictionary *params = [self requestArgument];
//        if (params != nil) {
//            
//        }
//    }
    
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
    if (code == REFRESH_TOKEN_TIMEOUT ||
        code == TOKEN_ERROR ||
        code == ERROR_USER_STATUS) {
        [[GlobalManager manager] logout];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *apiMsg = self.apiMessage;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showAlertViewOnLoginUI" object:nil userInfo:@{@"msg": apiMsg}];
        });
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

@end
