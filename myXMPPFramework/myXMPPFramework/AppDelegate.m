//
//  AppDelegate.m
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/15.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"
#import "YXNavigationController.h"
#import "DDLog.h"
#import "DDTTYLogger.h"// 打印日志



@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 获取沙盒目录
    NSString *sandbox = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSLog(@"%@",sandbox);
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    [YXNavigationController setupNavigationBar];
    
    // 从沙盒中读取用户信息
    [[YXUserInfo sharedYXUserInfo] loadUserInfoToSandbox];
    
    // 判断用户的登录状态，如果登录过，直接跳转到主界面并连接到服务器
    if ([YXUserInfo sharedYXUserInfo].loginStatus)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = storyboard.instantiateInitialViewController;
        
        // 连接到服务器
        [[YXXMPPTool sharedYXXMPPTool] xmppUserLogin:nil];
    }
    
    
    return YES;
}



@end
