extends Control

@onready var grid_container: GridContainer = %GridContainer
const PRESET_PANEL = preload("res://send/store_preset/preset_panel.tscn")

var themes_scenes :Array[String] = [
	"res://themes/Base_Canvas/canvas.tscn",
]

func _ready() -> void:
	_get_themes_scenes()
	_change_theme()

func _get_themes_scenes():
	if !OS.has_feature("editor"):
		var exe_dir := OS.get_executable_path().get_base_dir()
		var theme_dir = exe_dir + "/themes"
		printerr("theme_dir",theme_dir)
		var arr :=  DirAccess.get_files_at(theme_dir)
		printerr("arr",arr)
		
		for i in arr:
			themes_scenes.append("res://themes/" + i )
		
		print(themes_scenes)
	pass


func _change_theme():
	for i in themes_scenes:
		var preset_panel = PRESET_PANEL.instantiate()
		preset_panel.panel_type = PresetPanel.PanelType.ThemeType
		preset_panel.path = i
		var arr := i.split('/')
		preset_panel.label_name = arr[arr.size()-1].left(-5)
		grid_container.add_child(preset_panel)
