#!/bin/bash
# Name:bakmysql.sh
# This is a ShellScript For Auto DB Backup and Delete old Backup
#备份地址
backupdir=/home/mysqlbackup
#备份文件后缀时间
time=_` date +%Y_%m_%d_%H_%M_%S `
#需要备份的数据库名称
db_name=test
#mysql 用户名
db_user=root
#mysql 密码
db_pass=123456
mysqldump -u $db_user -p$db_pass $db_name | gzip > $backupdir/$db_name$time.sql.gz
#删除一分钟之前的备份文件
find $backupdir -name $db_name"*.sql.gz" -type f -mmin +1 -exec rm -rf {} \; > /dev/null 2>&1
保存退出

说明：

代码中 time=` date +%Y%m%d%H `也可以写为time=”$(date +”%Y%m%d$H”)”
其中`符号是TAB键上面的符号，不是ENTER左边的’符号，还有date后要有一个空格。
db_name：数据库名；
db_user：数据库用户名；
db_pass：用户密码；
-type f    表示查找普通类型的文件，f表示普通文件。
-mtime +7   按照文件的更改时间来查找文件，+7表示文件更改时间距现在7天以前；如果是 -mmin +7 表示文件更改时间距现在7分钟以前。

-exec rm {} ;   表示执行一段shell命令，exec选项后面跟随着所要执行的命令或脚本，然后是一对儿{}，一个空格和一个，最后是一个分号。
/dev/null 2>&1  把标准出错重定向到标准输出，然后扔到/DEV/NULL下面去。通俗的说，就是把所有标准输出和标准出错都扔到垃圾桶里面；其中的&表示让该命令在后台执行。

定时执行

bak_config 文件代码如下

#every day exec
0 0 * * * /home/bak_sh/bak_day.sh
#every week exec
0 0 * * 0 /home/bak_sh/bak_week.sh
#every month exec
0 0 1 * * /home/bak_sh/bak_month.sh
先用查询状态命令查询crond状态，如果处在停止状态则须先启动；如已在启动状态，则无须理会。

操作命令如下：

  /sbin/service crond start 启动

  /sbin/service crond restart 重启

  /sbin/service crond stop 停止

  /sbin/service crond status 查询状态

查看服务是否已经运行用 

ps -ax | grep cron

查看调度任务
crontab -l //列出当前的所有调度任务
crontab -r   //删除所有任务调度工作

添加调度任务

crontab /home/bak_sh/bak_config

http://blog.sina.com.cn/s/blog_621f9b110101pfp1.html