#!/bin/bash

# 这个脚本用来下载Google Drive上的文件

# 切换到存放的文件夹 根据需要进行修改
cd /data5/WEIGHT_FOLDER

# 下载文件
filename='stage2_vist.ckpt'
fileid='1rjTsKwF8_pqcNLbdZdurqZLSpKoo2K9F'
wget --load-cookies /tmp/cookies.txt "https://drive.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://drive.google.com/uc?export=download&id=${fileid}' -O- | sed -rn 's/.confirm=([0-9A-Za-z_]+)./\1\n/p')&id=${fileid}" -O ${filename} && rm -rf /tmp/cookies.txt


# Unzip 下面是解压
# unzip -q ${filename}
# rm ${filename}
# cd