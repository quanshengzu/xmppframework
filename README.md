# xmppframework
Instant Messaging based on XMPPFramework
Hi,Humans!
Hubot here, I like OC and Swift, I am studying Instant Messaging based on xmppframework.

注意:项目开始前要搭建开发必须的环境
1.安装服务器端的数据库MYSQL和MYSQL workbench(对MYSQL进行图形化界面操作)
2.安装服务器mac版openfire，前提是要先搭建JAVA环境，下载jdk-8u74-macosx-x64可以搭建JAVA环境


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


