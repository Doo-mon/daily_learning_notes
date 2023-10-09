# Linux 服务器中直接下载谷歌云盘上的文件

来源：https://lccurious.github.io/2021/05/15/Download-from-Google-Drive/

通过`wget`或者`curl`从Google Drive 上下载文件

### 分享链接
通常 Google Drive 的分享连接格式如下
```
https://drive.google.com/file/d/<fileid>/view
``` 
重点是获取文件的id
文件名可以自己取

给出下面的例子：
```
filename='OfficeHomeDataset_10072016.zip'
fileid='0B81rNlvomiwed0V1YUxQdC1uOTg'
```

### weget 下载指令

1. 针对小文件
```
wget --no-check-certificate "https://drive.google.com/uc?export=download&id=${fileid}" -O ${filename}
```

2. 如果文件大的话 需要对cookie进行处理
```
wget --load-cookies /tmp/cookies.txt "https://drive.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://drive.google.com/uc?export=download&id=${fileid}' -O- | sed -rn 's/.confirm=([0-9A-Za-z_]+)./\1\n/p')&id=${fileid}" -O ${filename} && rm -rf /tmp/cookies.txt
```

可以改成shell脚本 示例如下:
```shell
#!/bin/bash

# cd scratch place
cd data/

# Download zip dataset from Google Drive
filename='OfficeHomeDataset_10072016.zip'
fileid='0B81rNlvomiwed0V1YUxQdC1uOTg'
wget --load-cookies /tmp/cookies.txt "https://drive.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://drive.google.com/uc?export=download&id=${fileid}' -O- | sed -rn 's/.confirm=([0-9A-Za-z_]+)./\1\n/p')&id=${fileid}" -O ${filename} && rm -rf /tmp/cookies.txt

# Unzip 解压这个得看情况
unzip -q ${filename}
rm ${filename}
cd
```


### curl 下载指令
1. 小于40mb的文件
```
curl -L -o ${filename} "https://drive.google.com/uc?export=download&id=${fileid}"
```
2. 大文件

```
curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${fileid}" > /dev/null
curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=`awk '/download/ {print $NF}' ./cookie`&id=${fileid}" -o ${filename}
rm ./cookie
```
3. 脚本
```shell
#!/bin/bash
  
# cd scratch place
cd scratch/
  
# Download zip dataset from Google Drive
filename='OfficeHomeDataset_10072016.zip'
fileid='0B81rNlvomiwed0V1YUxQdC1uOTg'
curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${fileid}" > /dev/null
curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=`awk '/download/ {print $NF}' ./cookie`&id=${fileid}" -o ${filename}
rm ./cookie
  
# Unzip
unzip -q ${filename}
rm ${filename}
  
# cd out
cd
```










