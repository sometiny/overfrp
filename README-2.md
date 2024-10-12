项目地址：[https://github.com/sometiny/overfrp](https://github.com/sometiny/overfrp)
# 用例：使用域名部署穿透服务器以访问内网http/https服务
```
本用例中穿透服务器和内网机器之间的访问全链路加密，具有ssh2相当的安全级别。
 ```
 ```
 ！！！由于内网服务会暴露到公网，请谨慎使用，防止内网资源泄露。！！！
 ```

### 1、启动穿透服务端
```bash
./overfrp-server server --listen "127.0.0.1:7659" --allow-register --suffix "local.locateat.net"

#控制台输出类似如下内容：
#server started at: 127.0.0.1:7659
#HostKey指纹：ecdsa-sha2-nistp256 SHA256 Nu4RNSjbm9M9dJ9rZ4o887OgqYnl974gRVm+rBg3TKM
#HostKey指纹：ssh-rsa SHA256 Sv1nH+y8QYnvNGNRYz7woIexC0/RTjlgUdJYrRhqcIU

```
线上部署时需要指定`--suffix`为自己的域名，并增加一条带'*'的解析到自己的服务。

例如，解析'*.local.locateat.net'到你自己的服务器。

### 2、向服务端注册通道标识，用于发布服务，通道标识可复用，注册一次即可。
```bash
./overfrp-client register --server "127.0.0.1:7659"

#控制台输入类似如下内容：
#通道注册成功，通道标识：EzwVZY2MtEyWmiaQ+3DvRw==
#标识已保存至：F:\xxxxx\.identifier
```
后续会用到通道标识，用于发布服务。

### 3、发布服务，`--identifier`指定前面注册的通道标识
```bash
./overfrp-client publish --server "127.0.0.1:7659" --identifier "EzwVZY2MtEyWmiaQ+3DvRw==" --target "www.baidu.com:443" --ssl-off-loading --keep-http-host

#控制台输出类似如下内容：
#[*]frp server: 127.0.0.1:7659
#[*]frp publishing...
#[*]frp publish success
#[*]已绑定域名：
#http://www-baidu-com-443-2690fb70ef47.local.locateat.net:7659
```

浏览器访问 http://www-baidu-com-443-2690fb70ef47.local.locateat.net:7659 可正常打开baidu页面

* 要用http地址去访问baidu的443端口，所以需要指定--ssl-off-loading来卸载baidu的ssl。

* 浏览器默认发送的host头不是www.baidu.com，需要指定--keep-http-host保持--target中指定的host。


可使用`--use-stored-identifier`自动从通道标识文件读取标识，而不需要每次指定。

访问非https服务时，必须去掉`--ssl-off-loading`，例如映射本地80端口：

```bash
./overfrp-client publish --server "127.0.0.1:7659" --use-stored-identifier --target "127.0.0.1:80"
```

### 4、默认绑定域名为http协议，如果需要绑定https协议的域名，服务端启动时需要指定证书和私钥。

```bash
--certificate "./CERTIFICATE.cer"
--private-key "./CERTIFICATE.key"
```
域名绑定端口默认跟穿透服务器一样，可以使用`--http-listen-at`和`--https-listen-at`，来指定不同的端口。

```bash
--http-listen-at "127.0.0.1:8080"
--https-listen-at "127.0.0.1:4343"
```

#### 例如：如下服务端启动参数
```bash
./overfrp-server server \
    --listen "127.0.0.1:7659" \
    --allow-register \
    --suffix "local.locateat.net" \
    --certificate "./CERTIFICATE.cer" \
    --private-key "./CERTIFICATE.key" \
    --http-listen-at "127.0.0.1:8080" \
    --https-listen-at "127.0.0.1:4343"
```

使用`overfrp-client publish`发布服务时控制台可能输出如下内容：
```
[*]frp server: 127.0.0.1:7659
[*]frp publishing...
[*]frp publish success
[*]已绑定域名：
https://www-baidu-com-443-2690fb70ef47.local.locateat.net:4343
http://www-baidu-com-443-2690fb70ef47.local.locateat.net:8080
```
两个url均可正常访问baidu.com，注意端口已经变成`4343`和`8080`。
