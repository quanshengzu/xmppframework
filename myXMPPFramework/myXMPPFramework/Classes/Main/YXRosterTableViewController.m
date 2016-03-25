//
//  YXRosterTableViewController.m
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/25.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import "YXRosterTableViewController.h"

@interface YXRosterTableViewController ()

// 保存查询到的数据
@property (nonatomic, strong)NSArray *friends;

@end

@implementation YXRosterTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 从花名册数据库中读取数据
    //[self loadRosterData];
    
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
    self.friends = [context executeFetchRequest:fetchRequest error:nil];
    NSLog(@"%@",self.friends);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"rosterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // 取出模型
    XMPPUserCoreDataStorageObject *friend = self.friends[indexPath.row];
    NSString *jidstr = friend.jidStr;
    NSString *domain = @"127.0.0.1";
    NSInteger length = jidstr.length;
    NSRange range = [jidstr rangeOfString:domain];
    NSString *name = [jidstr substringWithRange:NSMakeRange(0, length - range.length - 1)];
    
    cell.textLabel.text = name;
    
    return cell;
    
    
}

- (NSArray *)friends
{
    if (_friends == nil)
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
       _friends = [context executeFetchRequest:fetchRequest error:nil];
    }
    return _friends;
}



@end
