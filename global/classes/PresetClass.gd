# 存储API相关配置
class_name PresetClass

class APIConfig:
	var host: String
	var key: String
	var model: String
	var path: String
	var type: String
	
	func _init(p_host := "", p_key := "", p_model := "", p_path := "", p_type := "") -> void:
		host = p_host
		key = p_key
		model = p_model
		path = p_path
		type = p_type
	
	func to_dict() -> Dictionary:
		return {
			"host": host,
			"key": key,
			"model": model,
			"path": path,
			"type": type
		}

class Parameters:
	var historycount: int
	var maxtokens: int
	var stream: bool
	var systemprompt: String
	var temperature: float
	var topp: float
	
	func _init(p_historycount := 5, p_maxtokens := 3000, p_stream := true,
			p_systemprompt := "", p_temperature := 1.0, p_topp := 0.3) -> void:
		historycount = p_historycount
		maxtokens = p_maxtokens
		stream = p_stream
		systemprompt = p_systemprompt
		temperature = p_temperature
		topp = p_topp
	
	func to_dict() -> Dictionary:
		return {
			"historycount": historycount,
			"maxtokens": maxtokens,
			"stream": stream,
			"systemprompt": systemprompt,
			"temperature": temperature,
			"topp": topp
		}

class Preset:
	var name: String
	var api: APIConfig
	var parameters: Parameters
	
	func _init(p_name := "", p_api := APIConfig.new(), p_parameters := Parameters.new()) -> void:
		name = p_name
		api = p_api
		parameters = p_parameters
	
	func to_dict() -> Dictionary:
		return {
			"name": name,
			"api": api.to_dict(),
			"parameters": parameters.to_dict()
		}
