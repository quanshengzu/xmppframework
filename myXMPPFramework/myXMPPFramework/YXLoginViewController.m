//
//  YXLoginViewController.m
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/15.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import "YXLoginViewController.h"
#import "AppDelegate.h"

/*
 首先要在服务器openfire管理后台新建用户，然后在操作相应的用户
 
 */

@interface YXLoginViewController ()

// 用户名
@property (weak, nonatomic) IBOutlet UITextField *username;

// 密码
@property (weak, nonatomic) IBOutlet UITextField *password;

// 登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@end

@implementation YXLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.username.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.password.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
    
}

// 点击登录按钮
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
    
    // 获得appDelegate
    AppDelegate *app = ( AppDelegate *)[UIApplication sharedApplication].delegate;
    // 登录
    [app login];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}




@end
