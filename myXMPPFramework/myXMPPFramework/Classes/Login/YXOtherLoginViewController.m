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
#import "YXUserInfo.h"


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
    // 添加文本输入框左边的图片
    [self.password addLeftViewWithImage:@"Card_Lock"];
    
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
}

- (IBAction)loginBtnDidClick:(id)sender
{
    // 获得帐号和密码
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    
    // 将用户名和密码保存到单例
    [YXUserInfo sharedYXUserInfo].username = username;
    [YXUserInfo sharedYXUserInfo].password = password;
    
    [super login];
    
}

// 取消
- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
