## [UE4内存分析方法][https://zhuanlan.zhihu.com/p/431759166]

【问题起因】 项目要求性能10小时增长不超过100M，所以研究起了内存分析。踩坑无数

## 一、命令行输入指令

### 1、obj list：输出对象列表信息到命令行窗口

| 指令名 | 指令示例 | 指令内容 | | ------------------------- | ---------------------------------------------------- | -------------------------------- | | Class = [ClassName] | *obj list Class = ThirdPersonCharacter_C* | 列出指定类名对象的占用情况 | | Package=[InsidePackage] | *object list Package=/Script/[ProjectName]* | 输出指定报名对象信息 | | Inside=[InsideObject] | *obj list Inside = /Script/NavTest.NavTestCharacter* | 指定对象引用的对象的信息 | | InsideClass=[InsideClass] | *obj list InsideClass = NavTestGameMode* | 指定类引用的对象的信息 | | Name=[ObjectName] | *obj list Name = DocumentationActor* | 指定名的对象信息 | | **-ALPHASORT** | *obj list -alphasort* | **列出所有的对象按字母降序排序** | | **-COUNTSORT** | *obj list -countsort* | **列出所有对象按计数数量降序** | | **Obj GARBAGE / Obj GC** | *obj garbage/obj gc* | **重置GC定时器** | | **Obj TRYGC** | *obj trygc* | **立即GC并重置GC定时器** |

| 指令示例                                | 指令内容                                           | 指令内容                     |
| --------------------------------------- | -------------------------------------------------- | ---------------------------- |
| obj list Class = ThirdPersonCharacter_C | obj list Class = ThirdPersonCharacter_C            | 列出指定类名对象的占用情况   |
|                                         | object list Package=/Script/[ProjectName]          | 输出指定报名对象信息         |
| Inside=[InsideObject]                   | obj list Inside = /Script/NavTest.NavTestCharacter | 指定对象引用的对象的信息     |
| InsideClass=[InsideClass]               | obj list InsideClass = NavTestGameMode             | 指定类引用的对象的信息       |
| Name=[ObjectName]                       | obj list Name = DocumentationActor                 | 指定名的对象信息             |
| -ALPHASORT                              | obj list -alphasort                                | 列出所有的对象按字母降序排序 |
| -COUNTSORT                              | obj list -countsort                                | 列出所有对象按计数数量降序   |
| Obj GARBAGE / Obj GC                    | obj garbage/obj gc                                 | 重置GC定时器                 |
| Obj TRYGC                               | obj trygc                                          | 立即GC并重置GC定时器         |

