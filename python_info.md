# 编写python代码时遇到的值得记录的东西

**模块相关**
[sys 模块](#python-中-sys-模块的使用)
[os 模块](#python-中-os-模块的使用)
[functools 模块](#functools-模块)

**装饰器**
[@dataclass 装饰器](#装饰器-dataclassesdataclass-的作用)
[@property 装饰器](#装饰器-property-的作用)

**类**
[抽象基类abc](#抽象类-metaclassabcabcmeta)

**数据结构**
[list 相关](#list-中-extend-和-append-的区别)




***
### python 中 sys 模块的使用

`sys.argv` 是一个包含命令行参数的列表，其中每个元素是一个字符串。

使用 `sys.argv.remove('--no_cuda_ext')` 会从 sys.argv 列表中移除 --no_cuda_ext，使得后续代码不会看到这个特定的命令行参数。这可以用于动态调整脚本的行为，比如禁用或启用特定的功能，而不需要改变代码逻辑。


***
### python 中 os 模块的使用

os.path.basename() 用来专门取出路径中的文件名（包括后缀）
os.path.splitext() 用来专门分割文件名和后缀名 返回二元组 后缀名包括点




***
### list 中 extend 和 append 的区别

append 方法：
append 方法用于在列表的末尾添加一个元素。
它只接受一个参数，即要添加到列表末尾的元素。
该方法将参数作为一个整体添加到列表中，而不会将参数拆分为多个元素。
```python
my_list = [1, 2, 3]
my_list.append(4)
# my_list 现在为 [1, 2, 3, 4]

my_list.append([5, 6])
# my_list 现在为 [1, 2, 3, 4, [5, 6]]
```
extend 方法：
extend 方法用于将另一个可迭代对象（通常是另一个列表）中的元素逐一添加到当前列表的末尾。
它接受一个可迭代对象作为参数，然后将该可迭代对象中的元素逐一追加到列表中。
这个方法不会创建嵌套的列表，而是将可迭代对象中的元素扁平地添加到当前列表中。

```python
my_list = [1, 2, 3]
my_list.extend([4, 5, 6])
# my_list 现在为 [1, 2, 3, 4, 5, 6]
```

append 用于添加单个元素或包装后的对象到列表的末尾。
extend 用于将另一个可迭代对象中的元素逐一添加到列表的末尾，扩展列表的长度。
选择使用哪个方法取决于你的需求。如果你想将多个元素一次性添加到列表末尾，使用 extend。如果你只想添加一个元素或一个包装后的对象，使用 append。


***
### 装饰器 @dataclasses.dataclass 的作用
是 Python 标准库中的 dataclasses 模块提供的一个装饰器，用于创建简单的类，并自动添加一些通用的特殊方法，以便用于表示数据对象。它的主要作用是简化类的定义，使得创建包含属性的类更加方便，同时自动为类添加一些常见的特殊方法，如 `__init__()、__repr__()、__eq__()` 等。


1. 自动生成特殊方法：使用 @dataclasses.dataclass 装饰器后，Python 会自动为类生成一些特殊方法，如 __init__() 用于初始化对象、__repr__() 用于生成对象的字符串表示、__eq__() 用于比较对象是否相等等。这减少了编写这些通用方法的工作量。

2. 自动化属性声明：你可以在类的属性前面加上类型注释，例如 name: str，age: int 等，@dataclasses.dataclass 会自动为你创建相应的属性，并在 __init__() 方法中进行初始化。

3. 不可变性：通过添加 frozen=True 参数，可以创建不可变的数据类，即一旦对象被创建，就不能再修改其属性值，这有助于确保数据的不可变性。

4. 字段默认值：你可以在属性后面添加默认值，例如 name: str = "Unknown"，这样在创建对象时，如果没有提供属性值，则会使用默认值。


***
### 装饰器 @property 的作用
@property 是Python中的一个装饰器，它用于将一个类的方法转化为属性。这意味着你可以通过像访问属性一样访问方法，而不需要显式调用该方法。@property 的主要用途包括：
1. 封装属性访问：你可以使用 @property 来隐藏类内部属性的具体实现细节，从而提供更严格的封装。这允许你控制对属性的访问方式。
2. 计算属性：你可以在 @property 中执行一些计算，以便在访问属性时返回一个计算值，而不是存储的实际值。这对于属性的值需要经常计算或依赖于其他属性时非常有用。

```python
class Circle:
    def __init__(self, radius):
        self._radius = radius

    @property
    def radius(self):
        print("Getting radius")
        return self._radius

    @radius.setter
    def radius(self, value):
        if value < 0:
            raise ValueError("Radius cannot be negative")
        print("Setting radius")
        self._radius = value

    @property
    def diameter(self):
        print("Calculating diameter")
        return 2 * self.radius

    @diameter.setter
    def diameter(self, value):
        self.radius = value / 2

    @property
    def area(self):
        print("Calculating area")
        return 3.14159 * self.radius ** 2

circle = Circle(5)
print(circle.radius)  # 获取属性，自动调用 radius 方法
circle.radius = 7  # 设置属性，自动调用 radius 方法
print(circle.diameter)  # 获取属性，自动调用 diameter 方法
circle.diameter = 10  # 设置属性，自动调用 diameter 方法
print(circle.area)  # 获取属性，自动调用 area 方法

```

***
### 抽象类 metaclass=abc.ABCMeta

在Python中，使用 metaclass=abc.ABCMeta 在类定义时具有特定的作用。这是涉及到Python的抽象基类（ABCs）的一部分。以下是这个用法的关键点：

1. 定义抽象基类：**抽象基类是一种不能被直接实例化的类，它通常用来定义其他类应该遵循的一组接口和行为**

2. 强制子类实现特定方法：**在这样的抽象基类中，你可以定义抽象方法（使用 @abstractmethod 装饰器）。这些方法必须在任何继承了这个抽象基类的子类中得到实现** 这是确保所有子类都遵循特定接口规范的一种方式。

3. 提供共享功能：虽然你不能直接实例化一个抽象基类，但你可以在其中定义一些可以被子类继承的方法和属性。这些非抽象的方法可以在子类中直接使用，提供了一种代码重用的方式。

4. 促进代码的可维护性和可读性：使用抽象基类可以让代码结构更加清晰，因为它强制你在设计阶段就思考和定义类的基本接口。这对于大型项目和团队协作特别有用，因为它帮助开发者理解应该如何实现和扩展特定的类。

举个例子，如果你定义了一个名为 Animal 的抽象基类，并声明了一个抽象方法 speak()，那么任何继承 Animal 的子类都需要实现自己版本的 speak() 方法。这样就保证了所有的 Animal 类型都具有 speak 这一共性，但各自的实现可以不同（比如猫叫和狗叫就是不同的）。


***
### functools 模块
**functools 模块中的 partial 函数用于创建一个新的函数，它是原始函数的一个部分应用，固定了部分参数的值，使得调用新函数时不再需要提供这些参数。这在函数式编程中很有用，尤其是在需要创建带有特定配置或默认参数的函数时**

```python
from functools import partial

def power(base, exponent):
    return base ** exponent

square = partial(power, exponent=2)
cube = partial(power, exponent=3)

print(square(4))  # 输出 16
print(cube(2))    # 输出 8
```
在这个示例中，我们使用 functools.partial 固定了 power 函数的 exponent 参数，创建了新的函数 square 和 cube，分别代表平方和立方操作。这样，在调用 square 和 cube 时就不需要再传递 exponent 参数了。

partial 还常用于简化回调函数，特别是在使用 map 或 filter 等高阶函数时，可以通过部分应用来减少冗余的参数传递。

***
**一般情况下，导入图像方式：**

1. **使用 cv2 导入图像**
`img = cv2.imread(img_path)`导入的图片是bgr颜色通道  
而其他图像处理库和工具的颜色通道通常是rgb  
所以需要使用`img = cv2.cvtColor(img,cv2.COLOR_BGR2RGB)`进行转换
`cv.imread()` 返回一个NumPy数组，其中包含了图像的像素数据。这允许你直接访问和操作图像的像素值，但需要更多的处理来进行一般的图像处理任务。



2. **使用 PIL.Image 导入图像**
`img = Image.open(img_path)`
使用这个导入的格式是RGB通道
返回一个Pillow的Image对象，该对象可以方便地进行各种图像处理操作，如调整大小、旋转、滤镜应用等
转变为np数组通常需要加上一句`img = np.array(img)`



***
**关于 wheel 文件 和 egg 文件**

Wheel 格式文件是一种Python包分发格式，其文件扩展名为 .whl。这种格式旨在替代早期的 .egg 格式，提供一个标准化的方式来打包Python软件以便于安装。Wheel 是一个二进制包格式，意味着它不仅包含纯Python代码，还可以包含编译过的扩展模块，这使得安装过程通常比从源代码安装要快得多。

Wheel 文件的主要优势包括：

1 安装速度快：由于Wheel包是预编译的，安装时不需要编译Python源代码，从而减少了安装时间。
2 避免系统依赖：对于需要编译的包，Wheel可以包含已编译的扩展，避免了在目标系统上安装编译器和库的依赖。
3 更好的支持：Wheel格式支持创建可以在不同Python版本和不同平台上运行的包，提高了包的兼容性。
4 简化安装过程：安装Wheel包不需要运行setup.py，简化了安装过程。

安装Wheel文件通常使用pip，Python的包管理工具。例如，要安装一个名为example_package-1.0-py2.py3-none-any.whl的Wheel文件，你可以使用以下命令：
```shell
pip install example_package-1.0-py2.py3-none-any.whl
```
此命令告诉pip直接从Wheel文件安装包，而不是从PyPI或其他索引服务器搜索并下载包。这样做可以提高安装速度并降低对外部服务器的依赖



.egg 文件是Python的一种分发包格式，用于打包和分发Python库或应用程序。这种格式由setuptools工具引入，旨在促进Python软件包的发布和分发。.egg 文件本质上是一个ZIP格式的压缩包，其中包含了Python代码、元数据以及资源，可以包括二进制组件。它们设计用来被直接导入到Python的环境中或者作为一个独立的分发包来安装。
安装.egg文件通常需要使用easy_install工具，这是setuptools提供的一个工具。然而，随着pip的普及和增强功能，easy_install的使用已经大大减少。今天，大多数Python开发者都使用pip作为主要的包管理工具，因为它提供了更好的包管理能力和更广泛的包支持。





***

**CUDA_VISIBLE_DEVICES=0 是一个环境变量设置**，通常用于控制在使用 NVIDIA 的 CUDA GPU 进行计算时，指定要使用哪个 GPU 设备。这个设置对于多GPU系统或需要特定GPU的应用程序非常有用。

1. os 模块导入

    ```python
    import os
    os.environ["CUDA_VISIBLE_DEVICES"] = "0"  # 只使用编号为0的GPU
    import torch
    ```
    这段代码通过设置环境变量 CUDA_VISIBLE_DEVICES 来指定哪些GPU是对PyTorch可见的。当你将其设置为 "0" 时，你告诉PyTorch只有编号为0的GPU是可用的。

    **注意：这种方法的一个关键点是它需要在导入PyTorch之前设置。**
    这是因为PyTorch在启动时会读取这个环境变量，并据此决定哪些GPU是可见的。如果你在导入PyTorch之后设置 CUDA_VISIBLE_DEVICES，这个更改将不会影响PyTorch的GPU可见性。


2. torch 直接设置
    ```python
    import torch
    torch.cuda.set_device(0)  # 设置使用编号为0的GPU
    ```

***

**用于递归地删除 save_dir 目录以及目录内的所有内容**
```python
import os
import shutil

if os.path.exists(save_dir):
    shutil.rmtree(save_dir)
```
***