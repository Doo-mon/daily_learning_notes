# 这个文档用来记录一些 linux 的命令


[vim文本编辑器使用](./others/vim_info.md)
[shell脚本使用](./others/shell_info.md)


***
### 显示磁盘空间大小
`df -h`

`du -h --max-depth=1`


***
### 周期性执行命令
每10s执行一次命令
`watch -n 10 nvidia-smi`

有一个简单好用的小工具 gpustat  可以简单地对GPU进行观测
使用 `pip install gpustat`即可安装
安装完成后  使用 `watch --color -n1 gpustat -cpu`


***
### 设置别名
```shell
alias ls="ls --color=auto"

alias # 列出shell会话中的所有别名

unalias ls # 删除别名
```

***
### 路径相关
```shell
pwd # pwd显示绝对路径

cd # cd切换目录
```

***
### 复制、移动（重命名）、删除、创建
请记住，在Linux中，文件夹以正斜杠 (/)结尾
```shell
# 复制文件
cp file_to_copy.txt new_file.txt
# 使用递归标志复制整个目录
cp -r dir_to_copy/ new_copy_dir/

# 移动文件
mv source_file destination_folder/
# 重命名 同时将其保留在同一目录中
mv old_file.txt new_named_file.txt

# 删除文件
rm file_to_copy.txt
# 删除包含内容的目录 需要使用force（-f）和recursive标志 慎用！！
rm -rf dir_with_content_to_remove/

# 创建文件夹
mkdir images/
# 创建子目录 使用 parent(-p)标记
mkdir -p images/new/
# touch 命令可以用来创建文件 也可以修改文件的时间戳
# 此外还有其他的创建文件的方法
touch new_files.txt
``` 

***
### 设置和删除软链接

```shell
sudo apt install xxx
```

***
### 设置和删除软链接
不要将代码和权重文件放在home下 通常放在data盘下 可以使用在home盘使用软链接

**创建**
1. 创建一个指向文件的软链接
`ln -s /path/to/target/file /path/to/link`
这将在 /path/to 目录中创建一个名为link的软链接，指向 /path/to/target/file

2. 创建一个指向目录的软链接
`ln -s /path/to/target/directory /path/to/link`
这将在 /path/to 目录中创建一个名为link的软链接，指向 /path/to/target/directory

3. 在当前目录中创建软链接
`ln -s /path/to/target/file link`
这将在 当前工作 目录中创建一个名为link的软链接，指向 /path/to/target/file


请注意，软链接可以指向不存在的文件或目录，这在某些情况下可能会导致问题。确保您在创建软链接时指定了正确的目标路径。软链接可以用于创建快捷方式、简化文件路径、将文件组织在不同位置等各种用途。


**删除**
1. 删除一个软链接文件
`rm /path/to/link`
这将删除位于/path/to目录中的名为link的软链接
2. 删除当前目录中的软链接文件
`rm link`
这将删除当前工作目录中的名为link的软链接。

请注意，删除软链接文件只会断开链接，不会影响目标文件或目录。如果您删除了软链接，目标文件或目录仍然存在，不受影响。确保在删除软链接时小心，以免意外删除了重要的数据。




***
### zip 解压缩

**安装**
```shell
sudo apt-get update
sudo apt-get install zip unzip
```
**压缩**
```shell
# 压缩单个文件
zip archive.zip file.txt
# 压缩多个文件
zip archive.zip file1.txt file2.txt ...
# 压缩整个目录 包括子目录
zip -r archive.zip folder/
```
**解压**
```shell
# 解压到当前目录
unzip archive.zip
# 解压到指定目录
unzip archive.zip -d /path/to/directory
# 不解压 仅列出文件内容
unzip -l archive.zip

```
**高级用法**
```shell
# 排除特定文件
zip -r archive.zip folder/ -x folder/exclude.txt
# 分割大型zip文件 每个分卷大小为10mb
zip -r -s 10m archive.zip folder/
```

***
### 联合使用nohup和&让进程后台运行

一般会习惯性写在 .sh 文件中

1. nohup
用途：不挂断地运行命令。
语法：nohup Command [ Arg ...] [&]
无论是否将 nohup 命令的输出重定向到终端，输出都将附加到当前目录的 nohup.out 文件中。
如果当前目录的 nohup.out 文件不可写，输出重定向到 $HOME/nohup.out 文件中。
如果没有文件能创建或打开以用于追加，那么 Command 参数指定的命令不可调用。
2. &
用途：在后台运行

**用法进阶：不输出日志信息到nohup.out**
在某些进程中，由于日志量极大，可能达到几百G占满磁盘空间，所以在输出日志是，我们需要筛选输出或者不输出。
1、只输出错误信息到日志文件
`nohup ./test.out >/dev/null 2>log & `
2、所有信息都不输出
`nohup ./test.out >/dev/null 2>&1 & `


**还有比较多的内容没有完全理解 有空可以继续看一下这个连接的内容**
来源：https://sunkingyang.blog.csdn.net/article/details/113880132?spm=1001.2014.3001.5502




***
### 查看和修改系统变量

查看特定的变量——  VARIABLE_NAME 为需要查看的变量名字
`echo $VARIABLE_NAME`

查看全部变量
`env`
也可以使用以下方法查看特定的变量
`env | grep VARIABLE_NAME`


直接在终端修改系统变量 （登出后就失效）
`export PATH=PATH:/xxxxxx  # 表示在原有PATH上面添加新的PATH 冒号起到分隔作用` 

直接修改文件
修改 ~/.bashrc 或 ~/.bash_profile或系统级别的/etc/profile，在文件中加入环境变量
```shell
vim ~/.bashrc 
export PATH=/opt/ActivePython-2.7/bin:$PATH
source ~/.bashrc 
```
注：Source命令也称为“点命令”，也就是一个点符号（.）source命令通常用于重新执行刚修改的初始化文件，使之立即生效，而不必注销并重新登录


**一些常见的系统变量解释：**
    
    1. PATH: PATH环境变量包含一组目录路径，用于告诉系统在哪里查找可执行文件。当你运行命令时，系统会在这些目录中查找可执行文件。这使你能够在终端中运行任何已安装的命令，而无需提供完整的路径。
    2. HOME: HOME环境变量指定当前用户的主目录的路径。这对于确定用户的默认工作目录以及其他与用户相关的配置文件的位置非常有用。
    3. USER 和 USERNAME: 这些环境变量包含当前登录用户的用户名。
    4. SHELL: SHELL环境变量定义了当前用户的默认shell。当你打开终端会话时，系统会启动这个shell。
    5. PWD: PWD环境变量包含当前工作目录的路径。它可以帮助你确定你当前所在的目录。
    6. LANG 和 LC_*: 这些环境变量用于设置语言和地区设置，以影响系统的本地化行为，例如日期格式、字符编码等。
    7. TERM: TERM环境变量定义了终端类型，它用于告诉系统如何正确地显示文本和执行终端操作。
    8. PS1: PS1环境变量定义了命令提示符的外观和格式。你可以自定义它来更改终端中的命令提示符。



***
### other



