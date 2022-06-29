# vendor_isoftstone

## 介绍

该仓库托管Isoftstone产品：扬帆开发板和致远开发板的配置参数。

“扬帆”装载瑞芯微RK3399芯片，基于Big.Little架构，其丰富的扩展接口可实现LCD显示、触摸、多媒体、上网等基本特性，可广泛应用于互动广告机、互动数字标牌、智能自助终端、智能零售终端、工控主机、机器人设备等各类场景。

致远是一片尺寸为150mm100mm15mm的开发板，其结构紧凑，功能强大，外形美观，开发板上搭载有庞大的资源外设，配套有DevEco Device Tool开发、调试环境，部分教程以及实验案例，开发者可以根据需求自由开发。

## 目录

```
vendor/isoftstone/    		       		# vendor_isoftstone 仓库路径
├── README.md                       # README文档
└── yangfan                         # 扬帆相关配置
    ├── hals                        # hal层相关配置
    └── hdf_config                  # hdf相关配置
└── zhiyuan                         # 致远相关配置	
    ├── hals                        # hal层相关配置
    └── hdf_config                  # hdf相关配置
```

## 开发环境搭建

扬帆使用参考 [使用教程](https://gitee.com/openharmony-sig/device_board_isoftstone/blob/master/yangfan/README_zh.md)

致远使用参考 [使用教程](https://gitee.com/openharmony-sig/device_board_isoftstone/blob/master/致远/README_zh.md)


## 贡献

[如何参与](https://gitee.com/openharmony/docs/blob/HEAD/zh-cn/contribute/%E5%8F%82%E4%B8%8E%E8%B4%A1%E7%8C%AE.md)

[Commit message规范](https://gitee.com/openharmony/device_qemu/wikis/Commit%20message%E8%A7%84%E8%8C%83?sort_id=4042860)

## 相关仓

* [device_board_isoftstone](https://gitee.com/openharmony-sig/device_board_isoftstone)


