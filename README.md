# IGES文件解析与三维可视化程序设计
## 说明
毕业设计源代码，可以运行main_gui或者main。
## 要求及内容

初始图形交换规范(IGES)是一种设计与制造过程的几何形状描述标准，在CAD建模、CAE仿真、CAM制造过程中均由广泛应用。本课题要求采用MATLAB或其它编程语言对IGES文件进行解析，得到曲线、曲面几何形状信息，并实现其三维可视化。
## 当前进度
#### % B-Rep曲线实体
##### 100 % 圆弧
可读√
可绘√
##### 102 % 复合曲线
可读√
可绘√
##### 104 % 圆锥曲线
可读√
可绘√

##### 106 % 106/11（2D路径）、106/12（3D路径）、106/63（简单封闭平面曲线）
可读√
可绘√

##### 110 % 直线

可读√
可绘√

##### 112 % 参数样条曲线
可读√
可绘√
##### 126 % 有理B样条曲线
可读√
可绘√

##### 130 % 偏置曲线
可读√
可绘×

#### % B-Rep曲面实体

##### 114 % 参数样条曲面

可读√
可绘√

##### 118 % 118/1直纹面

可读√
可绘√

##### 120 % 回转曲面
可读√
可绘√

##### 122 % 列表柱面
可读√
可绘√
##### 128 % 有理B样条曲面
可读√
可绘√

##### 140 % 偏置曲面
可读√
可绘√

##### 190 % 平面内曲面

可读√
转换为128×

##### 192 % 正圆柱曲面

可读√
转换为128×

##### 194 % 正圆锥曲面
可读√
转换为128×

##### 196 % 球面
可读√
转换为128×

##### 198 % 圆环面

可读√
转换为128×

#### % 用于B-Rep实体模型的拓扑实体

> MSBO(186)->Shell(514)->Face(510)->Loop(508)->Line/Edge(504)->Vertex(502)

##### 186 % 流形实体的B-Rep

可读√
可绘√

##### 502 % 顶点

可读√
可绘√

##### 504 % 边

可读√
可绘√

##### 508 % 环

可读√
可绘√

##### 510 % 面

可读√
可绘√

##### 514 % 壳

可读√
可绘√

#### % 计划外实体

##### 314 % 颜色定义（Color Definition）

可读√
可绘√

##### 116 % 点（Point）

可读√
可绘√

##### 124 % 变换矩阵

可读√
可绘√

##### 141 % 边界实体

可读√


##### 142 % 参数曲面上的曲线上实体

可读√


##### 143 % 有界曲面实体

可读√


##### 144 % 裁剪（参数)曲面实体

可读√


##### 406 % 特性实体

可读√
可绘×

