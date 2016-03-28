//
//  YXLoginStatusView.h
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/27.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXLoginStatusView : UIView

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (weak, nonatomic) IBOutlet UILabel *showLabel;

+(instancetype)loginStatusView;

@end
