# 登录云服务器

# 安装GO语言
sudo apt-get update
sudo apt-get install golang

# 下载ngrok源代码
git clone https://github.com/inconshreveable/ngrok
cd ngrok

# 设置环境变量，ngrok域名
export NGROK_DOMAIN="ngrok.你的域名"

# comment out these two lines from /etc/ssl/openssl.cnf
#RANDFILE = $ENV::HOME/.rnd
#RANDFILE = $dir/private/.rand    # private random number file

# 为域名生成证书
openssl genrsa -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -subj "/CN=$NGROK_DOMAIN" -days 5000 -out rootCA.pem
openssl genrsa -out server.key 2048
openssl req -new -key server.key -subj "/CN=$NGROK_DOMAIN" -out server.csr
openssl x509 -req -in server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out server.crt -days 5000

# 拷贝证书到指定位置
cp rootCA.pem assets/client/tls/ngrokroot.crt
cp server.crt assets/server/tls/snakeoil.crt
cp server.key assets/server/tls/snakeoil.key

# 编译Linux服务端和客户端
GOOS=linux GOARCH=amd64 make release-server
GOOS=linux GOARCH=amd64 make release-client
# 成功编译后，会在bin目录下找到ngrokd和ngrok这两个文件
# 将ngrok客户端拷贝到本地

# 部署服务器端
# 在ngrok程序目录下新建一个启动脚本：ngrok_start.sh
# path=/home/ubuntu/ngrok
# $path/bin/ngrokd -domain="ngrok.你的域名" -httpAddr=":801" -httpsAddr=":802"
nohup sudo ./ngrok_start.sh >/dev/null 2>&1 & 

# 部署客户端
# 添加配置文件ngrok.cfg:
# server_addr: "ngrok.你的域名:4443"
# trust_host_root_certs: false
setsid ./ngrok -config=./ngrok.cfg -subdomain=rstudio 8787

