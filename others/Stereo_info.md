# Stereo Images Record 双目图像超分


## 想全是问题，做才有答案 ！

<!-- **现在已经完成的事情:**

:smile: 对于 Flickr1024 以及其他数据集处理的代码已经完成
:smile: 训练和测试已经完成
:smile: 拿到一个新的服务器 6张 2080ti 环境已经配好
:smile: 梁老师那边21073服务器 已经可以进行训练


:book: 尽量早点把数据和环境在各个位置放好，估计很快就要大规模训练
:book: 接下来就是改进模型

:book: 如果要自己租服务器的话 最好是去租一张3090一周大概需要230元
:book: 过几天去问一下学长10924服务器的新密钥

:cry: 20847暂时用不了 过段时间看看情况 但是可以先把数据先传上去 -->



:exclamation: 如果要训练最大的那个模型的话，估计得要用3090来训
然后batch_size可能需要调低一点


把 batch_size 调低 如果iter总数不变的话，会导致训练度不够
理论上 batch_size 减半 对应的 iter 就要翻倍才可以


***


<!--

from ptflops import get_model_complexity_info

    macs, params = get_model_complexity_info(net, inp_shape, verbose=False, print_per_layer_stat=False)

    params = float(params[:-3])
    macs = float(macs[:-4])

    print(macs, params) 
-->



```shell
# pytorch对应版本的安装
conda install pytorch==1.11.0 torchvision==0.12.0 torchaudio==0.11.0 cudatoolkit=11.3 -c pytorch
```

```shell
# 
pip install -r requirements.txt
python setup.py develop --no_cuda_ext 
# develop 开发者模式可以之间反映修改
# --no_cuda_ext 这是传递给setup.py脚本的自定义选项，用于指示安装过程中跳过编译CUDA扩展。
```



在学校的服务器上 添加了一些别名方便直接调用： 修改位置 ~/.bashrc
ac = conda activate zhanzhihao
dc = conda deactivate
cdsr = 切换到工作目录

先在本地修改好 git commit 和 git push 上去
然后在服务器上 git pull 下来再运行


**训练命令**
```shell
CUDA_VISIBLE_DEVICES=3,4 python -m torch.distributed.launch --nproc_per_node=2 --master_port=4321 train.py -opt ./options/train_4x_base_model_T.yml
```

**测试命令**
```shell
CUDA_VISIBLE_DEVICES=3 python -m torch.distributed.launch --nproc_per_node=1 --master_port=4321 test.py -opt ./options/test_4x_base_model_T.yml --launcher pytorch
```

**如果训练中断了 直接重新训就行 不需要在配置文件中写路径 代码里面会自己找**


源代码中有一个计算两张图片之间ssim值的函数 有点问题 进行了一点修改
（初步估计可能是cv2和pillow读取图像之间的差异导致）



***
## 如何在一个新的地方开始训练
:exclamation: 如果是连miniconda都没有的服务器


```shell
echo 'alias ac='conda activate zhanzhihao'' >> ~/.bashrc
echo 'alias dc='conda deactivate'' >> ~/.bashrc
echo 'alias cdsr='cd ~/stereo_sr'' >> ~/.bashrc
source ~/.bashrc
```


```shell
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
~/miniconda3/bin/conda init bash
# 然后需要关闭重启一下
conda # 出现提示则说明安装成功
conda create -n zhanzhihao python=3.8
conda activate zhanzhihao
# 接下来配环境
conda install pytorch==1.11.0 torchvision==0.12.0 torchaudio==0.11.0 cudatoolkit=11.3 -c pytorch # 安装pytorch

cd ~
git clone https://github.com/Doo-mon/stereo_sr.git # clone 仓库
cd ~/stereo_sr
pip install -r requirements.txt # 安装依赖包
python setup.py develop --no_cuda_ext # 将basicsr模块导入

# 执行训练代码可能还会有部分报错 根据实际报错install对应的包就行
```
**然后就是准备训练数据**

