extends Node2D

@onready var dialogue_timer: Timer = $Dialogue_Timer
@onready var dialogue_node: Control = %Dialogue


func _ready() -> void:
	_initialize_window()
	dialogue_timer.timeout.connect(_on_dialogue_timer)

func _initialize_window() -> void:
	var window: Window = get_window()
	window.size = Vector2i(DisplayServer.screen_get_size() + Vector2i(1, 1))
	window.position = DisplayServer.screen_get_position()


func set_dialogue_label(msg:String):
	%Dialogue.set_dialogue_label(msg)


# 20s内没有任何操作，自动隐藏对话节点 ； 有操作就重新记时
func start_hide_dialogue():
	dialogue_node.show()
	
	dialogue_timer.start(20)

func _on_dialogue_timer():
	dialogue_node.hide()
