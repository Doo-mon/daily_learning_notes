# Open world Segmentation Record


<span style="color: red;font-weight: bold;">
  注意：11-08更新 已经放弃minigpt4方案和grounded-sam方案
</span>

***
## 笔记
1. __tokenizer 的作用__
   1. 将原始的文本转化为模型的输入形式
   2. 生成特殊的标记 比如<CLS>和<SEP>这些标记在预训练和微调中起着重要的作用。例如，在BERT中，<CLS>用于表示文本的开始，而<SEP>用于分隔不同的文本段落 __在lisa中有一个标记<SEG> 用来标记是否进行分割__
   3. 处理不同的语言
   4. 处理特殊的文本形式 比如URL，邮箱地址，数字，日期等
   5. 控制序列长度: tokenizer通常具有截断（truncation）和填充（padding）文本的功能，以确保输入序列具有一致的长度。这对于批量处理数据和确保模型的输入不超出最大长度限制非常重要

***
## 进展记录

### 11.08及以前进展

1. LISA/model/ 新添加
  * my_LISA.py
    添加 ProjectMLP 类

  * multi_label_contrastive.py 这个只是暂时的文件 

2. LISA/utils/ 新添加
  * diffusion_imgs_dataset.py 新写的数据集
  * my_func.py 里面有两个函数 一个是获取图像路径的 一个是由mask得到框图的函数（这个函数可能还需要进行一些改进，比如屏蔽掉一些比较小的mask）

3. LISA/ 新添加
















***
## Step.0 相关网站
[1]()
[2]()



