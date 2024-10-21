//
//  NSString+Ext.h
//  NewSmart
//
//  Created by 陈群 on 2022/1/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Ext)
- (BOOL)isNonEmpty;
/// 字符串转date
/// @param formatter 日期格式
- (NSDate *)toDate:(NSString *)formatter;

//判断是否含有非法字符 yes 有  no没有
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content;

/// 是否包含表情
- (BOOL)containEmoji;

/// Unicode 转中文
/// @param jsonString jsonString
+ (NSString *)filterChinese:(NSString *)jsonString;
/// 转成16进制字符串
+ (NSString *)toHEXString:(NSInteger)integer;
/// 16 进制字符串 转 integer
- (NSInteger)integerWithHex;
/// 字符串 转md5 字符串
- (NSString *)md5Encrpt;
- (NSString *)decryptUseDESWithKey:(NSString*)key offset:(NSString *)offset;
/// 16进制字符串 转NSData
- (NSData *)hexStringToData;
#pragma mark - 类方法
/// 获取当前连接的wifi 名称
+ (NSString *)wifiName;
#pragma mark 时间
/// 获取时间戳UTC(毫秒)
+ (NSNumber *)currentTimeStamp;
/// 获取时间戳UTC(秒)
+ (NSInteger)currentSecondTimestamp;
/// 通过日期格式生成日期字符串
/// @param date date
/// @param formatter 日期格式
+ (NSString *)timeTextWithDate:(NSDate *)date
                     formatter:(NSString *)formatter;
/// 通过时间戳生成日期字符串
/// @param timestamp 时间戳(毫秒)
/// @param formatter 日期格式
+ (NSString *)timeTextWithTimestamp:(long)timestamp
                          formatter:(NSString *)formatter;
/// 将时间字符串转换成基于2000年1月1号的时间戳
/// @param dateString 时间字符串
/// @param formatter 格式
//+(NSTimeInterval )stringToTimeStampSince2020:(NSString *)dateString
//                                   formatter:(NSString *)formatter;
/// 毫秒时间戳 。注意接口返回的时间戳是毫秒为单位 ， 网关指令返回的时间戳都是以秒为单位、
/// 毫秒时间戳
+ (NSTimeInterval)timeStampWithDateText:(NSString *)dateText
                              formatter:(NSString *)formatter;

/// 随机32位UUID（仅小谢字母构成）
+ (NSString *)random32bitString;
/// 随机64位UUID（大小字母+数字构成）
+ (NSString *)random32Udid;
/// 获取手机ip地址
+ (NSString *)getIpAddresses;

#pragma mark - check

/// 是否是正确的ip 地址
/// - Parameter ipAddress: ip地址
+ (BOOL)validIPAddress:(NSString *)ipAddress;

/// 根据分隔符 返回 被分割后的 第一个string 对象
/// - Parameter separator: 分隔符
- (NSString *)firstComponentBySeparator:(NSString *)separator;
@end

@interface NSString (LK)
//16进制byty字符串 转成  NSData
-(NSData *)convert16ByteData;
//判断用户名
+(BOOL)checkUserNameWithRegex:(NSString *)userName;
//判断中文、字母、数字
+(BOOL)checkUserNameWithRegex1:(NSString *)userName;
//判断邮箱是否合法的代码   拆分验证
+(BOOL)checkEmailWithComponent:(NSString*)email;
//正则表达式检测邮箱
+(BOOL)checkEmailWithRegex:(NSString *)email;

/**
 正则手机号码验证

 @param phone 手机号
 @return 符合YES 不符合NO
 */
+(BOOL)checkMobileNumble:(NSString *)phone;

/// 检测输入的内容 是否符合当地手机号规则
/// @param mobileStr 手机号
/// @param contry 国家
+(BOOL)checkMobileNumble:(NSString *)mobileStr contry:(NSUInteger)contry;
//获取去除空格后的字符串
-(NSString*)getTrimString;
/// 16进制转10进制
+ (NSNumber *)numberHexString:(NSString *)aHexString;

@end

/// String工具类
@interface NSObject(LKString)
/// 校验密码 6-16 位 必须包含 数字 大小写字母
/// @param passWord 密码内容
+ (BOOL)validatePassword:(NSString *)passWord;
//指定时间与当前时间做对比 返回 、多少天之前，多少小时之前，多少秒之前
+ (NSString *)intervalSinceNow:(NSString *) theDate;

/// 根据文字内容、label 宽度、字体大小 获取对应的尺寸
/// - Parameters:
///   - aString: 文字内容
///   - labelWidth: label 宽度
///   - fontSize: 字体大小
+ (CGSize)getStringRect:(NSString*)aString
             labelWidth:(CGFloat)labelWidth
                   fontSize:(CGFloat)fontSize;
/**
 *  将阿拉伯数字转换为中文数字
 */
-(NSString *)translationArabicNum:(NSInteger)arabicNum;

/// 将包含数字的 字符串 转换成中文字符串
+ (NSString *)convertArabicToChinese:(NSString *)string;
/// 是否包含数字
/// @param inputString 字符串
+ (BOOL)isContainNumber:(NSString *)inputString;


///  去掉所有的特殊字符和标点符号
/// @param targetString 源字符串
+ (NSString *)deleteCharacters:(NSString *)targetString;

/// 去掉字符串中包含的表情包
/// @param targetString 源字符串
+ (NSString *)deleFaceEmo:(NSString *)targetString;

/// 中文字符串转拼音字符串
/// @param chinese 中文字符串
/// @param withSpace 是否带空格
+ (NSString *)chineseToPinyin:(NSString *)chinese
                    withSpace:(BOOL)withSpace;

@end

@interface NSObject(Convenient)
/// char 转字符串
/// - Parameters:
///   - chars: char *
///   - length: 长度
+ (NSString *)stringWithChars:(char *)chars length:(int)length;
/// 返回指定decimals位小数
+ (NSString *)roundedToString:(float)number decimals:(int)count;
@end
NS_ASSUME_NONNULL_END
