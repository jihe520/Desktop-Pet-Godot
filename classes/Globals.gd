extends Node

# 按下发送按钮时候，发送消息给gpt
signal send_button_press(content :Array)
# 更新请求接口
signal update_current_preset(presets :Dictionary)

signal add_new_preset_panel()

signal change_canvas(path :String)

const SAVE_PATH := "user://presets.json"

const CURRENT_PRESET_SAVE_PATH = "user://current_presets.json"

var cur_send_window_num = 1
# 预设 
var presets : Dictionary = {}:
	set(val):
		presets = val

var current_preset :Dictionary = {}:
	set(val):
		current_preset = val
		update_current_preset.emit(current_preset)

# judge whether had sent request
var is_busy = false

# before start , load all presets to presets from loacl
func _ready() -> void:
	load_all_data()

func store_all_data():
	json_store_file(current_preset,CURRENT_PRESET_SAVE_PATH)
	json_store_file(presets,SAVE_PATH)

func load_all_data():
	current_preset = json_read(CURRENT_PRESET_SAVE_PATH)
	presets = json_read(SAVE_PATH)

# store
func json_store_file(dic :Dictionary,path :String):
	var json := JSON.stringify(dic)
	var file := FileAccess.open(path,FileAccess.WRITE)
	file.store_string(json)
	file.close()

func json_read(path:String) -> Dictionary:
	var file = FileAccess.open(path,FileAccess.READ)
	if file == null:
		# not this file.json
		return {}
	var content := JSON.parse_string(file.get_as_text()) as Dictionary
	file.close()
	return content

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		store_all_data()
		get_tree().quit()


