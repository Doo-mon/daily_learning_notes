# 这个文件用来记录配置vscode时遇到的问题





***
### 调试功能的使用

**继续/暂停 F5** 
**跨过 F10** 一行一行执行命令 不关注内部的函数
**进入 F11** 进入方法内
**步出 shift + F11** 跳出当前的方法
**重新启动 ctrl + shift + F5** 
**终止 shift + F5**


#### 日志点
日志点由“菱形”形状的图标表示。日志消息是纯文本，但可以包含要在大括号 ('{}') 内计算的表达式。


#### launch.json 中的一些常见参数








***
### vscode 的终端无法使用conda命令
来源：https://blog.csdn.net/R_Young/article/details/123162047

注：一般这个情况会出现在windows操作系统中

将 vscode 的默认终端改为 Command Prompt
**注意： 如果有 git bash 的选项 改为这个会更好  这个支持在windows中输入linux的命令**

1. 打开 vscode 的设置
2. 在 搜索栏 搜索 shell:windows
3. 将默认终端从 null 改为 Command Prompt
   
打开新的终端即可

***
### other
