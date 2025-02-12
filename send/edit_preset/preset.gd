extends Control

@onready var model_grid: GridContainer = %ModelGrid
@onready var parament_grid: GridContainer = %ParamentGrid
@onready var type: OptionButton = $MarginContainer/ScrollContainer/VBoxContainer/Model/MarginContainer/ModelGrid/Type
@onready var stream: CheckButton = $MarginContainer/ScrollContainer/VBoxContainer/Parament/MarginContainer/ParamentGrid/Stream

var preset : Dictionary = {
	"name": "robot",
	"api": {
		"type": "OpenAI",
		"host": "https://api.openai.com",
		"path": "/v1/chat/completions",
		"key": "",
		"model": "gpt-4o"
	},
	"parameters": {
		"stream": true,
		"temperature": 1.0,
		"topp": 0.3,
		"historycount": 5,
		"maxtokens": 3000,
		"systemprompt": ""
	},
}

func _ready() -> void:
	stream.button_pressed = true

func store_preset_dic():
	for child in model_grid.get_children():
		if child is LineEdit:
			if child.name.to_lower() != "name":
				preset["api"][child.name.to_lower()] = child.text
			
	for child in parament_grid.get_children():
		if child is TextEdit:
			preset["parameters"][child.name.to_lower()] = child.text
		
		if child is LineEdit:
			var little_name := child.name.to_lower()
			if little_name == "stream":
				continue
			match little_name:
				"historycount": preset["parameters"][little_name] = child.text.to_int()
				"topp":  preset["parameters"][little_name] = child.text.to_float()
				"temperature": preset["parameters"][little_name] = child.text.to_float()
				"maxtokens" : preset["parameters"][little_name] = child.text.to_int()


func _on_type_item_selected(index: int) -> void:
	preset["api"]["type"] = type.get_item_text(index)

func _on_name_text_changed(new_text: String) -> void:
	preset["name"] = new_text

func _on_stream_pressed() -> void:
	preset["parameters"]["stream"] = stream.button_pressed

# 保存按钮
func _on_button_pressed() -> void:
	store_preset_dic()
	# modify the exist preset or add new preset
	PresetManager.set_current_preset(preset)
	PresetManager.save_presets()
	SignalManager.update_current_preset.emit(PresetManager.get_current_preset())
	SignalManager.add_new_preset_panel.emit()
