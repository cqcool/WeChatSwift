//
//  NSString+Ext.m
//  NewSmart
//
//  Created by 陈群 on 2022/1/14.
//

#import "NSString+Ext.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"
@implementation NSString (Ext)

- (BOOL)isNonEmpty {
    if (self.length == 0 || self == NULL ||
        [self isKindOfClass:[NSNull class]] ||
        [self isEqualToString:@"null"] ||
        [self isEqualToString:@"(null)"]) {
        return NO;
    }
    return YES;
}
- (NSDate *)toDate:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    return [dateFormatter dateFromString:self];
}

//判断是否含有非法字符 yes 有  no没有
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content{
    //提示 标签不能输入特殊字符
    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:content]) {
        return YES;
    }
    return NO;
} 
+ (NSString *)filterChinese:(NSString *)jsonString {
    NSData*jsondata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    jsonString = [[NSString alloc] initWithBytes:[jsondata bytes] length:[jsondata length] encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (BOOL)containEmoji {
    if (!self.isNonEmpty) {
        return NO;
    }
    if ([self isNumberString]) {
        return NO;
    }
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
         ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
             
             const unichar hs = [substring characterAtIndex:0];
             // surrogate pair
             if (0xd800 <= hs && hs <= 0xdbff) {
                 if (substring.length > 1) {
                     const unichar ls = [substring characterAtIndex:1];
                     const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                     if (0x1d000 <= uc && uc <= 0x1f77f) {
                         returnValue = YES;
                     }
                 }
             } else if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 if (ls == 0x20e3) {
                     returnValue = YES;
                 }
                 
             } else {
                 // non surrogate
                 if (0x2100 <= hs && hs <= 0x27ff) {
                     returnValue = YES;
                 } else if (0x2B05 <= hs && hs <= 0x2b07) {
                     returnValue = YES;
                 } else if (0x2934 <= hs && hs <= 0x2935) {
                     returnValue = YES;
                 } else if (0x3297 <= hs && hs <= 0x3299) {
                     returnValue = YES;
                 } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                     returnValue = YES;
                 }
             }
         }];
     
     
     return returnValue;
}
- (BOOL)isNumberString {
    if (self == nil || [self length] <= 0)
    {
        return NO;
    }
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if (![self isEqualToString:filtered])
    {
        return NO;
    }
    return YES;
}



+ (NSString *)toHEXString:(NSInteger)integer {
    NSString *hexString = @"";
    BOOL flag = YES;
    while (flag) {
        NSString *ch;
        NSInteger remainder = integer % 16;
        integer = integer / 16;
        if (remainder >= 10 && remainder <= 15) {
            ch = [NSString stringWithFormat:@"%c", (int)(55 + remainder)];
        } else {
            ch = [[NSString alloc]initWithFormat:@"%ld", remainder];
        }
        hexString = [ch stringByAppendingString:hexString];
        flag = integer != 0 ? YES : NO;
    }
    if (hexString.length < 4) {
        NSString *zero = @"";
        for (int idx = 0; idx < (4 - hexString.length); idx++) {
            zero = [zero stringByAppendingString:@"0"];
        }
        return [NSString stringWithFormat:@"%@%@", zero, hexString];
    }
    return hexString;
}
- (NSInteger)integerWithHex {
    if (!self.isNonEmpty) {
        return 0;
    }
    NSScanner * scanner = [NSScanner scannerWithString:self];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
    return longlongValue;
}
- (NSString *)md5Encrpt {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    return result;
}


