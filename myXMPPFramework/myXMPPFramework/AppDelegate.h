//
//  AppDelegate.h
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/15.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

// 登录结果的枚举
typedef enum {
    XMPPResultTypeSuccess,// 登录成功
    XMPPResultTypeFailure,// 登录失败
    XMPPResultTypeNetError // 网络故障

}XMPPResultType;

// 登录结果的回调
typedef void(^XMPPResultBlock)(XMPPResultType type);


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// 登录结果回调给调用者
- (void)xmppUserLogin:(XMPPResultBlock) xmppResultBlock;


@end

