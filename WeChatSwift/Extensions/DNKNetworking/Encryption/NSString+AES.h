//
//  NSString+AES.h
//  AES加密解密
//
//  Created by flagadmin on 2019/8/7.
//  Copyright © 2019 flagadmin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (AES)
/**< 加密方法 */
- (NSString*)aci_encryptWithAES;

/**< 解密方法 */
- (NSString*)aci_decryptWithAESWithKey:(NSString *)key iv:(NSString *)iv;
@end

NS_ASSUME_NONNULL_END
