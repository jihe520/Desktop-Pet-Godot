extends Window

# generate Send window in central Sreen  
func _ready() -> void:
	var screen_size := DisplayServer.screen_get_size()
	position = screen_size / 2
	position -= Vector2i(700,700)

# 关闭发送窗口
func _on_close_requested() -> void:
	queue_free()
	Globals.cur_send_window_num -= 1
