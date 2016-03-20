//
//  YXRegisterViewController.h
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/20.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXRegisterViewControllerDelegate <NSObject>

- (void)YXRegisterViewControllerDidFinishRegister;

@end


@interface YXRegisterViewController : UIViewController

// 设置代理属性
@property (nonatomic, weak)id<YXRegisterViewControllerDelegate> delegate;



@end
