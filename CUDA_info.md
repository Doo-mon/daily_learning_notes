## CUDA 配置



```shell
# 查询平台内置镜像中的cuda版本
ldconfig -p | grep cuda
        libnvrtc.so.11.0 (libc6,x86-64) => /usr/local/cuda-11.0/targets/x86_64-linux/lib/libnvrtc.so.11.0
        libnvrtc.so (libc6,x86-64) => /usr/local/cuda-11.0/targets/x86_64-linux/lib/libnvrtc.so
        libnvrtc-builtins.so.11.0 (libc6,x86-64) => /usr/local/cuda-11.0/targets/x86_64-linux/lib/libnvrtc-builtins.so.11.0

# 查询平台内置镜像中的cudnn版本
ldconfig -p | grep cudnn
        libcudnn_ops_train.so.8 (libc6,x86-64) => /usr/lib/x86_64-linux-gnu/libcudnn_ops_train.so.8
        libcudnn_ops_train.so (libc6,x86-64) => /usr/lib/x86_64-linux-gnu/libcudnn_ops_train.so
        libcudnn_ops_infer.so.8 (libc6,x86-64) => /usr/lib/x86_64-linux-gnu/libcudnn_ops_infer.so.8
        libcudnn_ops_infer.so (libc6,x86-64) => /usr/lib/x86_64-linux-gnu/libcudnn_ops_infer.so
```
上边的输出日志.so后的数字即为版本号。如果你通过conda安装了cuda那么可以通过以下命令查看
```shell
conda list | grep cudatoolkit
cudatoolkit               10.1.243             h6bb024c_0    defaults

conda list | grep cudnn
cudnn                     7.6.5                cuda10.1_0    defaults
```

### 安装其他版本的CUDA和cuDNN
1. 用conda 安装 优点是简单 缺点是一般不会带头文件 如果需要编译用安装包的方式来安装
```shell
conda install cudatoolkit==xx.xx
conda install cudnn==xx.xx
```

2. 下载安装包安装
CUDA下载地址：https://developer.nvidia.com/cuda-toolkit-archive
```shell
# 下载.run格式的安装包后：
chmod +x xxx.run   # 增加执行权限
./xxx.run          # 运行安装包
```



cuDNN下载地址：https://developer.nvidia.com/cudnn
先解压， 后将动态链接库和头文件放入相应目录
```shell
mv cuda/include/* /usr/local/cuda/include/
chmod +x cuda/lib64/* && mv cuda/lib64/* /usr/local/cuda/lib64/
```
安装完成以后，增加环境变量
```shell
echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64/:${LD_LIBRARY_PATH} \n" >> ~/.bashrc
source ~/.bashrc && ldconfig
```



### 查看GPU信息
可以使用以下命令查看GPU是否安装好
`lspci | grep -i nvidia`
lspci 命令是用来列出pci总线上存在的设备。我们的显卡是通过pci总线与cpu进行通讯的，这条命令用来检查我们的pci总线上是否有nvidia的显卡设备。如过有输出，表示我们的显卡安装成功。如果没有输出，表示显卡可能没有安装好，需要检查一下接口是否安装好。
__可能不会有直接的型号输出，可以[在这个网站进行查询](https://admin.pci-ids.ucw.cz/mods/PC/10de?action=help?help=pci)__

***
### 驱动安装 （暂时忽略）

输入`nvidia-smi`后有输出则说明安装成功

***
### CUDA + cuDNN
<span style="font-size: 17px; color: red;font-weight: bold;">注：安装的CUDA版本务必与pytorch中需要的版本相一致</span> 



#### 1. cuda 卸载 
cuda卸载的程序放在 `/usr/local/cuda-xx.x/bin` 文件夹下面
注意：10.0及之前版本的程序名字为 `uninstall_cuda_xx.x.pl` ，而之后的版本程序名字为 `cuda-uninstaller`
找到之后运行卸载程序即可，这里的 `xx.x` 表示对应的cuda版本

__cuda10.0及以下的卸载__
```shell
cd /usr/local/cuda-xx.x/bin/
sudo ./uninstall_cuda_xx.x.pl
sudo rm -rf /usr/local/cuda-xx.x
```

__cuda10.1及以上的卸载__

```shell
cd /usr/local/cuda-xx.x/bin/
sudo ./cuda-uninstaller
sudo rm -rf /usr/local/cuda-xx.x
```
#### 2. cuda 安装
到 [CUDA官网](https://developer.nvidia.com/cuda-toolkit-archive) 下载对应的CUDA版本
找到你要使用的版本。点击进入你要进行安装的版本，进入系统配置选择界面，选择对应的配置，最后一个Installer Type选择第一个，需要的命令最少
按照对应的安装介绍进行安装：
注意按照自己的系统配置选择合适的版本

__安装__
```shell
chmod +x cuda_10.1.105_418.39_linux.run # 加权限
sudo sh cuda_10.1.105_418.39_linux.run # 执行安装
```
第一个叉掉 不需要重复安装驱动

<span style="color: red;font-weight: bold;">安装完成后配置环境变量：</span> 
记得修改下面的版本号xx.x

```shell
sudo gedit ~/.bashrc   # 打开barshrc文件，添加路径，并将后面两句加在代码末尾

export PATH=/usr/local/cuda-xx.x/bin${PATH:+:$PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-xx.x/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

source ~/.bashrc    # 使上述操作生效
```

__如果测试conda，显示conda找不到指令，同样添加环境变量 把xxxxx路径换成自己的__
```shell
sudo gedit ~/.barshrc # 打开barshrc文件，添加路径，并将后面一句加在代码末尾

export PATH="/home/xxxxxxxx/anaconda3/bin:$PATH"

source ~/.bashrc # 使上述操作生效

conda #测试
```

#### 3. cudnn 安装
暂时略过


***
### 安装完后的测试
```shell
nvidia-smi # 查看nvidia驱动是否正常
nvcc -V # 查看nvcc版本
cat /usr/local/cuda/version.txt #查看cuda 版本，加速并行计算
cat /usr/local/cuda/include/cudnn.h | grep CUDNN_MAJOR -A 2 #查看cudnn 版本,用来加速神经网络
```



***
### CUDA 多版本切换

切换的脚本代码在这里下载 [项目地址](https://github.com/phohenecker/switch-cuda)

直接输入 `source switch-cuda.sh` 会自动输出所有 `/usr/local` 中的CUDA版本

__如果需要切换版本 则输入以下示例代码__
`source switch-cuda.sh 11.2`
