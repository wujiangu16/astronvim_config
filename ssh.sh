#!/usr/bin/expect

set timeout 30
set host [lindex $argv 0]
# 这一行是设置一个变量的意思，变量名随便起，尽量有意义，后面表示的是传入的参数，0 表示第一个参数，后面会用到。
set port [lindex $argv 1]
set user [lindex $argv 2]
set pswd [lindex $argv 3]

spawn ssh -p $port $user@$host 
# spawn 是 expect 环境的内部命令，它主要的功能是给 ssh 运行进程加个壳，用来传递交互指令。

expect {
        "(yes/no)?"
        {send "yes\n";exp_continue;}
	      -re "(p|P)ass(word|wd):"
        {send "$pswd\n"}
}
# expect 也是 expect 环境的一个内部命令，用来判断上一个指令输入之后的得到输出结果是否包含 "" 双引号里的字符串，-re 表示通过正则来匹配。
# 如果是第一次登录，会出现 "yes/no" 的字符串，就发送（send）指令 "yes\r"，然后继续（exp_continue）。

interact
# interact：执行完成后保持交互状态，把控制权交给控制台。
