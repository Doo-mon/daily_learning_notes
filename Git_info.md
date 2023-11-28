## 这个文档用来记录 git 的使用和一些常见问题

#### 简单介绍：
版本控制系统分为两种 集中式（SVN） 和 分布式（Git）

github 是一个远程存储仓库 使用`git clone`**克隆到本地文件夹进行修改不会影响远程仓库上的代码**，同时也能方便多人协作，每个人负责不同的板块。

[简要流程](#简要概述)
[具体教程](#具体教程)
[远程仓库操作](#远程仓库操作)
[大文件管理](#大文件管理-git-lfs)

[问题](#遇到的问题)

***
## 简要概述
<p align="center">
<img src=./images/git/github_workflow.png width=50%>
</p>

#### 1. 基本的流程
我们通常在工作区进行修改代码等操作，然后通过`git add`的操作添加到暂存区，接着通过`git commit`添加到本地仓库，最后使用`git push`推送到远程仓库。
#### 2. 从远程仓库更新本地文件
使用`git pull`会直接更新工作区所有的文件
我们可以使用`fetch`先拉取到本地仓库，然后通过`diff`对比区别，没问题再合并到本地

#### 3. github相关
在github上使用压缩包下载是不会包括.git文件夹的，所以要使用 git clone 的方法
同时，注意在github上直接创建的仓库，主枝名字叫做main，而本地直接init的是master


***
## 具体教程

<details>   
<summary>展开查看</summary>

参考来源：[b站：一小时Git教程](https://www.bilibili.com/video/BV1HM411377j?p=1&vd_source=520e21608ea654c00af929abd466a687)

### 1. git 的安装 和 初次使用
进入 [git 主页](https://git-scm.com/) 进行下载安装(常见GUI也可以在这里下载)
终端中输入`git -v`命令 如果有版本号的显示 则说明安装成功
可以使用命令行、GUI、IDE插件三种方式使用git

**以下命令只使用一次即可**
`--local`表示本地配置只对本地仓库有效，下面的表示对所有仓库有效 
```shell
git config --global user.name "Doo-mon"
git config --global user.email zhanzhh6@mail2.sysu.edu.cn
```

### 2. 新建仓库 repo
`git init`(直接才本地创建) 和 `git clone`(从远端clone一个到本地)

### 3. 工作区域和文件状态

**工作区：**
工作区(woking directory) 暂存区(staging area/index) 本地仓库(local repository)
**文件状态：**
<p align="center">
<img src=./images/git/github_files_stage.png width=70%>
</p>

### 4. 添加和提交命令
一些常用的命令
```shell
git status
git add .
git commit -m "xxxx"

git commit -am "xxxx" # 将add一起写
```
### 5. git reset 回退版本

soft 表示回退到某一个版本 并且保存工作区和暂存区的修改内容
hard 表示回退到某一个版本 但是不保存工作区和暂存区的修改内容
mixed 表示回退到某一个版本 只保留工作区的修改内容

version-id 通过 `git log --oneline` 获取 
HEAD^ 表示上一个版本
```shell
git reset --soft version-id
git reset --hard HEAD^
git reset HEAD^  # --mixed 默认参数
```

### 6. git diff 查看差异
+ 可以查看工作区、暂存区、本地仓库之间的差异
```shell
git diff
git diff HEAD
git diff --cache
```

+ 可以查看不同版本之间的差异
```shell
git diff version-id1 version-id2
git diff HEAD~ HEAD # 简单实现 比较当前版本和上一个版本之间的差异
git diff HEAD~2 HEAD file.txt # 比较当前版本和上两个版本之间的差异 只比较某个特定文件
```
+ 可以查看不同分支之间的差异
加上两个分支名即可


### 7. git rm 删除文件
+ 直接删除文件 然后使用`git add`更新暂存区的内容
（可以使用`git ls-files`查看暂存区的文件）
+ 直接使用 `git rm` 同时把文件从工作区和暂存区删除

```shell
git rm file.txt
git rm --cached file.txt # 把文件从暂存区删除，但是保留在工作区中
git rm -r * # 递归删除
```

### 8. gitignore 忽略文件
[匹配规则](https://git-scm.com/docs/gitignore)
[github提供了大量的模板]()
不应该被放进仓库的文件：
+ 系统或者软件自动生成的文件
+ 编译生成的中间文件和结果文件 （.class .o）
+ 运行时生成的日志文件、缓存文件、临时文件
+ 涉及身份、密码、口令、密钥等敏感信息文件

.gitignore 生效的前提 **这个文件不能是已经被添加到版本库中的文件**
使用这个对存储库中的文件进行删除 `git rm --cached xxx.log`

 （1）\# 表示注释
 （2）使用标准的Blob模式匹配：
   * \* 通配任意个字符
   * \? 匹配单个字符
   * \[] 匹配列表中的单个字符 如 \[abc] 表示 a/b/c
   * \** 表示匹配任意的中间目录
   * \[0-9] \[a-z]表示字符范围内的都可以匹配
   * \! 取反

### 9. ssh配置和克隆仓库
https这种方式在我们把本地代码push到远程仓库的时候 需要验证用户名和密码
ssh 方式不需要验证用户名和密码 但是需要在github上添加ssh公钥的配置
```shell
cd 
cd .ssh
ssh-keygen -t rsa -b 4096 # 指定协议为rsa 指定生成的大小为4096
```
**创建密钥的时候会有输入密码**
**然后是输入名称**
不输入名称会直接生成 id_rsa  会覆盖掉原有的!!
比如输入 test
会生成 test (私钥文件，不要外传) 和 test.pub
复制 test.pub 文件的内容 在github上面填写

**如果配置了其他的密钥，需要一个config文件指定**
意思是，当我们访问github.com的时候 指定使用ssh下面的test密钥
```shell
tail -5 config
# github
Host github.com
HostName github.com
PreferredAuthentiacations publickey
IdentityFile ~/.ssh/test
```

### 10. 关联本地仓库和远程仓库
添加远程仓库
```shell
# step1  别名一般都是origin
git remote add <远程仓库别名> <远程仓库地址>
# step2 指定分支的名称为main
git branch -M main
# step3
git push -u <远程仓库名> <分支名>
git push -u origin main:main  # 相同分支冒号可省略
git push -u origin main
```
查看远程仓库
```shell
git remote -v
```
拉取远程仓库内容 pull 拉取后会自动合并 fetch 不会合并
```shell
git pull <远程仓库名> <远程分支名>:<本地分支名> # 名字相同可忽略冒号后内容
```

### 11. gitee的使用和GitLab的本地化部署、GUI和IDE使用

gitee的使用和github差不多 这里不进行赘述

**gitlab的私有化部署 —— 在自己的服务器上部署一个gitlab代码托管服务**

GUI 推荐使用 GitKraken 和 SourceTree  （Github desktop 功能比较简单）

vscode 上面可以下载 gitlens 插件

### 12. 分支

**创建分支** 在切换分支的时候 工作区的文件也会发生变化
```shell
git branch # 查看所有的分支
git branch dev # 创建一个dev的分支 但没有切换

# checkout 可以切换分支 和恢复文件 
# 如果分支名和文件名重复的话 会有歧义（默认切换分支而不是恢复文件）
git checkout dev  
git checkout -b dev # -b 参数表示如果没有dev分支的话 会创建一个

git switch dev # 专门用来切换分支的
```

**合并分支** 合并后git会默认进行一次提交
```shell
# merge 后面的分支名称是要被合并的分支
git switch develop
git merge dev

# 在命令行中查看分支图
git log --graph --oneline --decorate --all
```

**删除分支**
-d 表示删除已经完成合并的分支 没有合并的分支不能使用这个参数
-D 表示强制删除分支

```shell
git branch -d dev
```

### 12. 解决合并冲突
+ 没有冲突会自动合并
+ 产生冲突 需要手工修改冲突文件 合并冲突内容 然后添加暂存和提交
+ 可以使用`git merge --abort` 中止此次合并

### 13. 回退和变基
可以在任意分支上执行rebase操作
rebase操作 首先找到两个分支的共同祖先
然后把**当前分支的（最新提交-祖先提交）** 都移动到 **目标分支的最新提交** 后面

```shell
# dev是当前分支 main是目标分支 这会吧当前分支的最新修改移到目标分支后面
git switch dev
git rebase main
# 这个时候main分支还没有指向最新的

```

Merge 
+ 优点——不会破坏原分支的提交历史 方便回溯和查看
+ 缺点——会产生额外的提交节点，分支图比较复杂

Rebase
+ 优点——不会新增额外的提交记录，形成线性历史，比较直观和干净
+ 缺点——会改变提交历史，改变了当前分支branch out的节点 ！避免在共享分支上使用！

### 14. 分支管理和工作流模型

<p align="center">
<img src=./images/git/github_gitflow.png width=90%>
</p>



[gitflow 介绍](https://www.atlassian.com/zh/git/tutorials/comparing-workflows/gitflow-workflow)

此外还有github flow

</details>








***
## 远程仓库操作
一般你 git clone 了别人的项目 想要重新 git push 到自己的仓库里面


查看现有远程仓库配置  这将列出所有已配置的远程仓库及其URL
`git remote -v`

切换远程仓库的地址
`git remote set-url origin <新的仓库URL>`

添加新的远程仓库别名
`git remote add myrepo <新的仓库URL>`
这会将一个名为myrepo的新远程仓库添加到你的配置中，使用指定的URL

移除远程仓库
`git remote remove myrepo`


***
## 大文件管理  git lfs

   **git 适合用来管理文本文件  （.sh .txt  .cpp .go .js 等等**
   **但不适合用来管理二进制文件 (.zip .png .docx .dpf .pptx 等等)**
   
   尤其当这些二进制文件频繁变更的时候  这时不但库大小会增加 下载速度也会变的很慢
   主要原因： 文本文件git使用增量保存  二进制文件只能全量保存 这样每个提交的版本都会多一个副本
   git是分布式版本管理系统  所有的历史记录都会下载到本地（默认情况下）


   **工作流简介：**
   先 install git lfs  然后 clone 项目到本地
   再仓库目录下开启lfs功能 设置需要跟踪的大文件 然后就可以按照正常的git命令操作


   **命令代码：**
   1. 进入到项目目录 然后开启lfs
   `git lfs install`  这条命令会在项目目录中安装几个钩子脚本
   2. 然后设置跟踪的文件
   ```shell
   # 跟踪当前目录下所有的png文件
   git lfs track '*.png'
   # 跟踪所有目录下的png文件
   git lfs track '**/*.png'
   # 跟踪res目录下所有文件和子目录
   git lfs track 'res/**'
   # 跟踪res目录下所有的文件 不含子目录
   git lfs track 'res/*'

   # 跟踪当前目录下已经存在的所有zip文件  执行完这条命令后 新增加的文件不会被跟踪
   git lfs track *.zip

   # 可以查看配置
   cat .gitattributes
   ```

***
## 遇到的问题

1. 在 push 到远端仓库的时候 遇到错误  Recv failure: Connection was reset
   
   参考来源：https://blog.csdn.net/pan_1214_/article/details/132021819

    __解决办法：__
    首先在cmd 中 使用 `ping www.github.com` 得到服务器地址
    然后找到Windows中hosts配置文件 `C:\Windows\System32\drivers\etc` 这个路径下，如果记事本无法打开那么就先将hosts文件复制一份到桌面，然后将其后缀改成txt，在里面加上下面的IP和域名后将后缀名删除，将hosts.txt还原成hosts，在覆盖原来的hosts文件
    加入到hosts文件中：  `20.205.243.166 github.com` 
    __解释：__
    造成这个报错的原因主要是网络连接问题，GitHub的服务器在外国，或者是防火墙代理、DNS解析的问题。
    将"20.205.243.166 github.com"添加到hosts文件中是一种手动指定域名与IP地址的映射关系的方法。这样做的目的是绕过DNS解析过程，直接将github.com这个域名映射到指定的IP地址，即20.205.243.166。这样，当你在浏览器或其他网络应用中访问github.com时，系统将不再向DNS服务器查询域名的IP地址，而是直接使用你在hosts文件中指定的IP地址。  
   <br />
    __上面那个搞完还是会有问题 尝试命令行运行下面这两句__
    ```
    git config --global http.proxy http://127.0.0.1:7890
    git config --global https.proxy http://127.0.0.1:7890
    ```
2. 遇到`git clone` 超时的情况
   或者有这个报错
   gnutls_handshake() failed: The TLS connection was non-properly terminated.
   
   
   来源：https://blog.csdn.net/songtianlun/article/details/115611734 
   
   可能是代理出现了问题 尝试重置一下代理
   ```
   git config --global  --unset https.proxy 
   git config --global  --unset http.proxy 
   ```

   **不要乱设置 按照实际输入 不要直接输入下面这几句话**
   若需使用代理，http协议和socket协议的配置分别如下，以8080端口为例：
   ```
   # http
   git config --global http.https://github.com.proxy http://127.0.0.1:8080
   git config --global https.https://github.com.proxy https://127.0.0.1:8080

   # socket
   git config --global http.proxy 'socks5://127.0.0.1:8080'
   git config --global https.proxy 'socks5://127.0.0.1:8080'
   ```








