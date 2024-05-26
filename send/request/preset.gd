extends Control

@onready var model_grid: GridContainer = %ModelGrid
@onready var parament_grid: GridContainer = %ParamentGrid

## GPT3.5
"""
var url : String = 'https://api.openai.com/v1/chat/completions'
var url: String = 'https://api.chatanywhere.tech/v1/chat/completions'
var api_key :String =  'sk-21qKA5RnQak9bespmINCRSr4Zc45uQ1S0Bv8cx7ljXfxTMib'
var model : String = "gpt-3.5-turbo"
"""

## DeepSeek
#var host = "https://api.openai.com"

var presets := []

var preset : Dictionary = {
	"name": "机器人",
	"api": {
		"type": "OpenAI",
		"host": "https://api.deepseek.com",
		"path": "/v1/chat/completions",
		"key": "sk-f5da402f6833491697cd83910e471ea8",
		"model": "deepseek-chat"
	},
	"parameters": {
		"stream": true,
		"temperature": 1.0,
		"topp": 1.0,
		"historycount": 5,
		"maxtokens": 1024,
		"systemprompt": ""
	}
}

func _ready() -> void:
	$OpenAi/ScrollContainer/VBoxContainer/Parament/MarginContainer/ParamentGrid/Stream.button_pressed = true


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


@onready var type: OptionButton = $OpenAi/ScrollContainer/VBoxContainer/Model/MarginContainer/ModelGrid/Type
func _on_type_item_selected(index: int) -> void:
	preset["api"]["type"] = type.get_item_text(index)


func _on_name_text_changed(new_text: String) -> void:
	preset["name"] = new_text

@onready var stream: CheckButton = $OpenAi/ScrollContainer/VBoxContainer/Parament/MarginContainer/ParamentGrid/Stream
func _on_stream_pressed() -> void:
	preset["parameters"]["stream"] = stream.button_pressed

func _on_button_pressed() -> void:
	store_preset_dic()
	print(preset)
	Globals.presets[preset["name"]] = preset
	Globals.update_request.emit(preset)
