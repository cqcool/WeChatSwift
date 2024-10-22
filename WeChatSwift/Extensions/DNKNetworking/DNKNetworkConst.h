//
//  DNKNetworkConst.h
//  NewSmart
//
//  Created by 陈群 on 2022/7/1.
//

#ifndef DNKNetworkConst_h
#define DNKNetworkConst_h

typedef NS_ENUM (NSInteger, DNKNetworkCode) {
    // 临时token不匹配
    REFRESH_TOKEN_TIMEOUT = -5,
    // 您的账号已退出，请重新登录
    TOKEN_ERROR = -6,
    // 群已封禁
    GROUP_IS_BLOCKED = -7,
    // 添加朋友后继续畅聊
    ERR_IS_FRIEND = -8,
    // 您的账号涉及违规，已被管理员禁止登录app。
    ERROR_USER_STATUS = -9,
    // 支付密码错误,请重试
    ERR_PAY_PASSWORD = -10,
    // 群已解散
    GROUP_IS_REMOVE = -11,
    // 为保障资金安全，本次交易需确认为账户实名人本人操作。请点击“核验身份”以继续交易
    ERR_FUND_STATUS = -12,
    // 当前交易涉嫌违规，暂无法完成支付，请注意合法使用支付账户，否则将升级限制措施。如有疑问，可点击“了解详情”查看说明。
    ERR_DEAL_STATUS = -13,
    //根据国家监管要求，请确认你曾在微信支付留存的手机号%s当前是否为你本人使用。请在%s前处理，以正常使用微信支付。
    ERR_SURE_TEL = -14,
    //余额不足
    ERR_BALANCE_NOT_ENOUGH = -15,
    //已被移出群聊
    GROUP_USER_IS_REMOVE = -17,
    //账号暂未注册
    ERROR_ACCOUNT_UN_REGISTER = -18,
    //账号或密码错误，请重新填写。
    ERROR_USER_ACCOUNT_OR_PASSWORD = -19,
    //密码错误，请重新输入
    ERROR_USER_PASSWORD = -20,
    //已被刪除好友
    FRIEND_REMOVE = -21,
    // 您的账号涉及违规，已被管理员禁止发言.
    ERR_USER_NOT_CHAT = -22,
};
#endif /* DNKNetworkConst_h */