***
## Step.1 项目地址 及 简单介绍
<!-- [Grounded-sam 项目地址](https://github.com/IDEA-Research/Grounded-Segment-Anything)
[Minigpt4 项目地址](https://github.com/Vision-CAIR/MiniGPT-4)
[Minigpt5 项目地址](https://github.com/eric-ai-lab/MiniGPT-5) -->
[Lisa - github地址](https://github.com/dvlab-research/LISA)
论文名： LISA: Reasoning Segmentation via Large Language Model

LISA主要目标是 **推理分割** 其主要的细分功能有如下四个：
1. 复杂推理
2. 世界知识
3. 解释性回答
4. 多轮对话
 
当仅在无推理数据集上进行训练时，LISA还表现出了强大的零样本能力。此外，仅使用 239 个推理分割图像指令对对模型进行微调，可以进一步提高性能

***
## Step.2 环境的配置

```shell
pip install -r requirements.txt
pip install flash-attn --no-build-isolation
```


***
## Step.3 训练

### 1. 原始训练的数据集
  1. 语义分割数据集：ADE20K、COCO-Stuff、Mapillary、PACO-LVIS、PSACAL-Part、COCO Images
  2. 参考分割数据集：refCOCO、refCOCO+、refCOCOg、refCLEF
  3. 视觉问答数据集：LLaVA-Instruct-150k
  4. 推理分割数据集：ReasonSeg

在对应的网站上下载后，需要按照github上面的文件夹放置方式放置

### 2. 预训练权重
  1. LLaVA
    使用合并后的权重 `LLaVA-Lightning-7B-v1-1` 或者 `LLaVA-13B-v1-1` 
    （从 `liuhaotian/LLaVA-Lightning-7B-delta-v1-1` 或者 `liuhaotian/LLaVA-13b-delta-v1-1`合并得到）
    **对于 Llama2, 可以直接使用 LLaVA 的全权重  `liuhaotian/llava-llama-2-13b-chat-lightning-preview`**.
    <span style="color: red;font-weight: bold;">注意：以上直接在 huggingface 上搜索就能找到</span>
    
  2. SAM ViT-H 
    在github上有链接可以直接下载

### 3. 训练

原训练是直接执行
```shell
deepspeed --master_port=24999 train_ds.py \
  --version="PATH_TO_LLaVA" \
  --dataset_dir='./dataset' \
  --vision_pretrained="PATH_TO_SAM" \
  --dataset="sem_seg||refer_seg||vqa||reason_seg" \
  --sample_rates="9,3,3,1" \
  --exp_name="lisa-7b"
```
训练结束之后 通过以下命令获得全模型权重 保存为 pytorch_model.bin

```shell
cd ./runs/lisa-7b/ckpt_model && python zero_to_fp32.py . ../pytorch_model.bin
```

<span style="color: red;font-weight: bold;">注意：以下为新的训练</span>
**新改写的 my_train_script.py 训练文件**
利用deepspeed进行单机多卡操作 include localhost: 指定使用的GPU
dataset 是指定用sd生成的数据
diffusion_imgs_data 是指定文件夹的名字
vision_pretrained 是SAM的路径

```shell
deepspeed --include localhost:0,1,2,3 --master_port 23333 my_train_script.py \
 --exp_name="lisa-sd" \
 --version="/home/xuhang/zhanzhihao/new_data_storage/LISA-13B-llama2-v1" \
 --vision_pretrained="/home/xuhang/zhanzhihao/new_data_storage/sam_vit_h_4b8939.pth" \
 --dataset_dir="./dataset" \
 --dataset="diffusion_imgs" \
 --diffusion_imgs_data="imgs_from_stablediffusion"
```



### 4. 合并 LoRA 权重
合并LoRA权重，以huggingface的格式 保存模型
**注意这个 --weight 参数  这个是自己训练出来的**

```shell
CUDA_VISIBLE_DEVICES="" python3 merge_lora_weights_and_save_hf_model.py \
--version="./LLaVA/LLaVA-Lightning-7B-v1-1" \
--weight="lisa-7b/pytorch_model.bin" \
--save_path="./LISA-7B"
```


### 5.验证
```shell
deepspeed --master_port=24999 train_ds.py \
  --version="PATH_TO_LISA_HF_Model_Directory" \
  --dataset_dir='./dataset' \
  --vision_pretrained="PATH_TO_SAM" \
  --exp_name="lisa-7b" \
  --eval_only
```

## Step.4 新：生成图片
通过 `generate_images.py` 进行生成 需要提前下载好 sd-1-5 的权重
需要提前指定生成的物体类别
生成的图片以如下的形式进行存放
```
----imgs_from_stablediffusions
    ---- 可操纵部件名1
        ---- 物体类别1
        ---- 物体类别2
    ---- 可操纵部件名2
        ---- 物体类别3
        ---- 物体类别4
    ......
```
`control_img_3d.py` 文件需要 diffusers 库



<!-- ***
## Step.2 然后分别进行环境的配置和模型参数的下载

### 1. Grounded-Segment-Anything

__下面进行安装是不用docker的，以后可能还得看一下docker的使用__
需要按照上面的指示设置好环境变量  可以使用`echo $CUDA_HOME`命令来查看环境变量是否已经存在

```shell
export AM_I_DOCKER=False
export BUILD_WITH_CUDA=True

# 一般cuda放的位置都在 /usr/local/  里面
export CUDA_HOME=/path/to/cuda-11.3/
```



然后进行相关包的安装
注：-e表示安装包的可编辑模式，在修改包的源代码后，无需重新安装包即可反应更改

```shell
cd ./Grounded-Segment-Anything
python -m pip install -e segment_anything
python -m pip install -e GroundingDINO
```

为了使用 groundedsam 我们需要下载预训练的模型 
确保在Grounded-Segment-Anything目录下执行下面代码

```shell
wget https://dl.fbaipublicfiles.com/segment_anything/sam_vit_h_4b8939.pth
wget https://github.com/IDEA-Research/GroundingDINO/releases/download/v0.1.0-alpha/groundingdino_swint_ogc.pth
```
<font color=red>项目中有使用SAM-HQ的，但是这里暂时没有考虑使用，具体用法参见项目说明文档</font>


__这里具体有两个版本的demo代码：__
* <font color=blue>grounded_sam_demo.py</font> 这个通过命令行进行参数的输入
* <font color=blue>grounded_sam_simple_demo.py</font> 这个具体的参数定义在代码里面需要自己进行修改

__可以直接在当前目录下面使用`python grounded_sam_simple_demo.py`进行简单的测试__

下面是使用 __第一个代码__ 进行推理的示例输入样式  __一般不建议使用__
```shell
export CUDA_VISIBLE_DEVICES=0
python grounded_sam_demo.py \
  --config GroundingDINO/groundingdino/config/GroundingDINO_SwinT_OGC.py \
  --grounded_checkpoint groundingdino_swint_ogc.pth \
  --sam_checkpoint sam_vit_h_4b8939.pth \
  --input_image assets/demo1.jpg \
  --output_dir "outputs" \
  --box_threshold 0.3 \
  --text_threshold 0.25 \
  --text_prompt "bear" \
  --device "cuda"
```

### 2. MiniGPT4

这个项目比较特殊，使用的是 environment.yml 进行环境的创建 这个文件存储的是类似字典格式

目前有两个方法解决：
1. 不断运行根据报错直接pip install 安装
2. 另外一个就是重新写 requirements.txt 文件保存 然后再安装

不过有一点需要注意的是，这里不需要对minigpt4进行pip安装，此外，原来的demo会使用gradio包进行网页可视化的操作（目前可以暂时不考虑使用这个）


#### 下面是要准备minigpt4的权重
   1. __新的__
     <span style="font-size: 17px; color: red;font-weight: bold;">对于llm的权重</span> 
     minigpt4这边提供了三个版本 其中 __llama 2 chat 7b__ 的权重需要提交申请才能下载
     目前服务器里面只有 __llama 2 chat 13b__ 的模型
     __可以考虑先下载 Vicuna v0 两个参数版本的进行实验__ 
     llama 权重路径在`/minigpt4/configs/models/`里面 
     寻找到对应yaml文件里面的 `llama_model: "/path/to/llama2/weight"`进行修改
     <span style="font-size: 17px; color: red;font-weight: bold;">对于minigpt4的权重(微调对齐)</span>
     在github上面下载好，
     然后在 `eval_configs/minigpt4_eval.yaml `里面对应的`model:ckpt: '/path/to/checkpoint/'`进行修改



   2. __旧的（暂时不需要看）__   -->
    
<!-- 
      在minigpt4项目中有一个PrepareVicuna.md文件介绍 这里将其在重复描述一下
      首先要到huggingface上下载delta权重 https://huggingface.co/lmsys/vicuna-13b-delta-v0

      然后需要申请原始权重 并转换成huggingface格式 https://huggingface.co/docs/transformers/main/model_doc/llama

      然后根据 PrepareVicuna.md 里面的指示将delta权重和原始权重合并成最终的权重

      __Vicuna 权重路径__

      在minigpt4/configs/models/minigpt4.yaml 中第16行 修改 llama_model

      __下载对应的 minigpt4 的 ckpt 并修改路径__

      在 eval_configs/minigpt4_eval.yaml 中进行修改 
-->



<!-- ### 3. LISA

lisa的准备比较简单，直接使用原来的环境就行了，主要是权重需要提前下载好
运行的时候报什么错就 pip 安装就行





***
## Step.3 修改
可以删除 Grounded-Segment-Anything 里面一些多余的文件夹
（一般都是其他的一些拓展工作，这里不需要使用）

注：minigpt4有新的版本修改
#### 0. 将 minigpt4 文件夹 和 prompts 还有 eval_configs 文件夹复制到Grounded那边

#### 1. 修改 grounded_sam_simple_demo.py 和 minigpt4 中的 minigpt4_demo.py 并在写在 my_sam_gpt.py 内

目前初步工作已经完成，具体需要得到llm模型的权重才能debug 
需要看一下llm模型能否正常创建，以及能否正常地输出待分割物体的类别




***
## Step.4 目前需要注意的问题

**由于minigpt4和grounded-sam中使用的包不太相同，而我们选择用ground-sam作为基础环境，额外需要安装minigpt4需要的包**

以下的包需要额外进行 pip install 
omegaconf
pandas 
iopath
webdataset
decord
peft （这个刚开始安装的时候略微有点问题，后面好像就可以了，貌似需要安装的东西挺多）这个貌似是minigpt4用来微调模型参数的，是最近才添加上去的

gradio（去掉）这个安装起来特别地慢 最好不要安装 在最后考虑要进行网页可视化的时候在弄


***
## Step.5 坑

.... -->