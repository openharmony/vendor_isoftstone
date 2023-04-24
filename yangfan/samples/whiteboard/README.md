【OpenHarmony样例】基于RK3399开发板开发的分布式画板

一．概述

本应用是基于RK3399E开发板，使用开源OpenHarmony3.0-LTS开发的应用。通过OpenHarmonyOS的分布式技术，使多人能够一起画画。

1.应用运行效果图：

![输入图片说明](entry/src/main/resources/base/media/%E8%BF%90%E8%A1%8C%E5%9B%BE.PNG)

2.分布式画板使用示意图

![输入图片说明](entry/src/main/resources/base/media/%E5%88%86%E5%B8%83%E5%BC%8F.PNG)

如上图所示，用户1、用户2在各自本地端进行绘制，将当前的图形保存到分布式文件中。远程端当接到分布式数据库发生改变时，获取分布式数据库存储的文件名，然后进行加载图形文件，显示本地端绘制的图形。

3.涉及OpenHarmony技术特性
  eTS UI 分布式流转

4.基础信息

开发平台	系统类型	系统版本

软通“扬帆”富设备开发板	标准系统	3.1Beat

二．快速上手

应用安装包

1.硬件环境准备

  预装windows系统的PC机
   
  扬帆RK3399E开发板

  开发板专用12V电源适配器

  USB公对公数据连接线

  USB外接摄像头

  HDMI显示器

2.开发环境准备

  下载DevEco Studio 3.0 Beta1及以上版本
  
  配置OpenHarmonySDK
  
  创建OpenHarmony工程
  
  配置OpenHarmony应用签名信息
  
  安装运行OpenHarmony应用

3.功能开发

  目录

  资源引用

  定义资源文件

  在src/main/resources/目录下，根据不同的资源类型，定义资源文件。

{ 
  "name":  "brush_width",
  "value":  "画笔宽度"
}

引用资源

  在有对应page的ets文件中，可直接通过$r()引用。

Text($r('app.string.brush_width'))
关键代码

主界面，设备流转：index.ets

图层管理：view/layer.ets

设置：view/setting.ets

画板界面：view/canvas.ets

系统镜像编译及烧录

Linux编译服务器基础环境准备

开发基础环境由windows 工作台和Linux 编译服务器组成。windows 工作台可以通过samba 服务或ssh 方式访问Linux编译服务器。其中windows 工作台用来烧录和代码编辑，Linux编译服务器用来编译OpenHarmony代码，为了简化步骤，Linux编译服务器推荐安装Ubuntu20.04。


1.安装和配置Python

打开Linux终端，输入如下命令，查看python版本号，需要使用python3.7以上版本,否则参考 系统基础环境搭建。
           python3 --version;

安装并升级Python包管理工具。

         sudo apt-get install python3-setuptools python3-pip -y
         sudo pip3 install --upgrade pip
2.安装LLVM

下载LLVM工具。

 解压LLVM安装包至~/llvm路径下。

    tar -zxvf llvm.tar -C ~/

设置环境变量。

       vim ~/.bashrc

       将以下命令拷贝到.bashrc文件的最后一行，保存并退出。

       export PATH=~/llvm/bin:$PATH

使环境变量生效。

        source ~/.bashrc

3.安装hc-gen

打开Linux编译服务器终端。

下载hc-gen工具。点击下载地址下载。

解压hc-gen安装包到Linux服务器~/hc-gen路径下。

tar -xvf hc-gen-0.65-linux.tar –C 

设置环境变量。

vim ~/.bashrc

将以下命令拷贝到.bashrc文件的最后一行，保存并退出。

   export PATH=~/hc-gen:$PATH

使环境变量生效。

       source ~/.bashrc

4.安装编译依赖基础软件（仅Ubuntu 20+需要）

  sudo apt-get install build-essential
  
  sudo apt-get install gcc
  
  sudo apt-get install g++
  
  sudo apt-get install make 
  
  sudo apt-get install zlib
  
  sudo apt-get install libffi-dev

5.源码下载&&编译准备

环境搭完后，就该准备代码了。

下载repo

curl https://gitee.com/oschina/repo/raw/fork_flow/repo-py3 > /usr/local/bin/repo

chmod a+x /usr/local/bin/repo

pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple requests

  下载OpenHarmony源码和编译

1. 代码下载

   			
ssh方式：repo init -u git@gitee.com:openharmony/manifest.git -b master --no-repo-verify
   			
http方式：repo init -u https://gitee.com/openharmony/manifest.git -b master --no-repo-verify
   			
repo sync -c
   			
repo forall -c 'git lfs pull'
   			
bash build/prebuilts_download.sh


2. 编译
   			
./build.sh --product-name rk3399 –ccache


3. 编译结果

编译产生boot.img在目录out/KERNEL_OBJ/kernel/src_tmp/linux-4.19 中。 

编译产生vender.img、system.img 和userdata.img 在目录

out/rk3399/packages/phone/images 中。

4. 烧录

1.系统环境

window7/windows10。

2.驱动安装包

瑞芯微软件助手安装包，需解压安装。


3.烧录工具

瑞芯微开发工具。


4.烧录镜像

debian_update.img。

5.烧录前准备

拿到开发板后，第一次烧录鸿蒙系统前，要先进行整体擦除后，对系统分区，再烧录镜像。

擦除flash

点击升级固件按钮。

            
选择固件。

            
打开并选择烧录镜像。

   			
6.进入烧录模式

  擦除flash前，要先使板子进入烧录模式，方法如下：

  板子上电。

  板子在烧录鸿蒙系统前，如果有其他系统，上电后会显示发现一个ADB设备。


  先长按uboot按钮，再按一次reset按钮后松开，等待板子显示“发现一个LOADER设备”，板子进入烧录模式。


点击擦除flash按钮，开始擦除。

擦除完成后，显示如下：



7.第一次烧录

  第一次烧录鸿蒙系统，要先加载全部镜像。
  
  进入下载镜像页面。
  
  
  在空白处点击右键，选择导入配置，选择ohos.cfg。
  
  
  导入配置表后如下图所示



8.烧录鸿蒙镜像

​        烧录鸿蒙镜像，只需选中boot、vendor、system、userdata，其他分区不选中。


         
         boot、vendor、system和userdata对应的是编译出的img。

