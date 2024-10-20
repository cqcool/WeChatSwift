//
//  NSObject+DNKKeyValue.h
//  NewSmart
//
//  Created by 陈群 on 2022/10/24.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@protocol DNKApiProtocol
@optional
/// 这个数组中的属性名将会被忽略：不会作为接口参数
+ (NSArray *_Nullable)api_ignoredPropertyName;

@end
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DNKKeyValue)
- (NSMutableDictionary *)dnk_keyValue;
@end

NS_ASSUME_NONNULL_END
