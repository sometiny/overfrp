# 快速开始
下载对应操作系统的二进制文件，然后运行相应命令。

### 1、启动穿透服务端
```bash
./overfrp-server server --listen "127.0.0.1:7659" --allow-register
```

### 2、向服务器注册通道标识，用于发布服务，通道标识可复用，注册一次即可。
```bash
./overfrp-client register --server "127.0.0.1:7659"
```

### 3、发布服务，--identifier指定前面注册的通道标识
```bash
./overfrp-client publish --server "127.0.0.1:7659" --identifier "register命令返回的通道标识，==结尾"
```

### 4、访问已发布的服务
```bash
./overfrp-client tunnel \
    --listen "127.0.0.1:7660" \
    --server "127.0.0.1:7659" \
    --identifier "已发布的服务通道标识" \
    --target "www.baidu.com:443" \
    --ssl-off-loading \
    --keep-http-host

# 浏览器访问 http://127.0.0.1:7660 可正常打开baidu页面（注意：用http协议，不是https协议）
# *要用http地址去访问baidu的443端口，所以需要指定--ssl-off-loading来卸载baidu的ssl。
# *浏览器默认发送的host头不是www.baidu.com，需要指定--keep-http-host保持--target中指定的host。
```
实际应用时，应该将`overfrp-server`部署在其他设备可以访问的服务器上，在需要被穿透的设备上运行`publish`，将设备暴露到穿透服务端。然后用`tunnel`命令通过穿透服务端去访问远程服务器。

# 命令详细介绍
## 启动服务端
```bash
./overfrp-server server --listen [ip:port] --allow-register
```

##### 参数
```--listen [ip:port]``` 指定监听IP(0.0.0.0代表监听所有ip，公网可访问)和端口

```--allow-register``` 可选参数，允许用户注册


## 客户端相关命令
### 注册通道
```bash
./overfrp-client register --server [host:port] --authentication [name]
```
##### 参数
```--server [host:port]``` 指定通道使用的服务器

```--authentication [name]``` 如果服务器要求登录，需要提供公钥，公钥可使用命令“./overfrp-client keygen [name]”生成，服务器需要导入公钥

### 发布通道
```bash
./overfrp-client publish --server [host:port] --identifier [identifier] --authentication [name]
```
##### 参数
```--server [host:port]``` 指定通道使用的服务器

```--identifier [identifier]``` 指定通道标识

```--authentication [name]``` 可选参数，如果服务器要求登录，需要提供公钥，公钥可使用命令“./overfrp-client keygen [name]”生成，服务器需要导入公钥

### 使用通道
```bash
./overfrp-client tunnel \
    --listen [host:port] \
    --server [host:port] \
    --authentication [name] \
    --identifier [identifier] \
    --target [target]
```
##### 参数
```--listen [host:port]``` 本地监听地址

```--server [host:port]``` 指定通道使用的服务器

```--authentication [name]``` 可选参数，如果服务器要求登录，需要提供公钥，公钥可使用命令“./overfrp-client keygen [name]”生成，服务器需要导入公钥

```--identifier [identifier]``` 指定通道标识
    
```--target [host:port]``` 指定远程目标，对远程目标的请求永远是由`--identifier`关联的发布服务的设备发起。
    
```--ssl-off-loading``` 可选参数，如果指定的目标为HTTPS，需要指定本参数，纯TCP端口转发时，必须忽略本参数。
    
```--keep-http-host``` 可选参数，默认HTTP请求头中的Host是浏览器访问的域名，纯TCP端口转发时，必须忽略本参数。

如果--target指定的目标站点需要绑定域名，则需要指定本参数，HTTP请求头的Host字段将被修改为--target中的主机


## 服务端管理面板模式
控制面板有更丰富的配置功能，例如鉴权、域名绑定、服务期迁移、通道持久化等。
```bash
# 配置管理面板
./overfrp-server manage --local [ip:port] --user [username:password]
```
##### 参数
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