> 还有更多的指令，参考[https://qiita.com/donbutsu17/items/dd9e00bee27d6868ed3d](https://link.zhihu.com/?target=https%3A//qiita.com/donbutsu17/items/dd9e00bee27d6868ed3d)



![img](https://pic3.zhimg.com/80/v2-4fbc266f7de053521be150f8d2fcd632_720w.webp)



### 各个变量解释

| 变量名 | 变量意义 | | -------------- | ------------------------------------------------------------ | | Class | 类名 | | Count | 对象数量 | | NumKB | 正在使用的对象大小，表示的是序列化的大小。 | | MaxKB | 正在使用的对象最大大小 | | ResExcKB | 表示从任何内存分配的总字节数是ResExcDedSysKB、ResExcShrSysKB、ResExcDedVidKB、ResExcShrVidKB 和ResExcUnkKB的总大小 | | ResExcDedSysKB | 指在专用系统内存中分配的字节数 | | ResExcShrSysKB | 共享系统内存中分配的字节数 | | ResExcDedVid | 专用视频内存（VRAM）中分配的字节数 | | ResExcShrVidKB | 共享视频内存（VRAM）中分配的字节数 | | ResExcUnkKB | 表示在位置内存中分配的字节数 |

| 变量名         | 变量意义                                                     |
| -------------- | ------------------------------------------------------------ |
| Class          | 类名                                                         |
| Count          | 对象数量                                                     |
| NumKB          | 正在使用的对象大小，表示的是序列化的大小                     |
| MaxKB          | 正在使用的对象最大大小                                       |
| ResExcKB       | 表示从任何内存分配的总字节数是ResExcDedSysKB、ResExcShrSysKB、ResExcDedVidKB、ResExcShrVidKB 和ResExcUnkKB的总大小 |
| ResExcDedSysKB | 专用系统内存中分配的字节数                                   |
| ResExcShrSysKB | 共享系统内存中分配的字节数                                   |
| ResExcDedVid   | 专用显存（VRAM）中分配的字节数                               |
| ResExcShrVidKB | 共享显存（VRAM）中分配的字节数                               |
| ResExcUnkKB    | 表示在位置内存中分配的字节数                                 |

### 2、memreport -full：查看内存报告，输出到\Saved\Profiling\MemReports目录下，MEMREPORT文件，用文本工具打开即可



![img](https://pic3.zhimg.com/80/v2-59cf1ebc74d7816bfa61a29241e7eb4e_720w.webp)



### 可以查看当前的内存使用情况

### 参数解释：

| 参数名 | 解释 | | ------------------------- | ------------------------------------------------------ | | *Process Physical Memory* | **进程的物理内存，即占用内存情况** | | *Process Virtual Memory* | **进程的虚拟内存，即运行时磁盘分配的虚拟内存占用情况** | | *Physical Memory* | **系统物理内存使用情况** | | *Virtual Memory* | **系统虚拟内存使用情况** | | *peak* | **峰值** |

| 参数名                  | 解释                                               |
| ----------------------- | -------------------------------------------------- |
| Process Physical Memory | 进程的物理内存，即占用内存情况                     |
| Process Virtual Memory  | 进程的虚拟内存，即运行时磁盘分配的虚拟内存占用情况 |
| Physical Memory         | 系统物理内存使用情况                               |
| Virtual Memory          | 系统虚拟内存使用情况                               |
| peak                    | 峰值                                               |

### 渲染内存使用情况：



![img](https://pic4.zhimg.com/80/v2-d2259bda32423c9506b5f5e12856da3f_720w.webp)



### 关卡加载情况：



![img](https://pic1.zhimg.com/80/v2-88a5aa53b9a43ab81b560d1f2ed58274_720w.webp)



不同颜色代表不同的加载情况：

> 绿色 关卡已加载并可见 红色 关卡已卸载 橙色 关卡正在变成可见的过程中 黄色 关卡已加载，但不可见 蓝色 关卡已卸载，但仍驻留在内存中，当发生垃圾回收时将清除它 紫色 关卡是预加载的

### 生成Actor情况：



![img](https://pic1.zhimg.com/80/v2-b569a848c89bd709267397dcae56153c_720w.webp)



- TimeUnseen：看不见的时间；
- TimeAlive：存在的时间；
- Distance：距离；
- Class：类名；
- Name：显示名称；
- Owner：Owner

### Config文件缓存：



![img](https://pic2.zhimg.com/80/v2-481e72fc84a8562a668866a94afb1711_720w.webp)



### 贴图信息：



![img](https://pic1.zhimg.com/80/v2-6310ae5ceee57a06ac589f786ab90268_720w.webp)



- Cooked/OnDisk: Width x Height (Size in KB, Authored Bias)：在磁盘中烘焙过后的大小
- Current/InMem: Width x Height (Size in KB)：内存中的大小
- Format：格式
- LODGroup：LOD分组类型
- Name：名字
- Streaming：是否是纹理流
- Usage Count：使用的总数

*坑：大场景切换地图的时候会莫名把某些mipmap加载到最大，原因未知；这样就把某些贴图的最大尺寸加载到内存中，使内存增长。但这不能作为一个内存泄漏的bug，把场景走一圈也会把贴图加满。*

### 粒子系统：



![img](https://pic2.zhimg.com/80/v2-da91c61359ca8128ac33a74ef0f92aa5_720w.webp)



### 声音系统：



![img](https://pic3.zhimg.com/80/v2-541d6575ecafd12601ce082061eeaaae_720w.webp)



### 骨骼网格：



![img](https://pic1.zhimg.com/80/v2-bf24f1cee8b4910f4ac3e6d31fc9a514_720w.webp)



### 静态网格：



![img](https://pic4.zhimg.com/80/v2-7af0217f004d93065f5e8d0987e94f2f_720w.webp)



### 关卡：



![img](https://pic3.zhimg.com/80/v2-80c6ab1c389eae8cd92d2b7533bd3c8e_720w.webp)



### 静态网格组件：



![img](https://pic2.zhimg.com/80/v2-52e59d7585b7d8c154ac6ca05bcc5291_720w.webp)



## 二、内存分析方法

### 1、命令行加文本差异软件：

我这里使用的是*Beyond Compare*，能够对比文本的差异



![img](https://pic4.zhimg.com/80/v2-24899c92c7284182e590c9f0b98681bf_720w.webp)



### 分析方法：

1. 运行程序，在两个需要对比内存的时间节点，在命令行（按~开启）输入memreport -full 输出内存分析文本
2. 用文本对比文件查看问题

### 常见问题：

1. object没有卸载
2. UI没有卸载
3. Actor没有卸载
4. 坑：特效的Active和DeActive使其内存一直增长
5. 贴图增长

### 2、UnrealInsights分析工具

### 工具路径：引擎目录\Engine\Binaries\Win64\UnrealInsights.exe

使用方法：

（1）运行UnrealInsights.exe



![img](https://pic4.zhimg.com/80/v2-63949d867306c11f20d028a7bf64968f_720w.webp)





![img](https://pic2.zhimg.com/80/v2-329f16409b560318c52133343ace827d_720w.webp)



（2）在独立窗口运行加上*-trace=memory implies -llm*

（3）以独立窗口模式运行程序



![img](https://pic4.zhimg.com/80/v2-5ace952f2355217d8d7a62f0999e5e8b_720w.webp)





![img](https://pic1.zhimg.com/80/v2-ed58e2ee80cc76a275854fda5fcf5f34_720w.webp)



具体使用方法参考官方文档：[https://docs.unrealengine.com/4.26/zh-CN/TestingAndOptimization/PerformanceAndProfiling/UnrealInsights/Overview/](https://link.zhihu.com/?target=https%3A//docs.unrealengine.com/4.26/zh-CN/TestingAndOptimization/PerformanceAndProfiling/UnrealInsights/Overview/)

## 三、总结一些常见的坑：

1、特效频繁的Activate和Deactivate会一直重复生成，需要勾上Kill on Deactivate



![img](https://pic1.zhimg.com/80/v2-667c1a131a0fa1efdedf4b5df6f2fa10_720w.webp)



2、所有对象在销毁的时候，有引用的变量类型都需要清空。

## Memreport表格化分析工具

https://github.com/muchenhen/UnrealEngineMemreportParser

下载解压后，把Content和Plugins放在对应项目，只依赖==编辑器和已采集的.memreport数据文件==，较好的方式是空项目使用

## 内存优化

DefaultEngine.ini

```ini
[/Script/AndroidRuntimeSettings.AndroidRuntimeSettings]

bBuildWithHiddenSymbolVisibility=True
bEnableAdvancedBinaryCompression=True
```

降低了30MB内存