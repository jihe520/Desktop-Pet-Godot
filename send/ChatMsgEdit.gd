extends TextEdit

var content : Array[Dictionary] = [
 	#{
	#"type": "text",
 	#"text": ""
 	#},
 	#{
	#"type": "image_url",
	#"image_url": {
	#"url": "data:image/png;base64,{base64_image}"
		#}
	#}
]

var base64_image : String = ""

func _gui_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ENTER:
			if event.shift_pressed:
				insert_text_at_caret("\n")
			else:
				_send_content()

func _send_content():
	var text_section : Dictionary =  {
		"type": "text",
		"text": text
	}
	content.append(text_section)
	
	if base64_image != "":
		var image_section : Dictionary = {
			"type": "image_url",
			"image_url": {
				"url": "data:image/png;base64,{%s}" % [base64_image]
			}
		}
		base64_image = ""
		content.append(image_section)
	
	Globals.send_button_press.emit(content)
	
	content.clear()
	await get_tree().create_timer(0.2).timeout
	text = ""
	print("prompt text = ",text)

func _on_button_pressed() -> void:
	_send_content()


func _paste(caret_index: int) -> void:
	if DisplayServer.clipboard_has_image():
		var image : Image = DisplayServer.clipboard_get_image()
		#$"../Sprite2D".texture = ImageTexture.create_from_image(image)
		base64_image = Marshalls.raw_to_base64(image.save_png_to_buffer())
		#print("data:image/png;base64,{%s}" % [base64_image])
		print("image add")
