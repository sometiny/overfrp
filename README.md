# overfrp
## 开始
下载对应操作系统的二进制文件。

以下代码为可正常运行的本地测试。
```bash
# 1、启动服务端
./overfrp-server server --listen "127.0.0.1:7659" --suffix "local.pub.dns-txt.com" --allow-register


# 2、向服务器注册通道标识，用于发布服务，通道标识可复用，注册一次即可。
./overfrp-client register --server "127.0.0.1:7659"

# 3、发布服务，--identifier指定前面注册的通道标识
./overfrp-client publish \
    --server "127.0.0.1:7659" \
    --identifier "register命令返回的通道标识，==结尾" \
    --target "www.baidu.com:443" \
    --ssl-off-loading \
    --keep-http-host

# 命令会输出临时访问地址，浏览器访问后可正常打开baidu页面
# 要用http地址去访问baidu的443端口，需要指定--ssl-off-loading卸载baidu的ssl。
# 浏览器默认发送的host头不是www.baidu.com，需要指定--keep-http-host保持--target中指定的host。

```
实际应用时，应该将`overfrp-server`部署在其他设备可以访问的服务器上，并且使用`--suffix`指定自己的一个域名，域名需要做通配符的解析，使用`CNAME`或者`A`记录指向服务器。

## 启动服务端
```bash
./overfrp-server server \
    --listen [ip:port] \
    --suffix [domainname] \
    --certificate [certificate file] \
    --private-key [private-key file] \
    --authentication-required \
    --allow-register \
    --botnet-persistence
```

### 参数
```--listen [ip:port]``` 指定监听IP(0.0.0.0代表监听所有ip，公网可访问)和端口

```--suffix [domainname]``` 指定自动绑定的域名后缀

```--certificate [certificate file]``` 可选参数，指定域名对应的SSL证书文件保存路径

```--private-key [private-key file]``` 可选参数，指定SSL证书对应的私钥文件保存路径

未提供证书，但用户使用HTTPS访问时，HTTPS请求将直接转发给客户端--target指定的目标，并且客户端不能指定--ssl-off-loading和--keep-http-host参数。同时target需要绑定HTTPS访问域名对应的SSL证书

```--authentication-required``` 要求用户登录

```--allow-register``` 允许用户注册

```--botnet-persistence``` 持久化存储通道


## 客户端
### 注册通道标识
```bash
./overfrp-client register --server [host:port] --authentication [name]
```
#### 参数
```--server [host:port]``` 指定通道使用的服务器

```--authentication [name]``` 如果服务器要求登录，需要提供公钥，公钥可使用命令“./overfrp-client keygen [name]”生成，服务器需要导入公钥

### 发布通道
```bash
./overfrp-client publish \
    --server [host:port] \
    --identifier [identifier] \
    --authentication [name] \
    --target [host:port] \
    --ssl-off-loading \
    --keep-http-host
```
#### 参数
```--server [host:port]``` 指定通道使用的服务器

```--identifier [identifier]``` 指定通道标识

```--authentication [name]``` 如果服务器要求登录，需要提供公钥，公钥可使用命令“./overfrp-client keygen [name]”生成，服务器需要导入公钥
    
```--target [host:port]``` 指定绑定目标，多个目标使用“;”分割。
    
```--ssl-off-loading``` 可选参数，如果指定的目标为HTTPS，需要指定本参数
    
```--keep-http-host``` 可选参数，默认HTTP请求头中的Host时服务器自动分配的域名。

如果--target指定的目标站点需要绑定域名，需要指定本参数，HTTP请求头的Host字段将被修改为--target中的主机



## 服务端管理面板模式
控制面板有更丰富的配置功能，例如鉴权、域名绑定、服务期迁移、通道持久化等。
```bash
# 配置管理面板
./overfrp-server manage --local [ip:port] --user [username:password]
```
### 参数
```--local [ip:port]``` 指定监听IP(0.0.0.0代表监听所有ip，公网可访问)和端口

```--user [username:password]``` 指定登录用户和密码，不指定则允许所有人访问，可进入控制面板重新设置密码

例如：

```bash
# 配置管理面板
./overfrp-server manage --local 127.0.0.1:12568 --user "admin:admin"

# 不添加任何参数，直接运行，启动管理面板。
./overfrp-server
``` 
管理面板启动后，访问 https://127.0.0.1:12568 登录控制面板。

* 注意：必须用https来访问管理面板。
