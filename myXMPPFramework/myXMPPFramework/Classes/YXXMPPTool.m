//
//  YXXMPPTool.m
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/20.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import "YXXMPPTool.h"

#import "AppDelegate.h"



/*
 用户登录的过程:
 1.初始化xmppStream
 2.连接服务器，向服务器发送myJID
 3.连接服务器成功后，向服务器发送password进行授权认证
 4.授权成功后，向服务器发送"在线"消息
 5.登录完成后跳转到主界面
 
 
 登录细节：
 1.如果用户登录成功后，点击注销回到登录界面，显示上次登录的用户名
 把用户数据保存到沙盒
 当用户登录成功后，将用户数据保存到沙盒
 启动程序的时候，再从沙盒中获取
 
 2.用户成功登录后，如果关闭APP，重新启动程序，如果没有注销，直接来到主界面
 记录登录状态
 如果用户登录过，程序重新启动的时候，自动登录到服务器
 
 */

@interface YXXMPPTool ()<XMPPStreamDelegate>

// 保存登录结果block
@property (nonatomic, copy)XMPPResultBlock xmppResultBlock;

// 电子名片存储
@property (nonatomic, strong)XMPPvCardCoreDataStorage *vCardStorge;

// 电子名片头像模块
@property (nonatomic, strong)XMPPvCardAvatarModule *avatar;

// 自动连接模块
@property (nonatomic, strong)XMPPReconnect *reconnect;

// 消息模块
@property (nonatomic, strong)XMPPMessageArchiving *message;



// 1.初始化xmppStream
- (void)setupxmppStream;

// 2.连接服务器，向服务器发送myJID
- (void)connectToHost;

// 3.连接服务器成功后，向服务器发送password进行授权认证
- (void)sendPwdToHost;

// 4.授权成功后，向服务器发送"在线"消息
- (void)sendOnLineToHost;


@end


@implementation YXXMPPTool

singleton_implementation(YXXMPPTool)

#pragma mark -初始化xmppStream
- (void)setupxmppStream
{
    // 创建xmppStream
    _xmppStream = [[XMPPStream alloc] init];
    
    /*************添加模块*************/
#warning 添加模块后一定要激活
    // 0.添加自动连接模块
    _reconnect = [[XMPPReconnect alloc] init];
    [_reconnect activate:_xmppStream];
    
    // 1.添加电子名片模块
    _vCardStorge = [[XMPPvCardCoreDataStorage alloc] init];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorge];
    // 激活
    [_vCard activate:_xmppStream];
    
    // 2.添加电子名片头像模块
    _avatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    // 激活
    [_avatar activate:_xmppStream];
    
    // 3.添加花名册模块
    _rosterStorge = [[XMPPRosterCoreDataStorage alloc] init];
    _roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterStorge];
    // 激活
    [_roster activate:_xmppStream];
    
    // 4.添加聊天数据模块
    _messageStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    _message = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_messageStorage];
    // 激活
    [_message activate:_xmppStream];
    
    
    // 指定代理
    // 队列采用全局队列，由系统去分配
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
}

#pragma mark -连接服务器，向服务器发送myJID
- (void)connectToHost
{
    YXLog(@"正在连接到服务器...");
    if (_xmppStream == nil)
    {
        [self setupxmppStream];
    }
    
    // 连接服务器前必须要向服务器发送myJID,否则会报错error:Error Domain=XMPPStreamErrorDomain Code=2 "You must set myJID before calling connect." UserInfo={NSLocalizedDescription=You must set myJID before calling connect.}
    /*
     第一个参数：用户名
     第二个参数：服务器的域名
     第三个参数：标示用户登录的客户端：iphone android
     
     */
    
    //    // 从沙盒中获得账户名
    //    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    // 从单例中获得用户名
    NSString *username = nil;
    
    // 根据是否在进行注册操作来确定用户名
    if (self.registerOperation)
    {
        username = [YXUserInfo sharedYXUserInfo].registerUsername;
        
    } else
    {
        username = [YXUserInfo sharedYXUserInfo].username;
    }
    
    // 获得当前客户端
    NSString *model = [UIDevice currentDevice].localizedModel;
    
    XMPPJID *myJID = [XMPPJID jidWithUser:username domain:@"127.0.0.1" resource:model];
    _xmppStream.myJID = myJID;
    
    // 设置服务器域名,不仅是域名还可以是IP地址
    _xmppStream.hostName = @"127.0.0.1";
    
    // 设置端口号,如果端口号是5222，可以省略
    _xmppStream.hostPort = 5222;
    
    
    
    NSError *error = nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        YXLog(@"error:%@",error);
    }
}

