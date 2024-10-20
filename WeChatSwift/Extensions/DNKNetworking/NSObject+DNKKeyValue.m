//
//  NSObject+DNKKeyValue.m
//  NewSmart
//
//  Created by 陈群 on 2022/10/24.
//

#import "NSObject+DNKKeyValue.h"
#import "YTKBaseRequest+DNKApi.h"

@implementation NSObject (DNKKeyValue)
- (NSMutableDictionary *)dnk_keyValue {
    if ([self isMemberOfClass:NSNull.class]) { return nil;}
    if ([MJFoundation isClassFromFoundation:[self class]]) {
        return (NSMutableDictionary *)self;
    }
    id keyValues = NSMutableDictionary.dictionary;
    Class clazz = self.class;
    NSArray *ignoredPropertyNames = nil;
    if ([clazz respondsToSelector:@selector(api_ignoredPropertyName)]) {
        ignoredPropertyNames = [clazz api_ignoredPropertyName];
    }
    [clazz mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
        if ([ignoredPropertyNames containsObject:property.name]) return;
        // 1.取出属性值
        id value = [property valueForObject:self];
        if (!value) return;
        // 2.如果是模型属性
        MJPropertyType *type = property.type;
        Class propertyClass = type.typeClass;
        if (!type.isFromFoundation && propertyClass) {
            value = [value dnk_keyValue];
        } else if ([value isKindOfClass:[NSArray class]]) {
            // 3.处理数组里面有模型的情况
            NSMutableArray *keyValuesArray = [NSMutableArray array];
            for (id object in value) {
                id convertedObj = [object dnk_keyValue];
                if (!convertedObj) { continue; }
                [keyValuesArray addObject:convertedObj];
            }
            value = keyValuesArray;
        } else if (propertyClass == [NSURL class]) {
            value = [value absoluteString];
        }
        keyValues[property.name] = value;
    }];
    return keyValues;
}

@end
