# homebrew-pod2lib  created by 李长鸿

由于cocoapod-packager生成framework有时会出错，含有c++文件.mm就会打不出framework的问题，pod2lib就是解决这个问题，
同时也是iOS开发中的pod二进制化方案

使用方式：
cd到项目目中下
命令：pod2lib
1，会从Pods项目中拿到pbxproject文件的所有target即所有pod库名称
2，遍历所有库名称，一个个打包到pod2lib目录下
3，将打包出来的所有.a .h 放项目下，配置路径
4，.a需要配置到项目中

打包速度提升20倍！！！

