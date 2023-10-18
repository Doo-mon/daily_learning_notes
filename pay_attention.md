# 这个文件用来记录一些坑与一些细节性的东西


***
**list 中 extend 和 append 的区别**

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
**@property 的作用**
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

**CUDA_VISIBLE_DEVICES=0 是一个环境变量设置**，通常用于控制在使用 NVIDIA 的 CUDA GPU 进行计算时，指定要使用哪个 GPU 设备。这个设置对于多GPU系统或需要特定GPU的应用程序非常有用。

***

**用于递归地删除 save_dir 目录以及目录内的所有内容**
```python
import os
import shutil

if os.path.exists(save_dir):
    shutil.rmtree(save_dir)
```
***