//
//  WXRequest.h
//  smarthome
//
//  Created by 陈群 on 2021/6/28.
//  Copyright © 2021 dnake. All rights reserved.
//

#import "YTKRequest.h"
#import "YTKBaseRequest+DNKApi.h"
#import "WXNetworkConst.h"
#import <MJExtension.h>
NS_ASSUME_NONNULL_BEGIN
@interface WXRequest : YTKRequest

- (BOOL)greenLight;

@end

NS_ASSUME_NONNULL_END
