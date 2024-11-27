//
//  NSData+Ext.h
//  NewSmart
//
//  Created by Aliens on 2022/1/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Ext)

/// 16 进制字符串 转NSData
/// - Parameter str: 16 进制字符串
+ (NSData *)dataWithHexString:(NSString*)str;
@end

void *NewBase64Decode(
    const char *inputBuffer,
    size_t length,
    size_t *outputLength);

char *NewBase64Encode(
    const void *inputBuffer,
    size_t length,
    bool separateLines,
    size_t *outputLength);

@interface NSData (Base64)

/// base64 字符串 转NSData
/// - Parameter aString: base64 字符串
+ (NSData *)dataFromBase64String:(NSString *)aString;

/// NSData 转Base64 字符串
- (NSString *)base64EncodedString;

/// NSData 转 base64 字符串  separateLines
/// - Parameter separateLines: 是否是单独的行
- (NSString *)base64EncodedStringWithSeparateLines:(BOOL)separateLines;

@end



NS_ASSUME_NONNULL_END
