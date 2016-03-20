//
//  YXLogoutViewController.m
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/19.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import "YXLogoutViewController.h"
#import "AppDelegate.h"
#import "YXUserInfo.h"

@interface YXLogoutViewController ()

@end

@implementation YXLogoutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
   
}

// 注销
- (IBAction)logout:(id)sender
{
    // 记录用户的登录状态为  注销
    [YXUserInfo sharedYXUserInfo].loginStatus = NO;
    
    // 保存用户信息
    [[YXUserInfo sharedYXUserInfo] saveUserInfoToSandbox];
    
    
    [[YXXMPPTool sharedYXXMPPTool] xmppUserLogout];
    
}


@end
