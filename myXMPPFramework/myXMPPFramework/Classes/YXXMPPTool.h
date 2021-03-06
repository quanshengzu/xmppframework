//
//  YXXMPPTool.h
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/20.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XMPPFramework.h"

extern NSString  *YXLoginStatusChange;

@interface YXXMPPTool : NSObject

singleton_interface(YXXMPPTool)

// 登录结果的枚举
typedef enum {
    XMPPResultTypeConnecting,// 正在登陆中...
    XMPPResultTypeSuccess,// 登录成功
    XMPPResultTypeFailure,// 登录失败
    XMPPResultTypeNetError, // 网络故障
    XMPPResultTypeRegisterSuccess, // 注册成功
    XMPPResultTypeRegisterFailure // 注册失败
    
}XMPPResultType;

// 登录结果的回调
typedef void(^XMPPResultBlock)(XMPPResultType type);// 登录结果block

// xmppStream是跟服务器交流的最主要的类
@property (nonatomic, strong)XMPPStream *xmppStream;

// 用来标记是否注册
@property (assign, nonatomic,getter=isRegister) BOOL registerOperation;

// 电子名片模块
@property (nonatomic, strong,readonly)XMPPvCardTempModule *vCard;

// 花名册存储
@property (nonatomic, strong)XMPPRosterCoreDataStorage *rosterStorge;

// 花名册模块
@property (nonatomic, strong)XMPPRoster *roster;

// 消息模块数据存储
@property (nonatomic, strong)XMPPMessageArchivingCoreDataStorage *messageStorage;


// 登录,并将结果回调给调用者
- (void)xmppUserLogin:(XMPPResultBlock) xmppResultBlock;

// 注册,并将结果回调给调用者
- (void)xmppUserRegister:(XMPPResultBlock) xmppResultBlock;

// 注销
- (void)xmppUserLogout;





@end
