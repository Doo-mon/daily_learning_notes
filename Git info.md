## 这个文档用来记录git的使用 和 遇到的一些常见问题

github 是一个远程存储仓库 使用`git clone`克隆到本地文件夹进行修改不会影响远程仓库上的代码，同时也能方便多人协作，每个人负责不同的板块。

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
在github上使用压缩包下载是不会包括.git文件夹的，所有要使用 git clone 的方法
同时，注意在github上直接创建的仓库，主枝名字叫做main，而本地直接init的是master


## 具体操作流程


#### 1. 新建文件夹（工作区），在终端切换到当前目录，进行一些初始化的设置


```shell
git config --global user.name "Doo-mon"
git config --global user.email zhanzhh6@mail2.sysu.edu.cn
# 初始化 输入后会多一个 .git 的文件夹
# 一般默认会显示  master 主分支
git init
```

#### 2. 查看状态
可以查看工作区是否还有文件没有提交到本地仓库的

```shell
git status
```

#### 3. 添加到暂存区和本地仓库

```shell
# 具体添加某个文件到暂存区
git add xxxx.xxx

# 后面的内容是必填的，用来区分每次的提交
git commit -m "xxxxxxx"

# 将add与commit合并一起写
git commit -a -m "xxxxxxx"

```

#### 4. 查看提交日志

使用该命令，可以看到每次提交的作者，日期，提交信息
最前面有一串哈希码 表示一次提交
```shell
git log
```
#### 5. 忽略某些文件上传

```shell
# 创建文件
touch .gitignore
# 在上诉文件中添加图片的名字即可
```

#### 6. 分支操作

假设我们需要为仓库新添文件，但是不确定该文件是否需要，我们就可以在主分支的基础上创建一个新的分支，等新分支整理好后再合并进来

```shell
# 后面是分支名 my-branch
git branch my-branch

# 下面的命令用来查看
git branch

# 切换分支
git checkout my-branch

# 删除分支 （-D 表示非常确定要删除）
git branch -d my-branch

# 创建新分支，并且马上切换到新的分支
git checkout -b temp

```
下面是合并的操作
```shell
# 首先要切换到到主要的分支上
git checkout master

# 下面的命令会将temp分支合并到master分支
git merge temp

```

#### 7. 推送到远程仓库

以下命令可以查看本地仓库和哪些远程仓库有联系
origin 表示远程仓库的名字（默认都会用origin表示远程仓库的名字）
```shell
git remote -v
```

远程推送需要生成个人访问的token







