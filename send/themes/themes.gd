extends Control


@onready var grid_container: GridContainer = %GridContainer

var themes_scenes :Array[String] = [
	"res://themes/Tiny_Swords/tiny_swords_canvas.tscn",
	"res://themes/Base_Canvas/canvas.tscn"
]


func _ready() -> void:
	_change_theme()
	

func _change_theme():
	
	for i in themes_scenes:
		var button := Button.new()
		var arr := i.split('/')
		button.text = arr[arr.size()-1].left(-5)
		button.pressed.connect(_select_presets.bind(i))
		grid_container.add_child(button)

func _select_presets(path :String):
	print(path)
	Globals.change_canvas.emit(path)
