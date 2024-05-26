extends Node

# 按下发送按钮时候，发送消息给gpt
signal send_button_press(msg :String)

# 更新请求接口
signal update_request(request :Dictionary)

const SAVE_PATH := "user://request.json"

# 预设 
var presets := {}



func json_store_file(dic :Dictionary):
	var json := JSON.stringify(dic)
	var file := FileAccess.open(SAVE_PATH,FileAccess.WRITE)
	file.store_string(json)
	file.close()

func json_read(path:String) -> Dictionary:
	var json := JSON.new()
	var file = FileAccess.open(path,FileAccess.READ)
	if file == null:
		return {}
	var content := json.parse_string(file.get_as_text()) as Dictionary
	return content
	
