# Merge Script

# 1
# Set bash script to exit immediately if any commands fail.
set -e
. ./function.sh


if [ $1 = "-clean" ]
then
rm -f podslist.txt
get_pod_list_by_local_file 0 #pbxproject截取pods列表
else
get_pod_list_by_local_file 1 #本地文件读取pods列表
fi

main


