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
#import "FBEncryptorAES.h"
#import "NSObject+DNKKeyValue.h"

@implementation YTKBaseRequest (DNKApi)
 
- (BOOL)apiSuccess {
    return [self statusCodeValidator];
}
- (id)apiData {
    return self.responseObject[@"data"];
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



- (NSDictionary *)dnk_encryptParm:(NSString *)parmJson {
    NSString *encrypyCipher = [self dnk_encrypt:parmJson];
    return @{@"cipher":encrypyCipher};
}
- (NSDictionary<NSString *, NSString *> *)dnk_requestHeader {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:kAccessTokenKey];
//    NSString *bearer = [NSString stringWithFormat:@"bearer %@",token];
//    [dict setObject:bearer forKey:@"Authorization"];
//    /*
//      app 类型 仅方便服务端取值:
//      DNKAppType:
//     */
//    [dict setObject:@"iOS" forKey:@"AppType"];
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
 
#pragma mark - privacy method
- (NSString *)dnk_encrypt:(NSString *)content {
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [[DNKApiUtils aesKey] dataUsingEncoding:NSUTF8StringEncoding];
    return [self convertDataToHexStr:[FBEncryptorAES encryptData:contentData key:keyData iv:nil]];
}

-(NSData *)RC4Encrypt11:(char *)dataByte plainTextLength:(NSUInteger )dataLength
                    key:(char *)akey akeyLength:(NSUInteger)akeyLength {
    CCCryptorRef cryptor = NULL;
    NSData* data;
    NSData* key;
    data = [NSData dataWithBytes:dataByte length:dataLength];
    key = [NSData dataWithBytes:akey length:akeyLength];
    // 1. Create a cryptographic context.
    CCCryptorStatus status = CCCryptorCreate(kCCEncrypt, kCCAlgorithmRC4, kCCOptionPKCS7Padding, [key bytes], [key length], NULL, &cryptor );
    
    NSAssert(status == kCCSuccess, @"Failed to create a cryptographic context.");
    
    NSMutableData *retData = [NSMutableData new];
    
    // 2. Encrypt or decrypt data.
    NSMutableData *buffer = [NSMutableData data];
    [buffer setLength:CCCryptorGetOutputLength(cryptor, [data length], true)]; // We'll reuse the buffer in -finish
    
    size_t dataOutMoved;
    status = CCCryptorUpdate(cryptor, data.bytes, data.length, buffer.mutableBytes, buffer.length, &dataOutMoved);
    NSAssert(status == kCCSuccess, @"Failed to encrypt or decrypt data");
    [retData appendData:[buffer subdataWithRange:NSMakeRange(0, dataOutMoved)]];
    
    // 3. Finish the encrypt or decrypt operation.
    status = CCCryptorFinal(cryptor, buffer.mutableBytes, buffer.length, &dataOutMoved);
    NSAssert(status == kCCSuccess, @"Failed to finish the encrypt or decrypt operation");
    [retData appendData:[buffer subdataWithRange:NSMakeRange(0, dataOutMoved)]];
    CCCryptorRelease(cryptor);
    
    return retData;
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
//- (NSString *)getSign:(NSString *)time
//{
//    return [NSString stringWithFormat:@"%@%@",[DNKApiUtils sign], time];
//}
//- (NSString *)getAuthorization:(NSString *)time
//{
//
//    return [NSString stringWithFormat:@"%@:%@", [DNKApiUtils authorization], time];
//}

#pragma mark -
#pragma mark -- 二维码使用

/// 解密 非标准rc4 字符串
/// @param hexString 服务器返回的16进制 字符串
+ (NSString *)dnk_decodeQrRc4HexString:(NSString *)hexString {
//    NSData *aData = [hexString hexStringToData];
//    NSData *base64Data = [aData base64EncodedDataWithOptions:0];
//    NSString *base64String = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
//    NSString *resultString = [self rc4Decode:base64String key:[DNKApiUtils rc4Key]];
//    return resultString;
    return @"";
}

/// 加密 非标准rc4 字符串
/// @param string 参数字符串
+ (NSString *)dnk_encryptQrString:(NSString *)string {
    NSString *key = [DNKApiUtils rc4Key];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    char *dataByte = (char *)[data bytes];
    NSData *md5KeyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    //rc4
    NSData *retData = [self RC4Encrypt11:dataByte plainTextLength:data.length key:(char *)[md5KeyData bytes] akeyLength:md5KeyData.length];
    NSString *hexContent = [self convertDataToHexStr:retData];
    return hexContent;
}


// rc4 加密
+ (NSData *)RC4Encrypt11:(char *)dataByte plainTextLength:(NSUInteger )dataLength
                    key:(char *)akey akeyLength:(NSUInteger)akeyLength {
    CCCryptorRef cryptor = NULL;
    NSData* data;
    NSData* key;
    data = [NSData dataWithBytes:dataByte length:dataLength];
    key = [NSData dataWithBytes:akey length:akeyLength];
    // 1. Create a cryptographic context.
    CCCryptorStatus status = CCCryptorCreate(kCCEncrypt, kCCAlgorithmRC4, kCCOptionPKCS7Padding, [key bytes], [key length], NULL, &cryptor );
    
    NSAssert(status == kCCSuccess, @"Failed to create a cryptographic context.");
    
    NSMutableData *retData = [NSMutableData new];
    
    // 2. Encrypt or decrypt data.
    NSMutableData *buffer = [NSMutableData data];
    [buffer setLength:CCCryptorGetOutputLength(cryptor, [data length], true)]; // We'll reuse the buffer in -finish
    
    size_t dataOutMoved;
    status = CCCryptorUpdate(cryptor, data.bytes, data.length, buffer.mutableBytes, buffer.length, &dataOutMoved);
    NSAssert(status == kCCSuccess, @"Failed to encrypt or decrypt data");
    [retData appendData:[buffer subdataWithRange:NSMakeRange(0, dataOutMoved)]];
    
    // 3. Finish the encrypt or decrypt operation.
    status = CCCryptorFinal(cryptor, buffer.mutableBytes, buffer.length, &dataOutMoved);
    NSAssert(status == kCCSuccess, @"Failed to finish the encrypt or decrypt operation");
    [retData appendData:[buffer subdataWithRange:NSMakeRange(0, dataOutMoved)]];
    CCCryptorRelease(cryptor);
    
    return retData;
}


//rc4解密
+ (NSString *)rc4Decode:(NSString *)data key:(NSString*)secret{
    NSData *raw = [[NSData alloc] initWithBase64EncodedString:data options:0];
    int cipherLength = (int)raw.length;
    UInt8 *cipher = malloc(cipherLength);
    [raw getBytes:cipher length:cipherLength];
    NSData *kData = [secret dataUsingEncoding:NSUTF8StringEncoding];
    int keyLength = (int)kData.length;
    UInt8 *kBytes = malloc(kData.length);
    [kData getBytes:kBytes length:kData.length];
    UInt8 *decipher = malloc(cipherLength + 1);
    UInt8 iS[256];
    UInt8 iK[256];
    int i;
    for (i = 0; i < 256; i++){
        iS[i] = i;
        iK[i] = kBytes[i % keyLength];
    }
    int j = 0;
    for (i = 0; i < 256; i++){
        int is = iS[i];
        int ik = iK[i];
        j = (j + is + ik)% 256;
        UInt8 temp = iS[i];
        iS[i] = iS[j];
        iS[j] = temp;
    }
    int q = 0;
    int p = 0;
    for (int x = 0; x < cipherLength; x++){
        q = (q + 1)% 256;
        p = (p + iS[q])% 256;
        int k = iS[p];
        iS[p] = iS[q];
        iS[q] = k;
        k = iS[(iS[q] + iS[p])% 256];
        decipher[x] = cipher[x] ^ k;
    }
    free(kBytes);
    decipher[cipherLength] = '\0';
    return @((char *)decipher);
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
