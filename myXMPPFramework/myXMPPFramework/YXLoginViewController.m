//
//  YXLoginViewController.m
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/15.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import "YXLoginViewController.h"

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
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}




@end
