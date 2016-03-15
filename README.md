# xmppframework
Instant Messaging based on XMPPFramework
Hi,Humans!
Hubot here, I like OC and Swift, I am studying Instant Messaging based on xmppframework.
xmppframework框架的导入:
1.在官网http://xmpp.org/software/libraries.html选择Objective C，进入下载页面https://github.com/robbiehanson/XMPPFramework即可
2.框架的导入
1》导入日志CocoaLumberjack，不需要添加依赖
2》导入CocoaAsyncSocket，不需要添加依赖
3》导入XML解析框架KissXML，需要添加依赖
3.1 General——>Linked Frameworks and Libraries——>添加库libxml2.tbd
3.2 Build Settings ——>Other Linker Flags ——> 添加-lxml2
3.3 Build Settings ——>Header Search Paths ——> 添加/usr/include/libxml2
4》导入libidn

5》将以下4个文件夹导入到项目
Authentication
Categories
Core
Utilities
另外还需要添加libresolv.tbd


