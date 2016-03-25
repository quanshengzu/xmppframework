//
//  YXEditorTableViewController.h
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/25.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol YXEditorTableViewControllerDelegate <NSObject>

@optional
- (void)editorProfileViewControllerDidSave;

@end

@interface YXEditorTableViewController : UITableViewController

@property (nonatomic, strong)UITableViewCell *cell;

// 设置代理属性
@property (nonatomic, weak)id<YXEditorTableViewControllerDelegate> delegate;

@end
