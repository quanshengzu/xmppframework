//
//  YXInputView.m
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/26.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import "YXInputView.h"

@implementation YXInputView

+(instancetype)inputView
{
    return [[NSBundle mainBundle] loadNibNamed:@"YXInputView" owner:nil options:nil].lastObject;
}

@end
