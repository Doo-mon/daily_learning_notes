# 这个文件用来记录pytorch中的一些信息

***
### cat 和 stack 的区别
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












***
### other

