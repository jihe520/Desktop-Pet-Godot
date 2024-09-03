extends Control

@onready var grid_container: GridContainer = %GridContainer
const PRESET_PANEL = preload("res://send/store_preset/preset_panel.tscn")

var themes_scenes :Array[String] = [
	"res://themes/Tiny_Swords/tiny_swords_canvas.tscn",
	"res://themes/Base_Canvas/canvas.tscn",
	"res://themes/VPet/v_pet.tscn"
]

func _ready() -> void:
	_change_theme()

func _change_theme():
	for i in themes_scenes:
		var preset_panel = PRESET_PANEL.instantiate()
		preset_panel.panel_type = PresetPanel.PanelType.ThemeType
		preset_panel.path = i
		var arr := i.split('/')
		preset_panel.label_name = arr[arr.size()-1].left(-5)
		grid_container.add_child(preset_panel)
