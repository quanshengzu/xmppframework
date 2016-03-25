//
//  YXLogoutViewController.m
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/19.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import "YXMeTableViewController.h"
#import "AppDelegate.h"
#import "YXUserInfo.h"
#import "XMPPvCardTemp.h"
#import "XMPPJID.h"

@interface YXMeTableViewController ()

// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headView;

// 姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

// 微信号
@property (weak, nonatomic) IBOutlet UILabel *weixinNumLabel;

@end

@implementation YXMeTableViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    
     [super viewWillAppear:animated];
    
    XMPPvCardTemp *myvCardTemp = [YXXMPPTool sharedYXXMPPTool].vCard.myvCardTemp;
    
    // 设置头像
    if (myvCardTemp.photo.length > 0)
    {
        self.headView.layer.cornerRadius = 5;
        self.headView.layer.masksToBounds = YES;
        self.headView.image = [UIImage imageWithData:myvCardTemp.photo];
    }
    
    // 设置姓名
    self.nameLabel.text = myvCardTemp.formattedName;
    
    // 设置微信号
    NSString *username = [YXUserInfo sharedYXUserInfo].username;
    self.weixinNumLabel.text = [NSString stringWithFormat:@"微信号:%@",username];
    
}


@end
