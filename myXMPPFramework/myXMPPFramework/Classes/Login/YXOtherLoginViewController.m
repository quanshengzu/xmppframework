//
//  YXOtherLoginViewController.m
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/18.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import "YXOtherLoginViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD+BWMExtension.h"
#import "SVProgressHUD.h"


@interface YXOtherLoginViewController ()

// 用户名
@property (weak, nonatomic) IBOutlet UITextField *username;

// 密码
@property (weak, nonatomic) IBOutlet UITextField *password;

// 登陆按钮
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@end

@implementation YXOtherLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置背景图片
    self.username.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.password.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
}

- (IBAction)loginBtnDidClick:(id)sender
{
    // 获得帐号和密码
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    
    // 将帐号和密码保存到沙盒
    // 获得偏好设置
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:username forKey:@"username"];
    [userDefault setObject:password forKey:@"password"];
    
    // 同步
    [userDefault synchronize];
    
    // 登陆前提示
    [MBProgressHUD bwm_showHUDAddedTo:self.view title:@"正在登陆中..."];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
//    __typeof(self) __weak weakSelf = self;
    
    [app xmppUserLogin:^(XMPPResultType type) {
        
        [self handleResultType:type];
        
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
    // 隐藏模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 1.从storyboard中加载主界面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.view.window.rootViewController = storyboard.instantiateInitialViewController;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}


@end
