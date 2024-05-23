extends Node2D


## The main screen the app uses.


func _ready() -> void:
	_initialize_window()
	

func _initialize_window() -> void:
	var window: Window = get_window()
	window.size = Vector2i(DisplayServer.screen_get_size() + Vector2i(1, 1))
	window.position = DisplayServer.screen_get_position()


func set_dialogue_label(msg:String):
	%Dialogue.set_dialogue_label(msg)
