
#本地文件读取pods列表
function get_local_pods_list()
{
create_lib_dir
if [ ! -f podslist.txt ]; then
echo -e "\033[32m 没发现已存在pod列表，从pbxproject文件获取: \033[0m"
get_all_pods_list
else
echo -e "\033[32m pods列表为: \033[0m"
while read line
do
echo -e "\033[32m  $line \033[0m"
done < podslist.txt
fi
}
#创建头文件、release、debug文件目录，在pod2lib文件夹下
function create_lib_dir()
{
if [ ! -d "pod_libs" ]; then
mkdir pod_libs
mkdir ./pod_libs/Headers
mkdir ./pod_libs/Release
mkdir ./pod_libs/Debug
fi
}

#project里面的头文件都移动到public里
function project_header_move_to_public_header()
{
if sed -i "" 's/(Project, )/(Project, Public, )/g' $1 #头文件放public里
then
echo -e "\033[32m 移动头文件到public成功 \033[0m" #绿色字
else
echo -e "\033[31m 移动头文件到public失败 \033[0m" #红色
fi
#sed -i "" 's/(Project, Public, )/(Project, )/g' $1  #头文件放project里

}

function main()
{
while read line
do
create_a_file_and_header $line
done < podslist.txt
}

function get_pod_list_by_local_file()
{
pbxPath="../Pods/Pods.xcodeproj/project.pbxproj"
project_header_move_to_public_header $pbxPath

if [ $1 = 1 ]
then
get_local_pods_list #本地文件读取pods列表
else
get_all_pods_list $pbxPath #pbxproject截取pods列表
fi
}

#pbxproject文件截取pods列表
function get_all_pods_list()
{
#cat project.pbxproj | awk "/\/\* Pods \*\/ = \{/,/\};/" | awk "/children = \(/,/\)/" | awk "/\/\*/,/\*\//"

create_lib_dir
echo -e "\033[32m .....begin update all pods.... \033[0m" #绿色字
# pods文件路径
pbxPath=$1
pbxproj=`cat "$pbxPath"`
replace=`echo "$pbxproj" | sed 's/\/\*/wwwwww/g'`

suffix="name = Pods"
#必须加"",否则/*会被当命令转移
header="${replace%%${suffix}*}"

tail="${header##*wwwwww Pods \*/ = {}"
replace2=`echo "$tail" | sed 's/\*\//xxxxxxx/g'`

echo -e "\033[32m pods列表为: \033[0m"
echo "$replace2" | while read line
do
if [[ $line =~ wwwwww ]]
then
right=${line##*wwwwww }
result=${right%%xxxxxxx*}
echo $result >> podslist.txt
echo -e "\033[32m  $result  \033[0m" #绿色字
fi
done

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
cd ../Pods

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
if cp -f $Release_iphoneos_file ../pod2lib/pod_libs/Release
then
echo -e "\033[32m  copy release $Release_iphoneos_file success  \033[0m" #绿色字
else
echo -e "\033[31m copy $Release_iphoneos_file success \033[0m" #红色
fi

#lipo合并指令集到debug
if lipo -create $Release_iphoneos_file $Release_iphonesimulator_file -output ../pod2lib/pod_libs/Debug/$prefix${FRAMEWORK_NAME}$Formate
then
echo -e "\033[32m  lipo 合并fat success for $prefix${FRAMEWORK_NAME}$Formate to debug  \033[0m" #绿色字
else
echo -e "\033[31m lipo 合并fat 失败 for $prefix${FRAMEWORK_NAME}$Formate to debugs \033[0m" #红色
fi

#头文件处理
echo -e "\033[32m ..... 开始做$1头文件.... \033[0m" #绿色字
if [ $Formate == ".a" ];then
header="../pod2lib/pod_libs/Headers"
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
