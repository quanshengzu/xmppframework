//
//  YXRegisterViewController.m
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/20.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import "YXRegisterViewController.h"
#import "YXUserInfo.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD+BWMExtension.h"

@interface YXRegisterViewController ()

// 注册用户名
@property (weak, nonatomic) IBOutlet UITextField *username;

// 注册密码
@property (weak, nonatomic) IBOutlet UITextField *password;

// 注册按钮
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation YXRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.username.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.password.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    [self.registerBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
    // 添加文本输入框左边的图片
    [self.password addLeftViewWithImage:@"Card_Lock"];
    
    
    
}
- (IBAction)registerBtnDidClick:(id)sender
{
    // 退出键盘
    [self.view endEditing:YES];
    
    // 判断注册用户名是否电话号码
    if (![self.username isTelphoneNum])
    {
        [MBProgressHUD bwm_showTitle:@"用户名必须是手机号" toView:self.view hideAfter:1];
        return;
    }
    
    // 将注册用户名和密码保存到用户信息单例
    YXUserInfo *userInfo = [YXUserInfo sharedYXUserInfo];
    userInfo.registerUsername = self.username.text;
    userInfo.registerPassword = self.password.text;
    
    // 提示正在注册
    [MBProgressHUD bwm_showHUDAddedTo:self.view title:@"正在注册中..."];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.registerOperation = YES;
    
     __typeof(self) __weak weakSelf = self;
    [app xmppUserRegister:^(XMPPResultType type) {
        
        [weakSelf handleRegisterResult:type];
    }];
    
}

- (void)handleRegisterResult:(XMPPResultType)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        switch (type)
        {
            case XMPPResultTypeRegisterSuccess:
                YXLog(@"注册成功");
                // 注册成功回到登录界面，且显示注册用户名
                [self dismissViewControllerAnimated:YES completion:nil];
                if ([self.delegate respondsToSelector:@selector(YXRegisterViewControllerDidFinishRegister)])
                {
                    [self.delegate YXRegisterViewControllerDidFinishRegister];
                }
                
                break;
            case XMPPResultTypeRegisterFailure:
                YXLog(@"注册失败");
                [SVProgressHUD showErrorWithStatus:@"注册失败" maskType:SVProgressHUDMaskTypeBlack];
                break;
                
            default:
                break;
        }
    });
}



// 取消
- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 监听文本输入框文本的变化
- (IBAction)textChange:(UITextField *)sender
{
    
    self.registerBtn.enabled = (self.username.text.length != 0 && self.password.text.length != 0);
}






@end
