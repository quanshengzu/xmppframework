//
//  YXRosterTableViewController.m
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/25.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import "YXRosterTableViewController.h"
#import "YXChatViewController.h"

@interface YXRosterTableViewController ()<NSFetchedResultsControllerDelegate>

// 保存查询到的数据
@property (nonatomic, strong)NSArray *friends;

// 查询结果控制器
@property (nonatomic, strong)NSFetchedResultsController *resultController;

@end

@implementation YXRosterTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 从花名册数据库中读取数据
    [self loadRosterData];
    
    [[YXXMPPTool sharedYXXMPPTool].roster fetchRoster];
    
}

- (void)loadRosterData
{
    // 使用CoreData获取数据
    // 1.获得上下文（关联到数据库）
     NSManagedObjectContext *context = [YXXMPPTool sharedYXXMPPTool].rosterStorge.mainThreadManagedObjectContext;
    
    // 2.FetchRequest(获取哪张表)
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    // 3.设置过滤和排序
    // 过滤当前登录的好友
    NSString *jidStr = [YXUserInfo sharedYXUserInfo].jidStr;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jidStr];
    fetchRequest.predicate = pre;
    
    // 排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    fetchRequest.sortDescriptors = @[sort];
    
    // 4.执行
    _resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    // 指定代理
    _resultController.delegate = self;
    
    NSError *error = nil;
    [_resultController performFetch:&error];
    if (error)
    {
        YXLog(@"%@",error);
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"rosterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // 取出模型
//    XMPPUserCoreDataStorageObject *friend = self.friends[indexPath.row];
    XMPPUserCoreDataStorageObject *friend = _resultController.fetchedObjects[indexPath.row];
    NSString *jidstr = friend.jidStr;
    NSString *domain = @"127.0.0.1";
    NSInteger length = jidstr.length;
    NSRange range = [jidstr rangeOfString:domain];
    NSString *name = [jidstr substringWithRange:NSMakeRange(0, length - range.length - 1)];
    
    cell.textLabel.text = name;
    
    // 设置用户的活跃状态
    switch (friend.sectionNum.intValue)
    {
        case 0:
            cell.detailTextLabel.text = @"在线";
            break;
        case 1:
            cell.detailTextLabel.text = @"离开";
            break;
        case 2:
            cell.detailTextLabel.text = @"离线";
            break;
            
        default:
            break;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPUserCoreDataStorageObject *friend = _resultController.fetchedObjects[indexPath.row];
    XMPPJID *friendJid = friend.jid;
    
    // 跳转到聊天控制器,将当前用户好友的jid作为参数传过去
    [self performSegueWithIdentifier:@"Roster2Chat" sender:friendJid];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id destVC = segue.destinationViewController;
    
    if ([destVC isKindOfClass:[YXChatViewController class]])
    {
        YXChatViewController *chatVC = (YXChatViewController *)destVC;
        chatVC.friendJid = sender;
    }
}


#pragma mark - 删除好友
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // 获得当前好友的Jid
        XMPPUserCoreDataStorageObject *friend = _resultController.fetchedObjects[indexPath.row];
        XMPPJID *friendJid = friend.jid;
        
        // 删除
        [[YXXMPPTool sharedYXXMPPTool].roster removeUser:friendJid];
    }
}

// 显示中文
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除好友";
}




#pragma mark - 当花名册数据库的数据发生改变就会调用这个方法
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    YXLog(@"数据发生了改变");
    // 刷新表格
    [self.tableView reloadData];
    
}


//- (NSArray *)friends
//{
//    if (_friends == nil)
//    {
//        // 使用CoreData获取数据
//        // 1.获得上下文（关联到数据库）
//        NSManagedObjectContext *context = [YXXMPPTool sharedYXXMPPTool].rosterStorge.mainThreadManagedObjectContext;
//        
//        // 2.FetchRequest(获取哪张表)
//        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
//        
//        // 3.设置过滤和排序
//        // 过滤当前登录的好友
//        NSString *jidStr = [YXUserInfo sharedYXUserInfo].jidStr;
//        NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jidStr];
//        fetchRequest.predicate = pre;
//        
//        // 排序
//        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
//        fetchRequest.sortDescriptors = @[sort];
//        
//        // 4.执行
//       _friends = [context executeFetchRequest:fetchRequest error:nil];
//    }
//    return _friends;
//}



@end
