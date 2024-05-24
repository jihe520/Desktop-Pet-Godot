@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("HTTPSSEClient", "Node", preload("res://addons/HTTPSSEClient/HTTPSSEClient_modified.gd"), preload("res://addons/HTTPSSEClient/icon.png"))
	pass

func _exit_tree():
	remove_custom_type("HTTPSSEClient")
	pass
