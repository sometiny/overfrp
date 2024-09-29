# overfrp

## 运行服务端
### 1、管理面板模式 - 完整部署
    ./overfrp-server manage

创建管理面板。

    --local [ip:port]
指定监听IP(0.0.0.0代表监听所有ip，公网可访问)和端口

    --user [username:password]
指定登录用户和密码，不指定则允许所有人访问，可进入控制面板重新设置密码

例如：运行 ./overfrp-server manage --local 127.0.0.1:12568 --user "1:1"，访问 https://127.0.0.1:12568 使用用户名1/密码1即可登录控制面板。
注意：必须用https来访问管理面板。

./overfrp-server

启动管理面板。

### 2、命令行模式 - 快速部署
    ./overfrp-server server
直接运行命令，启动服务端。

    --listen [ip:port]
指定监听IP(0.0.0.0代表监听所有ip，公网可访问)和端口

    --suffix [domainname]
指定自动绑定的域名后缀

    --certificate [certificate file]
可选参数，指定域名对应的SSL证书文件保存路径

    --private-key [private-key file]

可选参数，指定SSL证书对应的私钥文件保存路径

未提供证书，但用户使用HTTPS访问时，HTTPS请求将直接转发给客户端--target指定的目标，并且客户端不能指定--ssl-off-loading和--keep-http-host参数。同时target需要绑定HTTPS访问域名对应的SSL证书

    --authentication-required
要求用户登录

    --allow-register
允许用户注册

    --botnet-persistence
持久化存储通道

示例

./overfrp-server server --listen 0.0.0.0:7659 --suffix local.pub.dns-txt.com --certificate ./.assets/penetrate.cer --private-key ./.assets/penetrate.key --allow-register

## 客户端命令
    ./overfrp-client publish

创建通道。

    --server [host:port]
指定通道使用的服务器

    --identifier [identifier]
指定通道标识

    --authentication [name]
如果服务器要求登录，需要提供公钥，公钥可使用命令“./overfrp-client keygen [name]”生成，服务器需要导入公钥
    
    --target [host:port]

指定绑定目标，多个目标使用“;”分割。
    
    --ssl-off-loading

可选参数，如果指定的目标为HTTPS，需要指定本参数
    
    --keep-http-host

可选参数，默认HTTP请求头中的Host时服务器自动分配的域名。

如果--target指定的目标站点需要绑定域名，需要指定本参数，HTTP请求头的Host字段将被修改为--target中的主机
    
示例

./overfrp-client publish --server xxxxxx:7659 --identifier BIP16kkGbU2oZv7KSx6S6w== --target baidu.com:443 --ssl-off-loading --keep-http-host
