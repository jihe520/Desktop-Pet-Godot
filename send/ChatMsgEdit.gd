extends TextEdit


func _gui_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ENTER:
			if event.shift_pressed:
				insert_text_at_caret("\n")
			else:
				Globals.send_button_press.emit(text)
				await get_tree().create_timer(0.2).timeout
				text = ""
				print("prompt text = ",text)
