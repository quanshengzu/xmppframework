//
//  YXMiLiaoViewController.m
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/27.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import "YXMiLiaoViewController.h"
#import "YXLoginStatusView.h"

@interface YXMiLiaoViewController ()

@property (nonatomic, strong)YXLoginStatusView *loginView;

@end

@implementation YXMiLiaoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"米聊";
    
    YXLoginStatusView *loginView = [YXLoginStatusView loginStatusView];
    self.loginView = loginView;
    loginView.hidden = YES;
    loginView.backgroundColor = [UIColor colorWithRed:52/255.0 green:50/255.0 blue:56/255.0 alpha:0.0];
    loginView.frame = CGRectMake(0, 0, 120, 30);
    self.navigationItem.titleView = loginView;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChange:) name:YXLoginStatusChange object:nil];
    
}

- (void)loginStatusChange:(NSNotification *)noti
{
    YXLog(@"%@",noti);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        switch ([noti.userInfo[@"loginStatus"] intValue])
        {
            case XMPPResultTypeConnecting:
                [self loginConnecting];
                break;
            case XMPPResultTypeNetError:
                self.loginView.hidden = NO;
                [self.loginView.indicator stopAnimating];
                self.loginView.showLabel.text = @"网络出错";
                break;
            case XMPPResultTypeFailure:
                self.loginView.hidden = NO;
                [self.loginView.indicator stopAnimating];
                self.loginView.showLabel.text = @"登陆失败";
                break;
            case XMPPResultTypeSuccess:
                [self loginSuccess];
                break;
                
            default:
                break;
        }
    });
    
    
}

- (void)loginSuccess
{
    self.loginView.hidden = NO;
    [self.loginView.indicator stopAnimating];
    self.loginView.showLabel.text = @"登陆成功";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.loginView.hidden = YES;
        self.navigationItem.title = @"米聊";
    });
}

- (void)loginConnecting
{
    YXLog(@"正在登陆中xxxxx");
    self.loginView.hidden = NO;
    
    [self.loginView.indicator startAnimating];
    self.loginView.showLabel.text = @"正在登陆中...";
   
}






@end
