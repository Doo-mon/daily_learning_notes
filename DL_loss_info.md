# 这个用来记录一下深度学习loss相关



***
### Cross Entropy Loss 交叉熵损失

参考来源：https://blog.csdn.net/ltochange/article/details/117919900

也称做对数损失  当模型产生了预测值之后，将对类别的预测概率与真实值（0或1）进行比较，计算所产生的损失

$$
L_{ce}=-\sum_{i=1}^{n} t_i \log(p_i)
$$

其中 $n$ 是类别的数量， $t_i$ 是对应的真实值， $p_i$ 是预测的概率（一般都要经过softmax+log得到）

$$
CrossEntropyLoss(x,y)=NLLLoss(log Softmax(x),y)
$$

pytorch中通过`torch.nn.CrossEntropyLoss`类实现，也可以直接调用`F.cross_entropy`函数。size_average与reduce已经弃用。reduction有三种取值mean, sum, none。






***
### Focal Loss

参考来源：https://blog.csdn.net/Mike_honor/article/details/125721066?spm=1001.2014.3001.5502

主要是为了解决正负样本数量不平衡  以及 难分、易分样本不均衡的问题
具体公式如下

$$
FL(p_t)=-\alpha_t (1-p_t)^\gamma \log(p_t)
$$

其中 $p_t$ 表示模型预测某个类别的概率（置信度） $\alpha_t$ 用来平衡正负样本数量 样本数量多的赋予更小的值 $\gamma_t$ 是用来调难分易分样本不均衡的，取大于1的数，可以使模型更加关注于难分样本

代码
```python
class FocalLoss(nn.Module):
    def __init__(self,alpha=1,gamma=2,size_average=True,reduction='none'):
        super(FocalLoss,self).__init__()
        self.alpha = alpha
        self.gamma = gamma
        self.reduction = reduction
        # self.ignore_index=ignore_index
        self.size_average = size_average
    
    def forward(self,inputs,targets):
        # F.cross_entropy(x,y)对应的数学公式就是CE(pt)=-1*log(pt)
        ce_loss = F.cross_entropy(inputs,targets,reduction = self.reduction)
        pt = torch.exp(-ce_loss)
        focal_loss = self.alpha * (1 - pt)**self.gamma * ce_loss

        if self.size_average:
            return focal_loss.mean()
        else:
            return focal_loss.sum()
```


***
### Dice Loss

参考来源：https://blog.csdn.net/Mike_honor/article/details/125871091

Dice Loss 是由Dice系数得名 Dice系数是一种用于评估两个样本相似性的度量函数 其值越大意味着这两个样本越相似
Dice系数的数学表达式如下：

$$
Dice=\frac{2 |X \cap Y|}{|X|+|Y|}
$$

其中 $|X \cap Y|$ 表示X和Y之间交集元素的个数 
DiceLoss 表达式如下：

$$
DiceLoss = 1 - Dice
$$

DiceLoss 常用在语义分割问题中，X表示真实分割图像的像素标签，Y表示模型预测分割图像的像素类别 $|X \cap Y|$ 近似为预测图像的像素与真实标签图像的像素之间的点乘，并将点乘结果相加 $|X|$ 和 $|Y|$ 近似为它们对应图像的像素相加

DiceLoss 可以缓解样本中前景背景面积不平衡带来的消极影响 （即图像中大部分区域是不包含目标，只有一小部分区域包含目标） DiceLoss 训练更关注于对前景区域的挖掘，而CELoss 是平等地计算每个像素点的损失 因此常常会将其组合起来使用


代码
```python

def dice_loss(inputs,targets,num_masks,scale=1000,eps=1e-6):
    inputs = inputs.sigmoid()
    inputs = inputs.flatten(1,2)
    targets = targets.flatten(1,2)
    # 计算分子分母
    numerator = 2 * (inputs / scale * targets).sum(-1)
    denominator = (inputs / scale).sum(-1) + (targets / scale).sum(-1)

    loss = 1 - (numerator + eps) / (denominator + eps)
    return loss.sum()/(num_masks+1e-8)
```



***
### other