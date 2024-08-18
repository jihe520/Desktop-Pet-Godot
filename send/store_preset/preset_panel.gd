extends PanelContainer
class_name PresetPanel

var label_name :String = "presetName"
var preset

func _ready() -> void:
	%NameLabel.text = label_name

func _on_delet_button_pressed() -> void:
	# 删除数据
	Globals.presets.erase(label_name)
	Globals.store_all_data()
	queue_free()

func _on_load_button_pressed() -> void:
	Globals.current_preset = preset
