extends Node

# presets.json 保存路径
const SAVE_PATH := "user://presets.json"

# 预设
# TODO: 1. 简化这里的配置信息 2. private
var presets: Dictionary = {} # 所有预设
var _current_name: String = "" # 当前预设名称
#var current_preset: Dictionary = {}: # 当前预设
	#set(val):
		#current_preset = val
		#current_name = current_preset["name"]

# before start , load all presets to presets from loacl
func _ready() -> void:
	var content = Utils.json_read(SAVE_PATH)
	if content.has("presets"):
		presets = content["presets"]
#	检查文件中是否存在current
	if content.has("current"):
		_current_name = content["current"]
		#if presets.has(current_name):
			#current_preset = presets[current_name]
	
	print(presets)

# 在关闭时保存presets
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_presets()
		get_tree().quit()

# TODO: 预设名称一样可能出bug
func set_presets(new_preset):
	presets[new_preset["name"]] = new_preset

func set_current_preset(new_preset):
	_current_name = new_preset['name']
	set_presets(new_preset)

func get_current_preset():
	if _current_name.is_empty():
		return {}
	return presets[_current_name]



# 将当前的 presets 保存
func save_presets():
		Utils.json_store_file({
			"current": _current_name,
			"presets": presets
			},SAVE_PATH)

## example json data
"""
{
	"current": "xxx",
	"presets": {
		"das": {
			"api": {
				"host": "https://api.openai.com",
				"key": "xx",
				"model": "gpt-4o",
				"path": "/v1/chat/completions",
				"type": "OpenAI"
			},
			"name": "xx",
			"parameters": {
				"historycount": 5,
				"maxtokens": 3000,
				"stream": true,
				"systemprompt": "you are a helpful helper",
				"temperature": 1,
				"topp": 0.3
			}
		},
		"xxxx": {
			"api": {
				"host": "xx",
				"key": "sk-xx",
				"model": "xxx",
				"path": "/v1/chat/completions",
				"type": "OpenAI"
			},
			"name": "dasddasd",
			"parameters": {
				"historycount": 5,
				"maxtokens": 3000,
				"stream": true,
				"systemprompt": "you are a helpful helper",
				"temperature": 1,
				"topp": 0.3
			}
		}
	}
}
"""
