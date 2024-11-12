//
//  YTKBaseRequest+DNKProgressHUD.m
//  smarthome
//
//  Created by 陈群 on 2021/7/1.
//  Copyright © 2021 dnake. All rights reserved.
//

#import "YTKBaseRequest+DNKProgressHUD.h"
#import "YTKBaseRequest+DNKApi.h"
#import <objc/runtime.h>
#import "WXRequest.h"
#import "WeChatSwift-Swift.h"

@interface DNKHudControlManager : NSObject<YTKRequestAccessory>
@property (readonly, nonatomic, weak) YTKBaseRequest *baseRequest;
@property (assign, nonatomic) BOOL networkingHUDFlag;
@property (assign, nonatomic) BOOL showFailureHUD;
- (instancetype)initWithBaseRequest:(YTKBaseRequest *)baseRequest;

@end

@implementation YTKBaseRequest (DNKProgressHUD)

- (DNKHudControlManager *)dnk_controlManager {
    DNKHudControlManager *hudManager = objc_getAssociatedObject(self, @selector(dnk_controlManager));
    if (hudManager == nil) {
        hudManager = [[DNKHudControlManager alloc] initWithBaseRequest:self];
        objc_setAssociatedObject(self, @selector(dnk_controlManager), hudManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    return hudManager;
}

- (void)setNetworkingHUD:(BOOL)networkingHUD {
    DNKHudControlManager *controlManager = [self dnk_controlManager];
    controlManager.networkingHUDFlag = networkingHUD;
}

- (void)setShowFailureHUD:(BOOL)showFailureHUD {
    DNKHudControlManager *controlManager = [self dnk_controlManager];
    controlManager.showFailureHUD = showFailureHUD;
}

- (void)showApiMsgHUD:(NSString *)msg {
    if (msg) {
        [DNKProgressHUD brieflyProgressMsg:msg];
    }
}
- (void)showApiMsgHUD {
    NSString *msg = [self apiMessage];
    if (msg) {
        [DNKProgressHUD brieflyProgressMsg:msg];
    }
}

+ (void)swizzleInstanceMethod:(Class)target original:(SEL)originalSelector swizzled:(SEL)swizzledSelector {
    Method originMethod = class_getInstanceMethod(target, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(target, swizzledSelector);
    method_exchangeImplementations(originMethod, swizzledMethod);
}

+ (void)load {
    [self swizzleInstanceMethod:[YTKRequest class] original:@selector(start) swizzled:@selector(swizzle_start)];
}
/// hook
- (void)swizzle_start {
    if ([GlobalManager manager].isRefreshTokenNow &&
        [self isKindOfClass:[WXRequest class]] &&
        ![(WXRequest *)self greenLight]) {
        [[GlobalManager manager] appendWaitRequest:self];
        return;
    }
    NSLog(@"swizzle swizzle_start");
    [self swizzle_start];
}

@end

@implementation DNKHudControlManager

- (instancetype)initWithBaseRequest:(YTKBaseRequest *)baseRequest {
    self = [super init];
    if (self) {
        _baseRequest = baseRequest;
        [_baseRequest addAccessory:self];
    }
    return self;
}

///  Inform the accessory that the request is about to start.
///
///  @param request The corresponding request.
- (void)requestWillStart:(id)request {
    if (self.networkingHUDFlag) {
        [DNKProgressHUD showProgress];
    }
}

///  Inform the accessory that the request is about to stop. This method is called
///  before executing `requestFinished` and `successCompletionBlock`.
///
///  @param request The corresponding request.
- (void)requestWillStop:(id)request {
    if (self.networkingHUDFlag) {
        [DNKProgressHUD hiddenProgressHUD];
    }
}

///  Inform the accessory that the request has already stoped. This method is called
///  after executing `requestFinished` and `successCompletionBlock`.
///
///  @param request The corresponding request.
- (void)requestDidStop:(YTKBaseRequest *)request {
    //账号在其它地方登录
    if ([request.responseObject isKindOfClass:[NSDictionary class]]) {
//        NSString *errorCode = request.responseObject[@"errorCode"];
//        if (errorCode.intValue == DNKRequestErrorCodeAlreadyLogged) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"successLoginOut" object:nil];
//        }
    }
    if (self.showFailureHUD && request.responseObject == nil && request.error) {
//        NSString *url = request.error.userInfo[NSURLErrorFailingURLStringErrorKey];
//        NSString *description = request.error.localizedDescription;
//        description = [NSString stringWithFormat:@"路径：%@ \n\n 错误描述：%@(%zd)", url, description, request.error.code];
        [DNKProgressHUD brieflyProgressMsg:self.baseRequest.apiMessage];
    } else if (self.showFailureHUD && request.responseObject) {
        if (!request.apiSuccess) {
            [DNKProgressHUD brieflyProgressMsg:request.apiMessage];
        }
    }
}

@end
