extends Node2D
var dragging:bool #拖拽状态
var v2_mouse:Vector2i #鼠标的偏差

@onready var _ClickPolygon: CollisionPolygon2D = $"%ClickPolygon"
const SEND = preload("res://send/send.tscn")

func _physics_process(_delta: float) -> void:
	_update_click_polygon()

func _update_click_polygon() -> void:
	var click_polygon: PackedVector2Array = _ClickPolygon.polygon
	for vec_i in range(click_polygon.size()):
		click_polygon[vec_i] = to_global(click_polygon[vec_i])
	get_window().mouse_passthrough_polygon = click_polygon


#拖拽窗口
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			dragging = true
			v2_mouse =get_global_mouse_position()
		else:
			dragging = false
			
	if event is InputEventMouseMotion and dragging:
		#窗口位置=鼠标位置  - 鼠标的偏差值
		DisplayServer.window_set_position(DisplayServer.mouse_get_position()-v2_mouse)
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			var send = SEND.instantiate()
			get_node('/root/App').add_child(send)
