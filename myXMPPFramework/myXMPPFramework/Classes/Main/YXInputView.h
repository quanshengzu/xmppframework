//
//  YXInputView.h
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/26.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXInputView : UIView
@property (weak, nonatomic) IBOutlet UIButton *addButton;

+(instancetype)inputView;

@property (weak, nonatomic) IBOutlet UITextView *textView;


@end