```shell
mkdir ~/stereo_sr/datasets
# 放置好数据集的zip文件后
cd ~
bash ~/stereo_sr/scripts/data_preparation/process_Flickr1024.sh
```



***

## 项目中各个文件的作用

| **stereo_sr (暂时的名字)**
| ---- train.py **(启动训练的代码)**
| ---- test.py **(测试的代码)**
| ---- predict.py **(这个应该暂时没有用)**
|
| ---- **basicsr (主要的模型代码文件夹)**
| -------- *data* **(主要是 dataset 和 dataloader 的定义)**
| ------------ \_\_init__.py
| -------- *metrics* **(主要是评价指标的定义)**
| ------------ \_\_init__.py
| -------- *utils* **(主要是小工具的定义)**
| ------------ \_\_init__.py
| -------- *models*
| ------------ \_\_init__.py
| ------------ base_model.py **(模型基类 定义了一些必需的函数)**
| ------------ image_restoration_model.py **(这是训练中主要调用的类，但是这个和上面那个文件有关联 同时具体的网络架构定义用从 archs 导入的 define_network 函数确定)**
| ------------ lr_scheduler.py
| ------------ *archs*
| ---------------- \_\_init__.py
| ---------------- arch_util.py
| ---------------- local_arch.py
| ---------------- Baseline_arch.py
| ---------------- NAFNet_arch.py
| ---------------- NAFSSR_arch.py
| ------------ *losses*
| ---------------- \_\_init__.py
| ---------------- loss_util.py
| ---------------- losses.py
|
| ---- **options (训练和测试的配置文件)**
| -------- temp_test_4x.yml
| -------- temp_train_4x.yml
|
| ---- **scripts (一些数据处理的代码)**
| -------- *data_preparation*
| ------------ process_Flickr1024.sh
| ------------ train_data_process.py
| ------------ val_test_data_process.py
| -------- make_pickle.py
|
| ---- **datasets (不会随着git保存)**
| -------- *Flickr1024* **(原始数据文件 非必要存在 用处理代码处理完后可删)**
| -------- *train_data*
| ------------ *patches_x4*
| ------------ *patches_x2*
| -------- *val_data*
| ------------ *hr*
| ------------ *lr_x2*
| ------------ *lr_x4*
| -------- *test_data*
| ------------ *Flickr1024*
| ---------------- *hr*
| ---------------- *lr_x2*
| ---------------- *lr_x2*





***
## 前期的调研


**多阶段？**
+ CNN + Transformer 的结构 23年挑战赛 psnr 赛道第一的方案



**从intra模块考虑？** 增强图像内部信息的获取
+ 增强



**从inter模块考虑？** 增强双视角图像之间信息的获取
+ 增强
  


**从数据集上面考虑？**（基于transformer的方式可能需求的数据量更大）
* 目前的数据集比较少，但是超分训练相对比较慢 再考虑叠数据集 训练时间可能也会增加很多
+ 数据集能不能使用生成的？ 使用sd生成数据 辅助训练
  那如何有成对的数据？ 必须左右视角都对应，而且还有 LR-HR 对应（这是一个难点）能不能生成高质量的图片
+ 数据增强方式？ 目前比较多的是使用 random flipping、RGBchannel shuffling  还有使用 random horizontal shifting、Mixup、CutMix、 CutMixup等等


**从单一角度进行提高？**
+ 从简单性考虑的话，可以先针对 PSNR 先提高，再考虑其他的
+ 就比如比赛中三个赛道  1.针对PSNR  2.针对感知分数  3.针对真实场景的超分


**从工作统一性上面考虑？**
+ 这个层面相对比较难，暂时不会考虑 但是这些底层视觉的任务有一定的统一性，可以最后探究
+ 能不能和其他工作结合  比如 去雨 去雾 暗光增强 去模糊 去阴影


**从结合新的工作考虑？**
+ 暂无思路


