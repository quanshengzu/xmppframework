//
//  YXChatViewController.h
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/26.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPJID.h"

@interface YXChatViewController : UIViewController

// 通讯录中当前用户好友的Jid
@property (nonatomic, strong)XMPPJID *friendJid;

@end
