#!/bin/bash

# 从命令行参数获取密码和命令
password=$1
command=$2

# 使用expect命令自动输入密码
# 如果密码为 no, 则不需要
if [ "$password" = "No" ]
  then
    $command
  else
    expect <<END
    spawn $command
    # expect "password:"
    expect {
            "(yes/no"
            {send "yes\n";exp_continue;}
	          -re "(p|P)ass(word|wd):"
            {send "$password\n"}
    }
    expect eof
END
fi


# expect <<END
# spawn $command
# expect "password:"
# send "$password\r"
# expect eof
# END
