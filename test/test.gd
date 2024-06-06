extends Node

var dic := {}


func _ready() -> void:
	dic['你好'] = 1
	print(dic)
	dic['他该'] = 2
	print(dic)
