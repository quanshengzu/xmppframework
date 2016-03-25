//
//  YXAddContactTableViewController.m
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/25.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import "YXAddContactTableViewController.h"
#import "MBProgressHUD+BWMExtension.h"

@interface YXAddContactTableViewController ()

// 电话号码文本输入框
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;


@end

@implementation YXAddContactTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addContact)];
    
}

#pragma mark - 添加联系人
- (void)addContact
{
    // 退出键盘
    [self.view endEditing:YES];
    
    // 判断是否是正确的电话号码
    if (![self.phoneNum isTelphoneNum])
    {
        [MBProgressHUD bwm_showTitle:@"请输入正确的手机号" toView:self.view hideAfter:1];
        return;
    }
    
    // 判断是否添加自己
    NSString *username = self.phoneNum.text;
    
    if ([username isEqualToString:[YXUserInfo sharedYXUserInfo].username])
    {
        [MBProgressHUD bwm_showTitle:@"不能添加自己为好友" toView:self.view hideAfter:1];
        return;

    }
    
    // 判断是否已经添加过为好友
    NSString *friendJidStr = [NSString stringWithFormat:@"%@@%@",username,domain];
    XMPPJID *friendJid = [XMPPJID jidWithString:friendJidStr];
    
    if ([[YXXMPPTool sharedYXXMPPTool].rosterStorge userExistsWithJID:friendJid xmppStream:[YXXMPPTool sharedYXXMPPTool].xmppStream])
    {
        [MBProgressHUD bwm_showTitle:@"当前好友已经存在" toView:self.view hideAfter:1];
        return;
    }
    
    // 添加好友,订阅
    [[YXXMPPTool sharedYXXMPPTool].roster subscribePresenceToUser:friendJid];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}




    




@end
