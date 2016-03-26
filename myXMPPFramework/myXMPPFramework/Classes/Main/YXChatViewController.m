//
//  YXChatViewController.m
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/26.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import "YXChatViewController.h"
#import "YXInputView.h"
#import "HttpTool.h"
#import "UIImageView+WebCache.h"

@interface YXChatViewController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

// inputView底部的约束
@property (nonatomic, strong)NSLayoutConstraint *inputViewBottomConstraint;

// inputView高度的约束
@property (nonatomic, strong)NSLayoutConstraint *inputViewHeightConstraint;

// 查询结果控制器
@property (nonatomic, strong)NSFetchedResultsController *resultController;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)HttpTool *httpTool;

@end

@implementation YXChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 必须要设置
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 准备UI
    [self prepareUI];
    
    // 监听键盘的弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // 加载聊天数据
    [self loadMessages];
    
}

#pragma mark - 监听键盘frame的改变
- (void)keyboardFrameWillChange:(NSNotification *)noti
{
    //NSLog(@"%@",noti);
    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    _inputViewBottomConstraint.constant = [UIScreen mainScreen].bounds.size.height - rect.origin.y;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    [self scrollToBottom];
}

// 退出键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareUI
{
    // 1.添加tableView
    UITableView *tableView = [[UITableView alloc] init];
    //tableView.backgroundColor = [UIColor blueColor];
    // 设置数据源和代理
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    // 2.添加inputView
    YXInputView *inputView = [YXInputView inputView];
    inputView.textView.delegate = self;
    [inputView.addButton addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inputView];
    
    
    // 3.添加约束 VFL
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *dict3 = @{@"tableView":tableView,
                            @"inputView":inputView};
    
    NSArray *tableViewContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:dict3];
    [self.view addConstraints:tableViewContraints];
    
    NSArray *inputViewContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputView]-0-|" options:0 metrics:nil views:dict3];
    [self.view addConstraints:inputViewContraints];
    
    NSArray *VerticalContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[tableView]-0-[inputView(44)]-0-|" options:0 metrics:nil views:dict3];
    [self.view addConstraints:VerticalContraints];
    
    // 获取到inputView底部的约束
    _inputViewBottomConstraint = VerticalContraints.lastObject;
    // 获取到inputView高度的约束
    _inputViewHeightConstraint = VerticalContraints[2];
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *text = textView.text;
    
    CGFloat contentH = textView.contentSize.height;
    YXLog(@"发生消息:%f",contentH);
    
    if (contentH > 38 && contentH < 68)
    {
        _inputViewHeightConstraint.constant = contentH + 20;
    }
    
    if ([text rangeOfString:@"\n"].length != 0)
    {
//        YXLog(@"发生消息:%@",text);
       
        // 去掉换行符
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        // 发送消息
        [self sendMessage:text bodyType:@"text"];
        
        // 清空textView
        textView.text = nil;
        
        // 发送完消息后
        _inputViewHeightConstraint.constant = 44;
        
    } else
    {
        YXLog(@"%@",text);
    }
    
}

#pragma mark - 发送消息
- (void)sendMessage:(NSString *)message bodyType:(NSString *)bodyType
{
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    [msg addAttributeWithName:bodyType stringValue:@"bodyType"];
    
    [msg addBody:message];
    
    // 通过xmppStream发送消息
    [[YXXMPPTool sharedYXXMPPTool].xmppStream sendElement:msg];
    
}

#pragma mark - 表格滚动到底部
- (void)scrollToBottom
{
    if (_resultController.fetchedObjects.count > 0)
    {
        NSInteger lastRow = _resultController.fetchedObjects.count - 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

#pragma mark - 加载消息聊天数据
- (void)loadMessages
{
    // 1.获取上下文，关联模型文件
    NSManagedObjectContext *context = [YXXMPPTool sharedYXXMPPTool].messageStorage.mainThreadManagedObjectContext;
    
    // 2.设置fetchRequest
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    // 3.设置过滤
    // streamBareJidStr:当前用户的jid
    // bareJidStr:当前用户的好友的jid
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[YXUserInfo sharedYXUserInfo].jidStr,self.friendJid.bare];
    fetchRequest.predicate = pre;
    
    // 4.设置排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    fetchRequest.sortDescriptors = @[sort];
    
    // 5.执行
    _resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    // 设置代理
    _resultController.delegate = self;
    
    NSError *error = nil;
    [_resultController performFetch:&error];
    if (error)
    {
        YXLog(@"%@",error);
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"chatCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    // 取出消息模型
    XMPPMessageArchiving_Message_CoreDataObject *friend = _resultController.fetchedObjects[indexPath.row];
    
    // 判断是图片还是文本
    NSString *bodyType = [friend.message attributeStringValueForName:@"bodyType"];
    
    if ([bodyType isEqualToString:@"image"])
    {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:friend.body] placeholderImage:[UIImage imageNamed:@"DefaultHead"]];
        // 防止复用
        cell.textLabel.text = nil;
        
    } else if ([bodyType isEqualToString:@"text"])
    {
        // 判断消息的发送者
        if (friend.outgoing.boolValue)
        {
            // 发送消息
            // 赋值
            cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",[YXUserInfo sharedYXUserInfo].username,friend.body];
            
        } else
        {
            // 接受消息
            cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",self.friendJid.user,friend.body];
            
        }
        // 防止复用
        cell.imageView.image = nil;

    }
    
    
    return cell;
    
}

#pragma mark - NSFetchedResultsControllerDelegate数据有变化就会调用这个方法
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    YXLog(@"数据发生了改变");
    // 刷新表格
    [self.tableView reloadData];
    
    // 表格滚动到底部
    [self scrollToBottom];
}

// 选择发送图片
- (void)addImage
{
    // 打开图片选择器
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@",info);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 将图片上传到文件服务器
    // 文件上传路径http://localhost:8080/imfileserver/upload/Image/ + "图片名"
    
    
    
    // 1.取文件名 用户+时间
    NSString *username = [YXUserInfo sharedYXUserInfo].username;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMddhhmmss";
    NSString *timeStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *fileName = [username stringByAppendingString:timeStr];
    
    // 2.拼接上传路径
    NSString *path = [@"http://localhost:8080/imfileserver/upload/Image/" stringByAppendingString:fileName];
    
    // 3.使用http PUT上传
    [_httpTool uploadData:UIImageJPEGRepresentation(image, 0.75) url:[NSURL URLWithString:path] progressBlock:nil completion:^(NSError *error) {
        
        if (!error)
        {
            NSLog(@"图片上传成功");
            
            // 图片上传成功后将图片的url发送给openfire服务器
            [self sendMessage:path bodyType:@"image"];
            
        }
        
    }];
    
}

- (HttpTool *)httpTool
{
    if (_httpTool == nil)
    {
        _httpTool = [[HttpTool alloc] init];
    }
    return _httpTool;
}





@end
