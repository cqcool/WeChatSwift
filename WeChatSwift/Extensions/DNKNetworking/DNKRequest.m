//
//  DNKRequest.m
//  smarthome
//
//  Created by 陈群 on 2021/6/28.
//  Copyright © 2021 dnake. All rights reserved.
//

#import "DNKRequest.h"

@interface DNKRequest()
@end

@implementation DNKRequest {
    NSDictionary *_param;
    NSDictionary *_encryptParam;
}

#pragma mark - Override
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (NSTimeInterval)requestTimeoutInterval {
    return 10;
}
- (nullable id)requestArgument {
    _param = [self dnk_dynamicBuildParameter];
    NSLog(@"\n*** request \n*** Url:%@ \n*** params:%@",self.requestUrl, _param.mj_JSONString);
    _encryptParam = [self dnk_encryptParm:_param.mj_JSONString];
    return _encryptParam;
}

- (NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary {
    NSDictionary *headerMap = [self dnk_requestHeader];
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