//解密
- (NSData *)decryptUseDESWithKey:(NSString*)key offset:(NSString *)offset {

    NSData *keyData =  [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ivData =  [offset dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:self options:0];
//    NSData *encryptedData = [self dataUsingEncoding:NSUTF8StringEncoding];
    // 准备解密后的数据缓冲区
       size_t decryptedDataLength = encryptedData.length + kCCBlockSize3DES;
       void *decryptedData = malloc(decryptedDataLength);
    // 初始化输出数据长度变量
        size_t actualOutSize = 0;

        // 执行解密
        CCCryptorStatus cryptStatus = CCCrypt(
            kCCDecrypt,                      // 解密操作
            kCCAlgorithm3DES,                // 3DES算法
            kCCOptionPKCS7Padding,           // 使用PKCS7填充
            keyData.bytes,                   // 密钥
            kCCKeySize3DES,                  // 密钥长度
            ivData.bytes,                    // 初始化向量（IV）
            encryptedData.bytes,             // 输入数据
            encryptedData.length,            // 输入数据长度
            decryptedData,                   // 输出数据缓冲区
            decryptedDataLength,             // 输出数据缓冲区大小
            &actualOutSize                   // 解密后数据的实际长度
        );

        NSData *result = nil;
        if (cryptStatus == kCCSuccess) {
            result = [NSData dataWithBytes:decryptedData length:actualOutSize];
        } else {
            NSLog(@"解密失败，状态码: %d", cryptStatus);
        }

        // 释放缓冲区
        free(decryptedData);
#if DEBUG
    NSString *json = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(@"转换后的字符串: %@", json);
#endif
        return result;
    
    
    
//    unsigned char buffer[1024];
//    
//    NSData *cipherdata = [[NSData alloc] initWithBase64EncodedString:self options:0];
//    
//    memset(buffer, 0, sizeof(char));
//    size_t numBytesDecrypted = 0;
//     
//    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
//                                          kCCAlgorithmDES,
//                                          kCCOptionPKCS7Padding,
//                                          [key UTF8String],
//                                          kCCKeySizeDES,
//                                          [offset UTF8String],
//                                          [cipherdata bytes],
//                                          [cipherdata length],
//                                          buffer,
//                                          1024,
//                                          &numBytesDecrypted);
//    NSString* plainText = nil;
//    if (cryptStatus == kCCSuccess) {
//        
//        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
//        plainText = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
//         
//        // 输出转换后的字符串
//        NSLog(@"转换后的字符串: %@", plainText);
//
//         
//    }
//    return plainText;
}

//将16进制字符串转成NSData wDudU 1Vz3w mOGEL Lni7j xiS5
- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
   
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];

        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];

        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}


