extends HBoxContainer

var dragging : bool = false
var mouse_offset : Vector2i
@onready var send: Window = $"../../../../.."


#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			#dragging = true
			#mouse_offset = get_global_mouse_position()
		#else:
			#dragging = false
	#if event is InputEventMouseMotion and dragging:
		##窗口位置=鼠标位置  - 鼠标的偏差值
		#DisplayServer.window_set_position(DisplayServer.mouse_get_position()-mouse_offset,send.get_window_id())
