extends Window





# 关闭发送窗口
func _on_close_requested() -> void:
	queue_free()


func _on_button_pressed() -> void:
	Globals.send_button_press.emit(%ChatMsgEdit.text)
	%ChatMsgEdit.text = ""
	print("prompt text = ", %ChatMsgEdit.text)