- (NSData *)hexStringToData {
    if (!self.isNonEmpty) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range = (self.length % 2 == 0) ? NSMakeRange(0, 2) : NSMakeRange(0, 1);
    for (NSInteger i = range.location; i < self.length; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [self substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}
#pragma mark - 类方法
+ (NSString *)wifiName {
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}
#pragma mark 时间
//获取时间戳UTC
+ (NSNumber *)currentTimeStamp {
    NSInteger secondTs = [self currentSecondTimestamp];
    // *1000 是精确到毫秒
    return @(secondTs * 1000);
}


+ (NSInteger)currentSecondTimestamp {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    return [date timeIntervalSince1970];
}
+ (NSString *)timeTextWithDate:(NSDate *)date formatter:(NSString *)formatter; {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)timeTextWithTimestamp:(long)timestamp formatter:(NSString *)formatter {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    return [self timeTextWithDate:date formatter:formatter];
}
+ (NSTimeInterval)timeStampWithDateText:(NSString *)dateText formatter:(NSString *)formatter {
    NSDate *date = [self dateWithDateText:dateText formatter:formatter];
    NSTimeInterval timeSince1970 = [date timeIntervalSince1970];
    return timeSince1970*1000;
}
//字符串转date
+ (NSDate *)dateWithDateText:(NSString *)dateText formatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [dateFormatter dateFromString:dateText];
    return date;
}

+ (NSString *)random32bitString {
    char data[32];
    for (int x=0;x<32;data[x++] = (char)('a' + (arc4random_uniform(26))));
    NSString *string = [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    if (string == nil) {
        string = @"";
    }
    return string;
}
+ (NSString *)random32Udid {
    char data[32];
    int idx = 0;
    while (YES) {
        if (idx == 32) {
            break;
        }
        int a = arc4random_uniform(122);
        if ((a >= 65 && a <= 90) || a > 96 ||
            (a >= 48 && a <= 57)) {
            data[idx] = (char)a;
            idx ++;
        }
    }
    NSString *string = [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    return string;
}
// 获取手机ip地址
+ (NSString *)getIpAddresses {
    NSString *ipAddress = @"127.0.0.1";
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    if ([addresses.allKeys containsObject:@"en0/ipv4"]) {
        ipAddress=[addresses objectForKey:@"en0/ipv4"];
    }
    else if([addresses.allKeys containsObject:@"pdp_ip0/ipv4"])
    {
        ipAddress=[addresses objectForKey:@"pdp_ip0/ipv4"];
    }
    return ipAddress;
}
#pragma mark - check
+ (BOOL)validIPAddress:(NSString *)ipAddress {
    if (nil == ipAddress) {
        return NO;
    }
    NSArray *ipArray = [ipAddress componentsSeparatedByString:@"."];
    if (ipArray.count != 4) {
        return NO;
    }
    for (NSString *ipnumberStr in ipArray) {
        if (ipnumberStr.validatePureNumber) {
            int ipnumber = [ipnumberStr intValue];
            if (!(ipnumber>=0 && ipnumber<=255)) {
                return NO;
            }
        }
    }
    return YES;
}
- (BOOL)validatePureNumber {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < self.length) {
        NSString * string = [self substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}


- (NSString *)firstComponentBySeparator:(NSString *)separator {
    if (!self.isNonEmpty || !separator.isNonEmpty) {
        return self;
    }
    NSArray *components = [self componentsSeparatedByString:separator];
    return components.firstObject;
}
@end


@implementation NSString (LK)

-(NSData *)convert16ByteData
{
    int j=0;
    Byte bytes[128];  ///3ds key的Byte 数组， 128位
    for(int i=0;i<[self length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [self characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
        {
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        }
        else if(hex_char1 >= 'A' && hex_char1 <='F')
        {
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        }
        else
        {
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        }
        i++;
        
        unichar hex_char2 = [self characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
        {
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        }
        else if(hex_char2 >= 'A' && hex_char2 <='F')
        {
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        }
        else
        {
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        }
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    return [NSData dataWithBytes:bytes length:j];
}

//判断邮箱是否合法的代码   拆分验证
+(BOOL)checkEmailWithComponent:(NSString*)email
{
    if((0 != [email rangeOfString:@"@"].length) &&
       (0 != [email rangeOfString:@"."].length))
    {
        
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet* tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy];
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        
        //使用compare option 来设定比较规则，如
        //NSCaseInsensitiveSearch是不区分大小写
        //NSLiteralSearch 进行完全比较,区分大小写
        //NSNumericSearch 只比较定符串的个数，而不比较字符串的字面值
        NSRange range1 = [email rangeOfString:@"@"
                                      options:NSCaseInsensitiveSearch];
        
        //取得用户名部分
        NSString* userNameString = [email substringToIndex:range1.location];
        NSArray* userNameArray   = [userNameString componentsSeparatedByString:@"."];
        
        for(NSString* string in userNameArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
            {
                return NO;
            }
        }
        
        NSString *domainString = [email substringFromIndex:range1.location+1];
        NSArray *domainArray   = [domainString componentsSeparatedByString:@"."];
        
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        return YES;
    }
    else // no ''@'' or ''.'' present
        return NO;
}



//用户名检测
//^[a-zA-Z]\w{6,20}$
+(BOOL)checkUserNameWithRegex:(NSString *)userName {
    NSString *userNameRegex = @"^[a-zA-Z]\\w{6,20}$";
    NSPredicate *userNameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userNameRegex];
    return [userNameTest evaluateWithObject:userName];
}

+(BOOL)checkUserNameWithRegex1:(NSString *)userName {
    NSString *userNameRegex = @"^[\u4e00-\u9fa5_a-zA-Z0-9]+$";
    NSPredicate *userNameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userNameRegex];
    return [userNameTest evaluateWithObject:userName];
}

//利用正则表达式验证
+(BOOL)checkEmailWithRegex:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//手机号码验证
+(BOOL)checkMobileNumble:(NSString *)phone
{
    NSString *phoneRegex = @"^1\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phone];
    //    if (phone.length == 11) {
    //        return YES;
    //    }else{
    //        return NO;
    //    }
}
+(NSNumber *)numberHexString:(NSString *)aHexString
{
    // 为空,直接返回.
    if (nil == aHexString){
        return @0;
    }
    NSScanner * scanner = [NSScanner scannerWithString:aHexString];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
    //将整数转换为NSNumber,存储到数组中,并返回.
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
    if (nil == aHexString) { // 无法转换的给0 处理 先这样处理
        return @0;
    }
    return hexNumber;
}
+(BOOL)checkMobileNumble:(NSString *)mobileStr contry:(NSUInteger)contry
{
    switch (contry) {
        case 86:
        {
            //手机号以13， 15，18开头，八个 \d 数字字符
            NSString *phoneRegex = @"^((13[0-9])|(145)|(147)|(170)|(176)|(178)|(177)|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
            return [phoneTest evaluateWithObject:mobileStr];
        }
        default:
        {
            NSString *phoneRegex = @"[0-9]{6,11}";
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
            return [phoneTest evaluateWithObject:mobileStr];
        }
            break;
    }
}

-(NSString *)getTrimString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end

@implementation NSObject(LKString)

//昵称
+ (BOOL)validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

//用户名
+ (BOOL)validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{0,10}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

//密码
+ (BOOL)validatePassword:(NSString *)passWord
{
    NSString *regex =@"(?=.*\\d)(?=.*[A-Z])((?=.*[a-z])).{6,16}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL inputString = [predicate evaluateWithObject:passWord];
    return inputString;
}

/**
 * 计算label的高度
 */
+ (CGSize)getStringRect:(NSString*)aString labelWidth:(CGFloat)labelWidth fontSize:(CGFloat)fontSize

{
    
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    
    CGSize retSize = [aString boundingRectWithSize:CGSizeMake(labelWidth, 0)
                                           options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                        attributes:attribute
                                           context:nil].size;
    
    return retSize;
    
}
+ (NSString *)intervalSinceNow: (NSString *)theDate
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        
        if ([timeString containsString:@"-"]) {
            
            timeString = [timeString substringFromIndex:1];
        }
        
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
        
    }
    return timeString;
}

/**
 *  将阿拉伯数字转换为中文数字
 */
-(NSString *)translationArabicNum:(NSInteger)arabicNum {
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}

+ (NSString *)convertArabicToChinese:(NSString *)string {
    NSArray *chineseList = @[@"零",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九"];
    NSString *newString = @"";
    
    for (int i = 0; i < string.length; i++) {
        NSString *str = [string substringWithRange:NSMakeRange(i, 1)];
        BOOL isNumber = [NSString isContainNumber:str];
        if (isNumber) {
            NSInteger number = str.integerValue;
            NSString *chinese = chineseList[number];
            newString = [newString stringByAppendingString:chinese];
            continue;
        }
        newString = [newString stringByAppendingString:str];
    }
    return newString;
}
/// 是否包含数字
/// @param inputString 字符串
+ (BOOL)isContainNumber:(NSString *)inputString {
    if (inputString.length == 0)
        return NO;
    NSString *regex = @"^[0-9]+([.]{0,1}[0-9]+){0,1}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);
#pragma mark ---  系统表情替换
+ (NSString *)deleFaceEmo:(NSString *)targetString {
    if (!targetString.length || !targetString) {
        return nil;
    }
    NSString *mutaStr = targetString;
    for (int i=0x1F600; i<=0x1F64F; i++) {
        if (i < 0x1F641 || i > 0x1F644) {
            int sym = EMOJI_CODE_TO_SYMBOL(i);
            NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
            
            mutaStr = [mutaStr stringByReplacingOccurrencesOfString:emoT withString:@""];
        }
    }
    return mutaStr.copy;
}

+ (NSString *)deleteCharacters:(NSString *)targetString {
    
    if (!targetString.length || !targetString) {
        return nil;
    }
    NSError *error = nil;
    NSString *pattern = @"[^a-zA-Z0-9\u4e00-\u9fa5]";//正则取反
    NSRegularExpression *regularExpress = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];//这个正则可以去掉所有特殊字符和标点
    NSString *string = [regularExpress stringByReplacingMatchesInString:targetString options:0 range:NSMakeRange(0, [targetString length]) withTemplate:@""];
    
    return string;
}

+ (NSString *)chineseToPinyin:(NSString *)chinese withSpace:(BOOL)withSpace {
    CFStringRef hanzi = (__bridge CFStringRef)chinese;
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, hanzi);
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinyin = (NSString *)CFBridgingRelease(string);
    if (!withSpace) {
        pinyin = [pinyin stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return pinyin;
}
@end

@implementation NSObject(Convenient)
+ (NSString *)stringWithChars:(char *)chars length:(int)length {
    int size = sizeof(chars);
    int minLength = MIN(size, length);
    NSMutableString *mutableStr = NSMutableString.string;
    for (int i = 0; i < minLength; i++) {
        [mutableStr appendFormat:@"%c", chars[i]];
    }
    return mutableStr.copy;
}

+ (NSString *)roundedToString:(float)number decimals:(int)count {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = count;
    formatter.minimumFractionDigits = count;
    return [formatter stringFromNumber:[NSNumber numberWithFloat:number]];
}
@end
