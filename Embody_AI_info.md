# Embody AI 具身智能



***
### 相关调研

目前的困难：拥有一个能在不同环境中操纵任意物体的机器人一直都是一个遥不可及的目标
**部分原因是因为 缺乏用于训练这类机器人的各种机器人数据集 同时也缺乏能够生成此类数据集的通用机器人**

#### 1. 多任务机器人模型 RT系列（robot transformer） 和 roboagent

应用于真实世界的机器人模型的训练数据往往需要手动操作来收集 而且不便于跨机器人使用 （相较于CV和NLP领域更为困难）。因此，建立多任务机器人模型为下游任务服务以减轻数据收集工作的压力就尤为重要。
**Q:有个小疑问，如果某些小任务本来就不能完成呢？换句话说，CV和NLP领域都是从小往大发展的，那机器人为什么从上往下发展有希望成功呢？**
以往建立的大型多任务策略如Gato或者instruction following methods等往往专注于训练集内的任务，在新任务上难以泛化或表现较差，难以满足实际需求

transformer的高容量特点能够很好地兼顾多任务的学习目标，但对于机器人，能够实时高效运行也是必不可少的需求，然而传统的transformer无法满足这一需求



#### 2. 其他

**PaLM-E** 假定了存在着一个低层级的 **policy 或者 规划器** 能够将输出的 决定 转化为 低层级的动作  => 这就意味着还不能一步到位

对于不同模态的输入用了不同的编码器进行编码




***
### 相关术语

#### 1. Affordance 可供性
Affordance 强调了物体属性与个体行为之间的关系。例如，一个椅子提供了“坐”的可能性，一个按钮提供了“按”的可能性。**这种可能性并不完全取决于物体的物理属性，还取决于个体的能力和意图**

在机器人学中，理解和利用 affordance 意味着机器人能够识别和理解其周围环境中的物体，并根据这些物体提供的动作可能性来规划和执行任务。例如，一个机器人可能识别到桌子上的杯子是可拿起的（提供了“抓取”的 affordance）

***
### 代码环境（未完善）

如果是直接通过conda create的方式，会有比较多的包需要额外安装
```shell
pip install pillow # PIL
pip install tensorflow_datasets
pip install numpy
pip install gcsfs # install gcsfs to access Google Storage
pip install tensorflow # 如果需要从网络中下载数据集 tf 是必要的

pip install tfds-nightly # 要获取最新的数据集要安装这个包
```







**执行完下面这个后 以后直接用 `xemb` 激活环境 同时切换目录**

```shell
conda create -n xemb python=3.9
# 修改系统变量 
vim ~/.bashrc
# 在最后一行添加下面这个
alias xemb="source activate xemb; cd ~/zhihao/new_storage/open_x_embodiment"
alias cd-xemb="cd ~/zhihao/new_storage/open_x_embodiment"
# 退出后source一下
source ~/.bashrc
```




***
### 参考资料

1. 【VALSE2023】0611《Workshop ：机器人具身智能》
https://www.bilibili.com/video/BV1L8411R7f7/?spm_id_from=333.999.0.0

2. xxx
