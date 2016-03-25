//
//  YXEditorTableViewController.m
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/25.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import "YXEditorTableViewController.h"

@interface YXEditorTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation YXEditorTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",self.cell);
    
    self.navigationItem.title = self.cell.textLabel.text;
    
    self.textField.text = self.cell.detailTextLabel.text;
    
    // 添加按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(btnDidClick)];
    
}

- (void)btnDidClick
{
    // 1.修改cell的detailTextLabel
    self.cell.detailTextLabel.text = self.textField.text;
    
    [self.cell layoutSubviews];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    // 通过设置代理，告诉YXProfileTableViewController修改完成
    if ([self.delegate respondsToSelector:@selector(editorProfileViewControllerDidSave)])
    {
        [self.delegate editorProfileViewControllerDidSave];
    }
    
    
}






@end
