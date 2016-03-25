//
//  YXProfileTableViewController.m
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/24.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import "YXProfileTableViewController.h"
#import "XMPPvCardTemp.h"
#import "YXEditorTableViewController.h"

@interface YXProfileTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,YXEditorTableViewControllerDelegate>

// 姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headView;

// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nickname;

// 微信号
@property (weak, nonatomic) IBOutlet UILabel *weixinNum;

// 我的地址
@property (weak, nonatomic) IBOutlet UILabel *myAddress;

// 电话
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;

// 公司
@property (weak, nonatomic) IBOutlet UILabel *company;

// 部门
@property (weak, nonatomic) IBOutlet UILabel *department;

@end

@implementation YXProfileTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 获得电子名片
    XMPPvCardTemp *myvcard = [YXXMPPTool sharedYXXMPPTool].vCard.myvCardTemp;
    
    // 设置姓名
    self.nameLabel.text = myvcard.formattedName;
    
    // 设置头像
    if (myvcard.photo.length > 0)
    {
        self.headView.image = [UIImage imageWithData:myvcard.photo];
    }
    
    // 设置昵称
    self.nickname.text = myvcard.nickname;
    
    // 设置微信号
    self.weixinNum.text = [YXUserInfo sharedYXUserInfo].username;
    
    // 设置我的地址
    self.myAddress.text = @"深圳";
    
    //
    self.phoneNum.text = @"13245678901";
    
    self.company.text = myvcard.orgName;
    
    self.department.text = myvcard.orgUnits.firstObject;
    
    
}

#pragma mark - UITableViewDelegate点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.获得cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // 2.cell对应的tag
    NSInteger tag = cell.tag;
    
    // 判断
    if (tag == 1)
    {
        // 不做任何操作
        return;
    } else if (tag == 0)
    {
        // 编辑头像
        [self showAlertController];
        
    } else if (tag == 2)
    {
        // 切换到编辑控制器,将当前cell传递过去
        NSLog(@"切换到编辑控制器");
        [self performSegueWithIdentifier:@"profile2editor" sender:cell];
        
    }
}

#pragma mark - 跳转控制器传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController * destVc = segue.destinationViewController;
    
    if ([destVc isKindOfClass:[YXEditorTableViewController class]])
    {
        YXEditorTableViewController *edtVC = (YXEditorTableViewController *)destVc;
        // 赋值
        edtVC.cell = sender;
        edtVC.delegate = self;
        
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@",info);
    
    // 选择已经编辑过的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.headView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    [self editorProfileViewControllerDidSave];
    
}

#pragma mark - YXEditorTableViewControllerDelegate
- (void)editorProfileViewControllerDidSave
{
    // 将修改后的数据更新到服务器
     XMPPvCardTemp *myvcard = [YXXMPPTool sharedYXXMPPTool].vCard.myvCardTemp;
    // 姓名
    myvcard.formattedName = self.nameLabel.text;
    
    // 头像
    myvcard.photo = UIImagePNGRepresentation(self.headView.image);
    
    // 昵称
    myvcard.nickname = self.nickname.text;
    
    // 公司
    myvcard.orgName = self.company.text;
    
    // 部门
    myvcard.orgUnits = @[self.department.text];
    
    // 更新到服务器
    [[YXXMPPTool sharedYXXMPPTool].vCard updateMyvCardTemp:myvcard];
    
    
}

#pragma mark - 编辑头像
- (void)showAlertController
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:@"提示" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIImagePickerController *pickController = [[UIImagePickerController alloc] init];
    
    // 设置图片可编辑
    pickController.allowsEditing = YES;
    
    // 设置代理
    pickController.delegate = self;
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        pickController.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 显示
        [self presentViewController:pickController animated:YES completion:nil];
    }];
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        pickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 显示
        [self presentViewController:pickController animated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        // 不进行任何操作
    }];
    
    [alert addAction:camera];
    [alert addAction:photo];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

}







@end
