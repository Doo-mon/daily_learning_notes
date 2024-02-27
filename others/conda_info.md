# 这个用来记录conda相关信息

主要是和环境相关

一般来说，安装miniconda和Anaconda均可以，前者更小巧精便

### 查看环境
这个命令会列出所有.condarc文件中 envs_dirs 关键字下指定的文件路径所包含的环境名字
```shell
conda env list

conda info --envs
```

### 删除环境

```shell
conda remove --name your_env_name --all
```


***
### 其他

1. 克隆其他人的conda环境
```shell
 conda create --name your_env_name --clone /path/to/existing/env 
```
2. 使用`conda env export > environment.yml`创建了环境的YAML文件 可以使用这个文件来创建一个相同的环境
```shell
conda env create -f /path/to/environment.yml
```

3. 可以通过手动编辑`.condarc`文件 添加或者修改 `envs_dirs` 部分 

```
envs_dirs:
  - /path/to/other/envs1
  - /path/to/other/envs2
```

4.  `pip_interop_enabled: true` 
  
当这个选项被启用时，Conda 将尝试理解和解析通过 pip 安装的包的依赖关系。这有助于避免版本冲突和依赖问题，特别是在一个环境中混合使用 Conda 和 pip 安装不同包时

5. `channels`
在 `.condarc` 文件中列出的通道按顺序排列，这个顺序决定了通道的优先级。Conda 首先会在列表中靠前的通道中搜索软件包。如果同一个包在多个通道中都可用，Conda 会根据通道的顺序来决定从哪个通道下载。



***
### 在创建虚拟环境的时候没有安装上pip
可能由于.condarc文件被修改了
如果使用的是非官方的 Conda 镜像源，且该源没有包含 pip 或者包含的 pip 版本与你的 Python 版本不兼容，这可能会导致 pip 没有被安装
自己进入虚拟环境重新安装
```shell
conda install pip
```

