//
//  YXUserInfo.m
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/19.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import "YXUserInfo.h"

#define usernameKey @"usernameKey"
#define passwordKey @"passwordKey"
#define loginStatusKey @"loginStatusKey"

static NSString *domain = @"127.0.0.1";

@implementation YXUserInfo

singleton_implementation(YXUserInfo)

#pragma mark - 保存用户信息到沙盒
- (void)saveUserInfoToSandbox
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.username forKey:usernameKey];
    [defaults setObject:self.password forKey:passwordKey];
    [defaults setBool:self.loginStatus forKey:loginStatusKey];
    
    // 同步
    [defaults synchronize];
    
}



#pragma mark - 从沙盒读取用户信息
- (void)loadUserInfoToSandbox
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.username = [defaults objectForKey:usernameKey];
    self.password = [defaults objectForKey:passwordKey];
    self.loginStatus = [defaults boolForKey:loginStatusKey];
}

- (NSString *)jidStr
{
    return [NSString stringWithFormat:@"%@@%@",self.username,domain];
}




@end
