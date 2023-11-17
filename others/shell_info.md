# 这个文件用来记录shell的学习使用



***
### 在一个shell脚本中 连续启动多个进程的方法
使用 & 放在命令末尾 让命令在后台运行
```shell
#!/bin/bash

python script1.py &
python script2.py &
python script3.py &

# 等待所有后台进程完成
wait
```
使用子shell:
你可以在括号中创建一个子shell来运行命令，这样也能让每个Python脚本在后台执行
```shell
#!/bin/bash

(python script1.py) &
(python script2.py) &
(python script3.py) &

wait
```
还有其他方法这里就不列举了

***
### 使用 () 表示在一个子shell中执行命令 
在shell脚本中，小括号 ( ) 括起来的命令表示在一个子shell中执行这些命令。子shell是当前shell的一个独立的副本，它拥有自己的环境，变量更改等不会影响到父shell。这在很多情况下都很有用，比如：

1. 变量作用域：
在子shell中声明或更改的变量不会影响到父shell。这可以用来临时更改环境变量，而不影响当前的shell环境。
```shell
(a=10; echo $a)  # 输出 10
echo $a          # 不输出任何内容，因为a变量在父shell中并没有定义
```
2. 并行执行：
在子shell中执行的命令可以通过在命令后面加上 & 放到后台执行，这样可以实现脚本中的并行处理。
```shell
(command1) &
(command2) &
wait # 等待所有的子shell执行完成
```
3. 命令分组：
你可以将一组命令放在一起，以便将它们作为一个整体来管理，例如重定向整组命令的输出。
```shell
(cd /path/to/directory && command)
```
4. 逻辑隔离：
如果你的脚本中有一段逻辑需要在隔离的环境中运行，子shell提供了一个简单的隔离层。

使用子shell是一个强大的特性，它能帮助你编写出更为复杂和可控的shell脚本。但它也可能导致额外的开销，因为每个子shell都是一个新的进程。在资源受限或性能关键的环境中，这一点需要特别注意。

***
### other