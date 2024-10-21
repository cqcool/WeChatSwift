//
//  NSString+AES.m
//  AES加密解密
//
//  Created by flagadmin on 2019/8/7.
//  Copyright © 2019 flagadmin. All rights reserved.
//
#import "GTMBase64/GTMBase64.h"
#import "NSString+AES.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
@implementation NSString (AES)
- (NSString*)aci_encryptWithAES {
//    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *AESData = [self AES128operation:kCCEncrypt
//                                       data:data
//                                        key:PSW_AES_KEY
//                                         iv:AES_IV_PARAMETER];
//    NSString *baseStr_GTM = [self encodeBase64Data:AESData];
//    return baseStr_GTM;
    return nil;
}

- (NSString*)aci_decryptWithAESWithKey:(NSString *)key iv:(NSString *)iv {
    
//    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *baseData_GTM = [self decodeBase64Data:data];
    NSData *baseData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    
//    NSData *AESData_GTM = [self AES128operation:kCCDecrypt
//                                           data:baseData_GTM
//                                            key:key
//                                             iv:iv];
    NSData *AESData = [self AES128operation:kCCDecrypt
                                       data:baseData
                                        key:key
                                         iv:iv];
    
//    NSString *decStr_GTM = [[NSString alloc] initWithData:AESData_GTM encoding:NSUTF8StringEncoding];
    NSString *decStr = [[NSString alloc] initWithData:AESData encoding:NSUTF8StringEncoding];
    
    return decStr;
}

/**
 *  AES加解密算法
 *
 *  @param operation kCCEncrypt（加密）kCCDecrypt（解密）
 *  @param data      待操作Data数据
 *  @param key       key
 *  @param iv        向量
 *
 *
 */
- (NSData *)AES128operation:(CCOperation)operation data:(NSData *)data key:(NSString *)key iv:(NSString *)iv {
    
    char keyPtr[kCCKeySizeAES128 + 1];  //kCCKeySizeAES128是加密位数 可以替换成256位的
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    // IV
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    // 设置加密参数
    /**
     这里设置的参数ios默认为CBC加密方式，如果需要其他加密方式如ECB，在kCCOptionPKCS7Padding这个参数后边加上kCCOptionECBMode，即kCCOptionPKCS7Padding | kCCOptionECBMode，但是记得修改上边的偏移量，因为只有CBC模式有偏移量之说
     
     */
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                            keyPtr, kCCKeySizeAES128,
                                            ivPtr,
                                            [data bytes], [data length],
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    
    if(cryptorStatus == kCCSuccess) {
        NSLog(@"Success");
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
    } else {
        NSLog(@"Error");
    }
    
    free(buffer);
    return nil;
}

// 这里附上GTMBase64编码的代码，可以手动写一个分类，也可以直接cocopods下载，pod 'GTMBase64'。
/**< GTMBase64编码 */
- (NSString*)encodeBase64Data:(NSData *)data {
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

/**< GTMBase64解码 */
- (NSData*)decodeBase64Data:(NSData *)data {
    data = [GTMBase64 decodeData:data];
    return data;
}
@end
/*
 // 将key和iv转换为二进制数据
  NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
  NSData *ivData = [iv dataUsingEncoding:NSUTF8StringEncoding];
  
  // 创建CryptoRef结构体
  CCCryptorStatus status;
  size_t bytesDecrypted;
  size_t numBytesDecrypted;
  NSMutableData *decryptedData = [NSMutableData dataWithCapacity:data.length];
  
  // 执行解密操作
  status = CCCrypt(kCCDecrypt,
                   kCCAlgorithmDES,
                   kCCOptionPKCS7Padding,
                   keyData.bytes,
                   kCCKeySizeDES,
                   ivData.bytes,
                   data.bytes,
                   data.length,
                   decryptedData.mutableBytes,
                   decryptedData.length,
                   &bytesDecrypted);
 */
