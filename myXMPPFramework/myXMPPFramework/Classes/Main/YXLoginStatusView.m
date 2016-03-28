//
//  YXLoginStatusView.m
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/27.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import "YXLoginStatusView.h"

@implementation YXLoginStatusView

+(instancetype)loginStatusView
{
    return [[NSBundle mainBundle] loadNibNamed:@"YXLoginStatusView" owner:nil options:nil].lastObject;
}

@end
