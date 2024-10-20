//
//  DNKNetworkConst.h
//  NewSmart
//
//  Created by 陈群 on 2022/7/1.
//

#ifndef DNKNetworkConst_h
#define DNKNetworkConst_h

typedef NS_ENUM(NSInteger, DNKNetworkCode) {
    /// 家庭不存在
    DNKCodeNotExistHouse = 32,
    /// 未绑定家庭
    DNKCodeNotAssociatedHouse = 34,
    /// 网关已被绑定
    DNKCodeGwHasBound = 48,
    /// 场景不存在
    DNKCodeNotExistScene = 58,
    
    /// 设备已被182****1234绑定
    DNKCodeDeviceAddedByOther = 104,
    /// 房屋已存在工程人员
    DNKCodeFamilyHasEngineering = 91,
    /// 辉连红外宝 接口 请求的时候 要传一个mac 地址，这个地址必须要要取设置 同步至服务端后服务端才有
    DNKCodeIrMacNotFound = 84,
    ///token 过期
    DNKCodeTokenExpired  = 21333,
    
};

#endif /* DNKNetworkConst_h */