#pragma mark - 连接服务器成功后，向服务器发送password进行授权认证
- (void)sendPwdToHost
{
    YXLog(@"向服务器发送password进行授权认证...");
    //    // 从沙盒中获得密码
    //    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    // 从单例中获得密码
    NSError *error = nil;
    NSString *password = nil;
    if (self.registerOperation)
    {
        password = [YXUserInfo sharedYXUserInfo].registerPassword;
        if (![_xmppStream registerWithPassword:password error:&error])
        {
            YXLog(@"注册失败:%@",error);
        }
    } else
    {
        password = [YXUserInfo sharedYXUserInfo].password;
        if (![_xmppStream authenticateWithPassword:password error:&error])
        {
            YXLog(@"密码认证失败:%@",error);
        }
    }
    
    
    
}

#pragma mark - 授权成功后，向服务器发送"在线"消息
- (void)sendOnLineToHost
{
    YXLog(@"向服务器发送‘在线’消息");
    XMPPPresence *online = [XMPPPresence presence];
    [_xmppStream sendElement:online];
}

#pragma mark - XMPPStreamDelegate
#pragma mark - 连接成功后的回调
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    YXLog(@"连接服务器成功");
    // 连接服务器成功后，向服务器发送password进行授权认证
    [self sendPwdToHost];
}

#pragma mark - 连接失败的回调
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    YXLog(@"与主机断开连接");
    YXLog(@"error:%@",error);
    
    if (error && _xmppResultBlock)
    {
        _xmppResultBlock(XMPPResultTypeNetError);
    }
}

#pragma mark - 密码认证成功后的回调
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    YXLog(@"密码认证成功");
    
    // 授权成功后，向服务器发送"在线"消息
    [self sendOnLineToHost];
    
    // 判断block有无值，然后再回调给登录控制器
    if (_xmppResultBlock)
    {
        _xmppResultBlock(XMPPResultTypeSuccess);
    }
    
    
}

#pragma mark - 登录失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    YXLog(@"登录失败");
    YXLog(@"error:%@",error);
    
    // 判断block有无值，然后再回调给登录控制器
    if (_xmppResultBlock)
    {
        _xmppResultBlock(XMPPResultTypeFailure);
    }
    
    
}

#pragma mark - 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    if (_xmppResultBlock)
    {
        _xmppResultBlock(XMPPResultTypeRegisterSuccess);
    }
}

#pragma mark - 注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    YXLog(@"error:%@",error);
    if (_xmppResultBlock)
    {
        _xmppResultBlock(XMPPResultTypeRegisterFailure);
    }
}


#pragma mark - 注销连接
- (void)xmppUserLogout
{
    // 1.发送离线消息
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    
    // 2.断开连接
    [_xmppStream disconnect];
    
    // 3.回到登录界面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.rootViewController = storyboard.instantiateInitialViewController;
}


#pragma mark - 登录
- (void)xmppUserLogin:(XMPPResultBlock)xmppResultBlock
{
    // 1.将block保存起来
    _xmppResultBlock = xmppResultBlock;
    
    // 2.断开之前的连接
    [_xmppStream disconnect];
    
    // 3.连接到服务器
    [self connectToHost];
}

#pragma mark - 注册
- (void)xmppUserRegister:(XMPPResultBlock)xmppResultBlock
{
    // 1.将block保存起来
    _xmppResultBlock = xmppResultBlock;
    
    // 2.断开之前的连接
    [_xmppStream disconnect];
    
    // 3.连接到服务器
    [self connectToHost];
}

- (void)dealloc
{
    // 1.移除代理
    [_xmppStream removeDelegate:self];
    
    // 2.停止模块
    [_reconnect deactivate];
    [_vCard deactivate];
    [_avatar deactivate];
    [_roster deactivate];
    [_message deactivate];
    
    // 3.断开连接
    [_xmppStream disconnect];
    
    // 4.清空资源
    _reconnect = nil;
    _vCard = nil;
    _vCardStorge = nil;
    _avatar = nil;
    _rosterStorge = nil;
    _roster = nil;
    _messageStorage = nil;
    _message = nil;
    _xmppStream = nil;
}




@end
