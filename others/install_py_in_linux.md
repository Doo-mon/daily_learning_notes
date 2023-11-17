# 如何在linux操作系统中安装python

https://c.biancheng.net/view/4162.html



### 1. 安装依赖包



### 2. 到官网下载包
https://www.python.org/ftp/python/3.8.0/

或者直接使用 wget 命令


### 3. 解压

```shell
tar -zxvf python-3.8.0.tgz
```

### 4. 安装
```shell
cd python-3.8.0
./configure --prefix=/usr/local/python3
make && make install
```

### 5. 建立软连接
```shell
ln -s /usr/local/python3/bin/python3.8 /usr/bin/python3
ln -s /usr/local/python3/bin/pip3.8 /usr/bin/pip3
```

### 6. 测试
```shell
python3
pip3
```


