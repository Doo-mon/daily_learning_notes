# 这个文件用来记录一些坑与一些细节性的东西


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