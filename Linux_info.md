# 这个文档用来记录一些 linux 的命令

##### 一、其他
[vim 文本编辑器使用文档](./others/vim_info.md)
[shell 脚本使用文档](./others/shell_info.md)  ----   [shell 教程网址](https://bash.cyberciti.biz/guide/Main_Page)
[conda 使用相关](./others/conda_info.md)

##### 二、常用命令快速跳转
[压缩](#zip-解压缩)
[别名](#设置别名)
[软连接](#设置和删除软链接)


***
### 显示磁盘空间大小
`df -h`

`du -h --max-depth=1`


***
### 信息显示


```shell
# 显示当前登录的用户名
whoami
# 显示当前用户的id以及所属用户组的信息
id
# 显示当前用户环境变量
env
```
注：id 命令一般显示三个信息
UID（用户ID）：这是一个唯一的数字，用来识别系统上的每个用户。例如，uid=1000(username) 表示当前用户的用户名是 username，其唯一的用户ID是 1000。

GID（组ID）：这同样是一个唯一的数字，用来识别用户所属的主要组。例如，gid=1000(usergroup) 表示当前用户属于名为 usergroup 的组，该组的唯一组ID是 1000。

所属组（Groups）：用户还可以属于其他附加组，这些组也会被显示出来。例如，groups=1000(usergroup),27(sudo),... 显示了用户所属的所有组及其组ID。

***
### 周期性执行命令
每10s执行一次命令
`watch -n 10 nvidia-smi`

有一个简单好用的小工具 gpustat  可以简单地对GPU进行观测
使用 `pip install gpustat`即可安装
安装完成后  使用 `watch --color -n1 gpustat -cpu`




***
### ~./bashrc 文件介绍
**可以使用这个文件自定义 bash shell 环境**
通常这个文件中有三种东西：
1. 环境变量
2. 函数
3. 别名


***
### 文件权限

使用`chmod`命令更改文件或目录的访问权限
**权限包括读（r）、写（w）、执行（x）权限，分别对应于用户（u）、组（g）、其他（o）**
只有文件的所有者或超级用户（root）才能更改文件权限

示例：
```shell
# 1. 符号模式
# 将文件 filename 的权限设置为所有者可读写执行（rwx），组可读执行（rx），其他用户只读（r）
chmod u=rwx,g=rx,o=r fliename
# 给文件所有者添加执行权限
chmod u+x filename

# 2. 八进制模式 读（r）= 4，写（w）= 2，执行（x）= 1
#  设置文件权限为所有者可读写执行（7 = 4+2+1），组和其他用户可读执行（5 = 4+1）
chmod 755 filename

# 3. 递归修改
chmod -R 755 directory # 将目录 directory 及其内部所有文件和子目录的权限设置为755
```



***
### 设置别名
```shell
alias ls="ls --color=auto"

# 设置多条命令
# 使用分号 (;): 分号用于顺序执行命令，无论前一个命令是否成功执行。
alias myalias='command1; command2'
# 使用 &&: 只有当第一个命令成功执行（即返回值为 0）时，第二个命令才会执行。
alias myalias='command1 && command2'
# 使用 ||: 如果第一个命令失败（即返回值非 0），则执行第二个命令。
alias myalias='command1 || command2'

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
不要将代码和权重文件放在home下 通常放在data盘下 可以使用在home盘使用软链接
**如果子文件夹里面有软连接，不要直接复制或者剪切**
貌似会把软连接里面的文件一同复制过去   如果软连接的文件很大，会很麻烦

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
### 执行shell脚本
在Linux和类Unix系统中，`source` 命令和 `bash` 命令都用于执行shell脚本，但它们在行为上有重要的区别

#### source 命令
+ 执行环境：source 命令（在某些shell中也称为 . 命令）在当前shell环境中执行指定的脚本文件。这意味着脚本中的所有变量和函数将在当前shell会话中可用。
+ 影响当前环境：使用 source 执行的脚本可以修改当前shell的环境，例如改变目录、设置环境变量等。
+ 没有新的进程：执行脚本时，不会创建新的shell进程。


#### bash 命令
+ 执行环境：使用 bash 命令执行脚本时，会启动一个新的bash子进程，并在这个子进程中执行脚本。
+ 不影响当前环境：脚本在子进程中执行，所以它不会直接修改当前shell的环境。脚本执行完毕后，任何设置或更改（如变量的赋值）都会随着子进程的结束而消失。
+ 创建新的进程：执行脚本会创建一个新的shell进程。

**使用场景：通常当你想要执行一个脚本并保留其设置（如环境变量或定义的函数）时，你会使用 source。而当你只是想运行脚本而不影响当前环境时，你会使用 bash**


***
### bin 文件夹
在Unix和类Unix系统（如Linux和macOS）中，bin 文件夹通常用于存放二进制可执行文件，即程序和命令
bin 目录通常包含可直接执行的程序，而不是源代码或脚本。这些程序是编译过的二进制文件，可由操作系统直接运行。
1. /bin：这是系统的主要二进制文件夹，包含了启动系统和运行必要系统任务所需的重要命令和程序。例如，基本的shell命令如 ls、cp、mv、cat 等通常都存放在这里。这些命令对所有用户都是必需的，即使在单用户（故障修复）模式下也是如此。
2. /usr/bin：这个目录包含了非系统关键的标准程序。这些程序在多用户模式下可用，并且是系统的标准部分。例如，大多数用户级的应用程序和工具都安装在这个目录中。
3. /sbin：sbin 目录存放的是系统管理员级别的工具，用于系统管理和维护。这些命令通常由超级用户（root）使用，例如启动或停止服务的命令（如 reboot、ifconfig）通常位于这里。
4. /usr/local/bin：这个目录用于存放用户自己编译安装的软件或脚本。这样可以将用户安装的软件与系统默认的软件分开，便于管理。
5. 虚拟环境的bin目录：在Python虚拟环境中，bin 目录包含了该环境的Python解释器和相关的工具。例如，当你创建一个Python虚拟环境时，它的 bin 目录会包含独立的Python解释器、pip 工具等


***
### 查看和修改系统变量

查看特定的变量:  VARIABLE_NAME 为需要查看的变量名字
`echo $VARIABLE_NAME`

查看全部变量
`env`
也可以使用以下方法查看特定的变量
`env | grep VARIABLE_NAME`


1. **临时修改** 直接在终端修改系统变量 （登出后就失效）
`export PATH=PATH:/xxxxxx  # 表示在原有PATH上面添加新的PATH 冒号起到分隔作用` 

2. **永久修改** 直接修改文件
修改 ~/.bashrc 或 ~/.bash_profile或系统级别的/etc/profile，在文件中加入环境变量
```shell
vim ~/.bashrc 
export PATH=/opt/ActivePython-2.7/bin:$PATH # 在文件末尾添加
source ~/.bashrc 
```
注：Source命令也称为“点命令”，也就是一个点符号（.）source命令通常用于重新执行刚修改的初始化文件，使之立即生效，而不必注销并重新登录


**注意：**
1. 选择正确的文件：.bashrc 通常用于非登录shell（如打开一个新的终端窗口），而 .bash_profile 或 .profile 用于登录shell（如通过SSH登录）。在某些系统中，这些文件可能会相互调用。
2. 环境变量的命名：环境变量名通常使用大写字母，以区别于普通的shell变量。



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



