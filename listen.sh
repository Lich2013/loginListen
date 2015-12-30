#!/bin/bash

email='530572924@qq.com' #配置邮箱
logintimes_file='count.log' #配置记录文件
loginrecords_file='record.log'

if [ ! -e $logintimes_file ]; #检查文件存在, 不存在就创建
	then
		last | wc -l > $logintimes_file #用当前登录次数初始化文件内容
fi

if [ ! -e $loginrecords_file ];
	then
		last > $loginrecords_file #备份登录记录
fi

logintimes=`< $logintimes_file` #把登录次数读入变量

while (true); 
do
	nowlogintimes=`last | wc -l` #当前登录次数
	if [ $nowlogintimes -gt $logintimes ]; #通过比较当前登录次数来确定是否有人登录
		then
			logininfo=`last -n 1` #获取最新登录记录
			echo $logininfo | mail -s 'login attention' $email #以邮件方式发送出去, 避免wtmp被清空
			echo $nowlogintimes > $logintimes_file #更新登录次数
			logintimes=$nowlogintimes #更新登录次数
	fi
done
