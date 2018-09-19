#!/bin/bash

# 1
# Set bash script to exit immediately if any commands fail.
set -e

. ~/.lichanghong/shell/pod2lib/shell_lib/echo_color.sh
. ~/.lichanghong/shell/pod2lib/pod2lib_function.sh

pbxPath="../Pods/Pods.xcodeproj/project.pbxproj"

#pod install
# cd ..
# pod install 
# cd -

#pod库头文件放public
project_header_move_to_public_header $pbxPath

# 从Manifest.lock读取所有的pod库，注意pod install之后
read_pods_list

#创建头文件、release、debug文件目录，在bash文件夹下
create_lib_dir

#编译
while read line
do
create_a_file_and_header $line
done < pod2lib_pods.pod


