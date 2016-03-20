//
//  YXBaseLoginViewController.m
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/19.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import "YXBaseLoginViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD+BWMExtension.h"
#import "SVProgressHUD.h"
#import "YXUserInfo.h"


@interface YXBaseLoginViewController ()

@end

@implementation YXBaseLoginViewController

// 登录
- (void)login
{
    // 退出键盘
    [self.view endEditing:YES];
    
    // 登陆前提示
    [MBProgressHUD bwm_showHUDAddedTo:self.view title:@"正在登陆中..."];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
     // 已经注册过
    app.registerOperation = NO;
    
       __typeof(self) __weak weakSelf = self;
    
    [app xmppUserLogin:^(XMPPResultType type) {
        
        [weakSelf handleResultType:type];
        
    }];
    
}

// 处理回调的结果
- (void)handleResultType:(XMPPResultType)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        switch (type)
        {
            case XMPPResultTypeSuccess:
                NSLog(@"登陆成功");
                // 跳转到主界面
                [self enterMainView];
                
                break;
            case XMPPResultTypeFailure:
                NSLog(@"登陆失败");
                [SVProgressHUD showErrorWithStatus:@"用户名或密码错误" maskType:SVProgressHUDMaskTypeBlack];
                break;
            case XMPPResultTypeNetError:
                NSLog(@"网络错误");
                [SVProgressHUD showErrorWithStatus:@"网络不给力"];
                break;
                
            default:
                break;
        }
        
    });
    
    
}

// 登陆成功后跳转到主界面
- (void)enterMainView
{
    // 记录用户的登录状态为  登录
    [YXUserInfo sharedYXUserInfo].loginStatus = YES;
    
    // 保存用户信息
    [[YXUserInfo sharedYXUserInfo] saveUserInfoToSandbox];
    
    // 隐藏模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 1.从storyboard中加载主界面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.view.window.rootViewController = storyboard.instantiateInitialViewController;
}


@end
