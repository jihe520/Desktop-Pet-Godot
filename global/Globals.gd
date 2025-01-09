extends Node

#  当前发送窗口数,超过2就不能再生成
var cur_send_window_num = 1
# judge whether had sent request
var is_busy = false
