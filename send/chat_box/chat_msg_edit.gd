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
				if not Globals.is_busy:
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
	Globals.is_busy = true
	
	content.clear()
	await get_tree().create_timer(0.2).timeout
	text = ""
	print("prompt text = ",text)
	texture_queue_free()

func _on_button_pressed() -> void:
	if not Globals.is_busy:
		_send_content()

func _paste(_caret_index: int) -> void:
	if DisplayServer.clipboard_has_image():
		var image : Image = DisplayServer.clipboard_get_image()
		#$"../Sprite2D".texture = ImageTexture.create_from_image(image)
		base64_image = Marshalls.raw_to_base64(image.save_png_to_buffer())
		#print("data:image/png;base64,{%s}" % [base64_image])
		print("image add")
		add_texture(image)
	elif DisplayServer.clipboard_has():
		# 文本粘贴
		text = DisplayServer.clipboard_get()
	
func add_texture(image:Image):
	var texture_rect : TextureRect = TextureRect.new()
	texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.texture = ImageTexture.create_from_image(image)
	%ImageContainer.add_child(texture_rect)
	
func texture_queue_free():
	for child in %ImageContainer.get_children():
		child.queue_free()
