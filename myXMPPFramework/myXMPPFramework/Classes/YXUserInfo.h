//
//  YXUserInfo.h
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/19.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface YXUserInfo : NSObject

singleton_interface(YXUserInfo)

// 用户名
@property (nonatomic, copy)NSString *username;

// 密码
@property (nonatomic, copy)NSString *password;

// 登录状态
@property (nonatomic, assign)BOOL loginStatus;

// 保存用户信息到沙盒
- (void)saveUserInfoToSandbox;

// 从沙盒读取用户信息
- (void)loadUserInfoToSandbox;



@end
