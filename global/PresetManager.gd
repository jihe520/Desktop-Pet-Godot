extends Node

# presets.json 保存路径
const SAVE_PATH := "user://presets.json"

# 预设
var presets: Dictionary = {}
var current_name: String = ""
var current_preset: Dictionary = {}:
	set(val):
		current_preset = val
		current_name = current_preset["name"]

# before start , load all presets to presets from loacl
func _ready() -> void:
	var content = Utils.json_read(SAVE_PATH)
	if content.has("presets"):
		presets = content["presets"]
		#for key in content.presets:
			#result[key] = create_preset_from_dict(content.presets[key])
#	检查文件中是否存在current
	if content.has("current"):
		current_name = content["current"]
		if presets.has("current_name"):
			current_preset = presets[current_name]
	
	print(presets)

# 在关闭时保存presets
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		
		Utils.json_store_file({
			"current": current_name,
			"presets": presets
			},SAVE_PATH)
		get_tree().quit()

# 从字典创建Preset对象
func create_preset_from_dict(dict: Dictionary) -> PresetClass.Preset:
	var api_config = PresetClass.APIConfig.new()
	api_config.host = dict.api.host
	api_config.key = dict.api.key
	api_config.model = dict.api.model
	api_config.path = dict.api.path
	api_config.type = dict.api.type

	var params = PresetClass.Parameters.new()
	params.historycount = dict.parameters.historycount
	params.maxtokens = dict.parameters.maxtokens
	params.stream = dict.parameters.stream
	params.systemprompt = dict.parameters.systemprompt
	params.temperature = dict.parameters.temperature
	params.topp = dict.parameters.topp

	var preset = PresetClass.Preset.new(dict.name, api_config, params)
	return preset

## 将preset 中 每个对象转化为字典
#func presets_to_dic(presets:Dictionary):
	#presets_dic = {}
	#for preset_name in presets:
		#var preset = presets[preset_name]
		## 假设我们将 Preset 转换为一个简单的字典
		#target_dict["presets"][preset_name] = {
			#"some_data": preset.some_data
		#}


func get_preset_by_name(name:String) -> PresetClass.Preset:
	return presets[name]




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
