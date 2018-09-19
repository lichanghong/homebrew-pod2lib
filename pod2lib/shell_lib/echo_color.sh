#!/bin/bash
function echo_color()
{
if [[ $1 == "-h" || ! $1 ]];then
    echo -e "\033[1m usage:\n \033[0m \
\t./echo_color.sh -h 使用方法\n \
\t./echo_color.sh --list 所有可用方法列表
"
    exit -2
fi
if [[ $1 = "--list" ]];then
color_red "color_red 红色"
color_green "color_green 绿色"
color_black "color_black 黑色"
color_yellow "color_yellow 黄色"
color_blue "color_blue 蓝色"
color_purple "color_purple 紫色"
color_skyblue "color_skyblue 天蓝"
color_white "color_white 白色"
color_black_white "color_black_white 黑底白"
color_red_white "color_red_white 红底白"
color_green_white "color_green_white 绿底白"
color_yellow_white "color_yellow_white 黄底白"
color_blue_white "color_blue_white 蓝底白"
color_purple_white "color_purple_white 紫底白"
color_skyblue_white "color_skyblue_white 天蓝底白"
color_white_black "color_white_black 白底黑"
color_cool "color_cool cool"
color_underline "color_underline under line下划线"
color_twinkle "color_twinkle 闪烁"
echo "color_sound 声音"
fi

}

function color_red()
{
	echo -e "\033[31m "$1" \033[0m"
}
function color_green()
{
	echo -e "\033[32m "$1" \033[0m"
}
function color_black()
{
echo -e "\033[30m "$1" \033[0m"
}
function color_yellow()
{
echo -e "\033[33m "$1" \033[0m"
}
function color_blue()
{
echo -e "\033[34m "$1" \033[0m"
}
function color_purple()
{
echo -e "\033[35m "$1" \033[0m"
}
function color_skyblue()
{
echo -e "\033[36m "$1" \033[0m"
}
function color_blue()
{
echo -e "\033[37m "$1" \033[0m"
}
function color_white()
{
echo -e "\033[37m "$1" \033[0m"
}
function color_underline()
{
echo -e "\033[4m "$1" \033[0m"
}
function color_twinkle()
{
echo -e "\033[5m "$1" \033[0m"
}
function color_black_white()
{
echo -e "\033[40;37m "$1" \033[0m"
}
function color_red_white()
{
echo -e "\033[41;37m "$1" \033[0m"
}

function color_green_white()
{
echo -e "\033[42;37m "$1" \033[0m"
}
function color_yellow_white()
{
echo -e "\033[43;37m "$1" \033[0m"
}
function color_blue_white()
{
echo -e "\033[44;37m "$1" \033[0m"
}

function color_purple_white()
{
echo -e "\033[45;37m "$1" \033[0m"
}
function color_skyblue_white()
{
echo -e "\033[46;37m "$1" \033[0m"
}
function color_white_black()
{
echo -e "\033[47;37m "$1" \033[0m"
}

function color_cool()
{
    echo -e "\033[44;37;5m ME \033[0m COOL"
}
function color_sound()
{
echo -e "\007"
}




