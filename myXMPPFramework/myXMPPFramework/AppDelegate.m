//
//  AppDelegate.m
//  myXMPPFramework
//
//  Created by 颜祥 on 16/3/15.
//  Copyright © 2016年 yanxiang. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"

/*
 用户登录的过程:
 1.初始化xmppStream
 2.连接服务器，向服务器发送myJID
 3.连接服务器成功后，向服务器发送password进行授权认证
 4.授权成功后，向服务器发送"在线"消息
 
 */


@interface AppDelegate ()<XMPPStreamDelegate>

// xmppStream是跟服务器交流的最主要的类
@property (nonatomic, strong)XMPPStream *xmppStream;

// 1.初始化xmppStream
- (void)setupxmppStream;

// 2.连接服务器，向服务器发送myJID
- (void)connectToHost;

// 3.连接服务器成功后，向服务器发送password进行授权认证
- (void)sendPwdToHost;

// 4.授权成功后，向服务器发送"在线"消息
- (void)sendOnLineToHost;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    [self connectToHost];
    
    return YES;
}

#pragma mark -初始化xmppStream
- (void)setupxmppStream
{
    // 创建xmppStream
    _xmppStream = [[XMPPStream alloc] init];
    
    // 指定代理
    // 队列采用全局队列，由系统去分配
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
}

#pragma mark -连接服务器，向服务器发送myJID
- (void)connectToHost
{
    if (_xmppStream == nil)
    {
        [self setupxmppStream];
    }
    
    // 连接服务器前必须要向服务器发送myJID,否则会报错error:Error Domain=XMPPStreamErrorDomain Code=2 "You must set myJID before calling connect." UserInfo={NSLocalizedDescription=You must set myJID before calling connect.}
    /*
     第一个参数：用户名
     第二个参数：服务器的域名
     第三个参数：表示资源名：iphone android
     
     */
    XMPPJID *myJID = [XMPPJID jidWithUser:@"zhangsan" domain:@"127.0.0.1" resource:@"iphone"];
    _xmppStream.myJID = myJID;
    
    NSError *error = nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        NSLog(@"error:%@",error);
    }
}

#pragma mark - 连接服务器成功后，向服务器发送password进行授权认证
- (void)sendPwdToHost
{
    NSString *password = @"123456";
    NSError *error = nil;
    if (![_xmppStream authenticateWithPassword:password error:&error])
    {
        NSLog(@"密码认证失败:%@",error);
    }
}

#pragma mark - 授权成功后，向服务器发送"在线"消息
- (void)sendOnLineToHost
{
    XMPPPresence *online = [XMPPPresence presence];
    [_xmppStream sendElement:online];
}

#pragma mark - XMPPStreamDelegate
#pragma mark - 连接成功后的回调
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"连接服务器成功");
    // 连接服务器成功后，向服务器发送password进行授权认证
    [self sendPwdToHost];
}

#pragma mark - 密码认证成功后的回调
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"密码认证成功");
    
    // 授权成功后，向服务器发送"在线"消息
    [self sendOnLineToHost];
}



@end