### 超分难点？ 目前方法的不足？
捕获双目图像中互补的信息

高度依赖双目图像的内在属性 比如 视差特征 深度信息 遮挡 occlusion 边界
（可以用深度图重建的效果验证StereoISR的效果？）

双目图像是通过双目系统在不同的方向和角度捕获的，不同视图之间存在差异（曝光） 和不兼容（视差）

不同深度的物体的立体对应可能会有很大的差异
左右视图之间的遮挡阻碍了对应关系的合并

现实场景的退化比双三次场景更加复杂（可能还需要考虑现实场景的退化）
现实场景的退化——blur downsampling noise compression(jpeg 压缩)
感知质量和立体一致性对于立体图像的视觉效果也很重要

**从SC-NAFSSR中看出，貌似 高PSNR和高立体一致性，是有冲突的**

在今年的比赛中，有队伍是使用了sd进行辅助的，可以去参考一下










<!-- ***
## 别人论文中的idea

1. CVGSR: Stereo Image Super-Resolution with Cross-View Guidance
    这篇文章是暂时还没有发表的
    __主要可以学习他的交叉模块__  
    结合了CNN捕获短程依赖关系和Transformer捕获长程依赖关系的能力

    其中还设计了一个纹理损失函数  获取更好的视觉感知 而不是仅仅考虑PSNR指标（估计是创新点不足，另外找的一个点）


    <p align="center">
    <img src=./images/stereo/CVGSR_arch.png width=90%>
    </p>
    首先利用特征提取模块 分别生成 左图像和右图像的特征映射（与之前的方法都比较类似）
    然后使用一个交叉视角交互模块 CVIM 进行不同视角信息的交换
    最后再接上一个重建模块（以及一个用到烂的残差相加）得到最后的高分辨图像




2. 双目超分比赛赛道一的冠军 用的是 transformer + cnn 的方案 两阶段
   __可以学习一下结合使用两种方式的这种思想__ 可以分别利用对方的长处，上面那篇论文也有类似的思想
    <p align="center">
    <img src=./images/stereo/HTCAN_arch.png width=90%>
    </p>


3. 
 -->


<!-- 
***
## Implementation details

### 1. 数据集准备
**训练集：**
Flickr1024 train (800张图)

**验证集：**
Flickr1024 valid (112张图)

**测试集：**
KITTI2012
KITTI2015
Flickr1024 test (112张图)
Middlebury


对图片进行了 切片 分patch 处理 -->
<!-- 
***
### 2. 评价指标



***

### 3.

***
### 4.


***
### 5. -->



<!-- ***
### xx. 对比方法

#### 传统


#### 单图

#### 双目 -->




<!-- 废弃的文本内容 -->


<!-- 双目视频超分？
or
双目视频压缩？

实验表明 用深度学习模型来压缩实在是太慢了 传统方式一下子就解决的事情
做视频压缩这个方向不太现实。 -->


<!-- ***
## 2 

#### 对于S-NeRV中的各个文件夹
注意现在的S-NeRV是基于E-NeRV的代码进行修改的，因为E-NeRV的代码更加系统

现在感觉这个方向有点不太行


+ videodata 用于存放原始的视频数据
+ data 用于存放切分成帧的视频数据 利用video_data_pre.py进行切分
    分成两种，一种是合并的图像，另外一种是切分成左右两个视角帧的图像

+ datasets 用于生成训练所需要的dataset
+ cfgs 用于更改训练和模型的配置文件 -->



<!-- ### 压缩 难点？

需要找到一些对比的方法？
传统的视频压缩方式？


视频信息之所以存在大量可以被压缩的空间，是因为其中本身就存在大量的数据冗余
时间冗余 视频相邻两帧之间内容相似 存在运动关系
空间冗余 某一帧内部的相邻像素存在相似性
编码冗余 视频中不同数据出现的概率不同
视觉冗余 观众的视觉系统对视频中的不同部分的敏感度不同 -->