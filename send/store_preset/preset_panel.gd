extends PanelContainer
class_name PresetPanel

enum PanelType {
	PresetType,
	ThemeType
}

@export var panel_type : PanelType

var label_name :String = "presetName"
var preset
var path : String

func _ready() -> void:
	%NameLabel.text = label_name

func _on_delete_button_pressed() -> void:
	# 删除数据
	if panel_type == PanelType.PresetType:
		PresetManager.presets.erase(label_name)
		# Globals.store_all_data()
		queue_free()
	elif panel_type == PanelType.ThemeType:
		queue_free()

func _on_load_button_pressed() -> void:
	if panel_type == PanelType.PresetType:
		PresetManager.set_current_preset(preset) 
		
	elif panel_type == PanelType.ThemeType:
		SignalManager.change_canvas.emit(path)
