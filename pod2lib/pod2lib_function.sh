#!/bin/bash

#project里面的头文件都移动到public里
function project_header_move_to_public_header()
{
	# if sed -i "" 's/(Project, )/(Project, Public, )/g' $1 #头文件放public里
	# then
		color_green "移动头文件到public成功" #绿色字
	# else
	# 	color_red "移动头文件到public失败" #红色
	# fi
#sed -i "" 's/(Project, Public, )/(Project, )/g' $1  #头文件放project里
}

function read_pods_list()
{
	# 如下情况，只取AFNetworking主名，因为打包一个模块只需要一个.a
	# pod 'AFNetworking/Security', '~> 3.2.1'
	# pod 'AFNetworking/Reachability', '~> 3.2.1'
 	# pod 'CocoaLumberjack', '~> 2.3.0'

	name=`cat ./Pods.xcodeproj/project.pbxproj | awk "/\/\* Pods \*\/ = \{/,/\};/" \
	| awk "/children = \(/,/\)/" | awk "/\/\*/,/\*\//"`
	if [[ -f ./pod2lib_pods.pod ]]; then
		rm -f pod2lib_pods.pod
	fi
	echo "$name" | awk '{print $3}' >> pod2lib_pods.pod 
 
}


#创建头文件、release、debug文件目录，在bash文件夹下
function create_lib_dir()
{
	if [ ! -d "pod_libs" ]; then
	mkdir pod_libs
	mkdir ./pod_libs/Headers
	mkdir ./pod_libs/Release
	mkdir ./pod_libs/Debug
	fi
}

#编译.a文件
#第一个参数是target名
function create_a_file_and_header()
{
set -e

# Setup some constants for use later on.
FRAMEWORK_NAME=$1
Formate=".a"
# 3
# If remnants from a previous build exist, delete them.
build_dir="../build"

if [ -d "$build_dir" ]; then
rm -rf "$build_dir"
fi

# 4
# Build the framework for device and for simulator (using
# all needed architectures).
xcodebuild -target "${FRAMEWORK_NAME}" -configuration Release -arch arm64 -arch armv7 -arch armv7s only_active_arch=no defines_module=yes -sdk "iphoneos"
xcodebuild -target "${FRAMEWORK_NAME}" -configuration Release -arch x86_64 -arch i386 only_active_arch=no defines_module=yes -sdk "iphonesimulator"

# 6
# Copy the device version of framework to Desktop.
prefix=""
if [ $Formate == ".a" ];then
prefix="lib"
fi
Release_iphoneos_file="$build_dir/Release-iphoneos/${FRAMEWORK_NAME}/$prefix${FRAMEWORK_NAME}$Formate"
Release_iphonesimulator_file="$build_dir/Release-iphonesimulator/${FRAMEWORK_NAME}/$prefix${FRAMEWORK_NAME}$Formate"

echo $Release_iphoneos_file
echo $Release_iphonesimulator_file
#copy release
if cp -f $Release_iphoneos_file ./pod_libs/Release
then
echo -e "\033[32m  copy release $Release_iphoneos_file success  \033[0m" #绿色字
else
echo -e "\033[31m copy $Release_iphoneos_file success \033[0m" #红色
fi

#lipo合并指令集到debug
if lipo -create $Release_iphoneos_file $Release_iphonesimulator_file -output ./pod_libs/Debug/$prefix${FRAMEWORK_NAME}$Formate
then
echo -e "\033[32m  lipo 合并fat success for $prefix${FRAMEWORK_NAME}$Formate to debug  \033[0m" #绿色字
else
echo -e "\033[31m lipo 合并fat 失败 for $prefix${FRAMEWORK_NAME}$Formate to debugs \033[0m" #红色
fi

#头文件处理
echo -e "\033[32m ..... 开始做$1头文件.... \033[0m" #绿色字
if [ $Formate == ".a" ];then
header="./pod_libs/Headers"
build_header="$build_dir/Release-iphoneos/${FRAMEWORK_NAME}"
#build_header 里面可能存在.a文件，先移除
if rm -f $build_header/$prefix${FRAMEWORK_NAME}$Formate
then
echo -e "\033[32m 成功移除头文件里的.a文件$build_header/$prefix${FRAMEWORK_NAME}$Formate \033[0m"
fi
#拷贝纯头文件
if cp -r "$build_header" "$header"
then
echo -e "\033[32m ..... $1头文件OK.... \033[0m" #绿色字
else
echo -e "\033[31m $1头文件失败 to headers \033[0m" #红色
fi

else
echo -e "\033[31m $1不是打包成.a，所以失败了。。 \033[0m"
fi



}