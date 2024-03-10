# 这个文件用来记录pytorch中的一些信息


import torch
print(torch.version.cuda)
print(torch.cuda.is_available())
print(torch.cuda.device_count())
print(torch.cuda.get_device_name(0))







***
### cat 和 stack 的区别
<details>   
<summary>展开查看</summary>
可以用 `x.shape` 和`x.dim`简单的来理解两者的区别

1. cat 用来连接多个张量 
   **dim 可选范围 与原张量维度一致**

    **拼接后的张量在指定的维度上会有增加**———怎么理解这句话？
    （以二维张量为例）指定 dim=0 则最后 的张量 的行数会增加 指定dim=1 则最后张量的列数会增加

    ```python
    x = torch.tensor([[1,2,3]])
    y = torch.tensor([[4,5,6]])

    print(torch.cat((x,y),dim=0))
    print(torch.cat((x,y),dim=1))
    print(torch.cat((x,y),dim=-1))

    """  output:
        tensor([[1, 2, 3],
            [4, 5, 6]])

        tensor([[1, 2, 3, 4, 5, 6]])

        tensor([[1, 2, 3, 4, 5, 6]])

    """
    ```

2. stack 用来叠加  它会在指定的维度上创建一个新的维度
    这意味着stack会在连接的张量之间添加一个新的维度，使得它们变成一个新的子张量。
    通常在需要将多个张量叠加在一起并保持它们的独立性时使用。

    dim = 0  比较好理解 相当于新创了一个维度 然后将两个张量放了进去

    https://zhuanlan.zhihu.com/p/365414757
    `x.shape` 用这个可以比较容易地看出区别 
    

    **dim 可选范围 原张量维度+1**
    ```python
    x = torch.tensor([[1,2,3],[11,22,33]])
    y = torch.tensor([[4,5,6],[44,55,66]])

    print(f"x.shape:{x.shape}")
    print(f"y.shape:{y.shape}")

    print("====================================")
    a =torch.stack((x,y),dim=0)
    print(f"a.shape:{a.shape},a:{a}")
    b = torch.stack((x,y),dim=1)
    print(f"b.shape:{b.shape},b:{b}")
    c = torch.stack((x,y),dim=2)
    print(f"c.shape:{c.shape},c:{c}")
    print(torch.stack((x,y),dim=-1))

    """  output:
        x.shape:torch.Size([2, 3])
        y.shape:torch.Size([2, 3])
        ====================================
        a.shape:torch.Size([2, 2, 3]),a:tensor([[[ 1,  2,  3],
                                                    [11, 22, 33]],

                                                    [[ 4,  5,  6],
                                                    [44, 55, 66]]])
        b.shape:torch.Size([2, 2, 3]),b:tensor([[[ 1,  2,  3],
                                                    [ 4,  5,  6]],

                                                    [[11, 22, 33],
                                                    [44, 55, 66]]])
        c.shape:torch.Size([2, 3, 2]),c:tensor([[[ 1,  4],
                                                    [ 2,  5],
                                                    [ 3,  6]],

                                                    [[11, 44],
                                                    [22, 55],
                                                    [33, 66]]])
        tensor([[[ 1,  4],
                [ 2,  5],
                [ 3,  6]],

                [[11, 44],
                [22, 55],
                [33, 66]]])

    """
    ```

</details>

***
### 模型参数保存
<details>   
<summary>展开查看</summary>
1. PyTorch 格式:
   * PyTorch通常使用.pt或.pth文件保存模型，这些文件可以包含模型的结构（如果保存了整个模型）和状态字典，即模型的参数（权重和偏差）。
   * 使用torch.save()来保存模型的状态字典或整个模型，使用torch.load()来加载。
   * 当保存整个模型时，PyTorch会序列化模型的类定义以及状态字典。

2. Hugging Face Transformers 格式:
   * Hugging Face Transformers 库在保存模型时通常会创建一个目录，而不是单一的文件。在这个目录中，它保存了多个文件，包括模型权重、配置文件和可能的额外文件，如词汇表或特定于任务的额外信息。
   * 模型权重通常保存在一个名为pytorch_model.bin的文件中，配置信息保存在config.json中，词汇表（对于某些模型类型）保存在vocab.json或类似的文件中。
   * Hugging Face 提供了save_pretrained()和from_pretrained()方法来分别保存和加载模型。这些方法处理包含必要信息的文件夹，以确保模型可以正确地被再次加载和使用。

尽管Hugging Face Transformers 库是建立在PyTorch之上的，但它添加了额外的便利性和标准化。例如，from_pretrained()方法允许直接从Hugging Face的模型仓库加载预训练模型，这在原生的PyTorch中不是直接支持的。

总结一下，PyTorch格式通常指的是用于存储模型状态的.pt或.pth文件，而Hugging Face格式则涉及保存和加载包括模型权重、配置和词汇表在内的整个目录结构。
</details>



***
### other

