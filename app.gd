extends  Node

# model request setting
var api_key :String = ""
var model :String = ""
var host :String = "https://api.openai.com"
var path :String = "/v1/chat/completions"

# model paramenter setting
var max_tokens :int = 3000
var history_count :int = 5
var temperature :float = 0.5
var stream :bool = true
var top_p :float
var system_message :Dictionary

var chat = []
var request_url :String = host+path
var headers = ["Authorization: Bearer " + api_key, "Content-Type: application/json"]

@onready var canvas: Node2D = $Canvas
@onready var chat_message_ai: ChatMessageAI = find_child("ChatMessageAI")

var http_request : HTTPRequest
var httpsse_client: HTTPSSEClient 

func _ready():
	Globals.send_button_press.connect(_on_Btn_send)
	Globals.update_request.connect(_on_Btn_update_preset)
	Globals.change_canvas.connect(_on_change_canvas)
	
	
	if stream:
		httpsse_client = HTTPSSEClient.new()
		add_child(httpsse_client)
		httpsse_client.new_sse_event.connect(_on_new_sse_event)
	else:
		http_request = HTTPRequest.new()
		add_child(http_request)
		http_request.request_completed.connect(_on_request_completed)
	
	system_message = {"role": "system", "content": "简短回复"}
	
	load_preset()

var old_node_name := "Canvas"
func _on_change_canvas(path:String):
	var CANVANS := load(path)
	var new_canvas = CANVANS.instantiate()
	
	var app_node = get_node("/root/App")
	
	app_node.get_node(str(old_node_name)).free()
	app_node.add_child(new_canvas)
	canvas = new_canvas
	
	chat_message_ai = get_node("/root/App/"+ new_canvas.name +"/Dialogue/PanelContainer/MarginContainer/ChatMessageAI")
	
	old_node_name = str(new_canvas.name)

func load_preset():
	if !Globals.current_preset.is_empty():
		preset_set(Globals.current_preset)
	


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)


func _on_Btn_send(content:Array):
	if api_key == "" or model == "" or host == "":
		$Send.title = "请先配置好“请求”参数"
		return
	$Send.title = "SendBox"
	if stream:
		chat_message_ai.clear()
		chat_with_stream(content)
	else:
		chat_without_stream(content)

func _on_Btn_update_preset(preset :Dictionary):
	preset_set(preset)

# 复制请求的参数
func preset_set(preset :Dictionary):
	host = preset["api"]['host']
	path = preset['api']['path']
	api_key = preset["api"]['key']
	model = preset["api"]["model"]
	
	stream = preset['parameters']['stream']
	temperature = preset['parameters']['temperature']
	top_p = preset['parameters']['topp']
	history_count = preset['parameters']['historycount']
	max_tokens = preset['parameters']['maxtokens']
	system_message = {"role": "system", "content": preset['parameters']['systemprompt'] }
	
	request_url = host + path
	headers = ["Authorization: Bearer " + api_key, "Content-Type: application/json"]

## 发送请求
func chat_with_stream(content):
	var messages = [system_message]
	var last_N_messages = chat.slice(-history_count, chat.size(), 1) 
	messages.append_array(last_N_messages)
	
	var new_message = {"role": "user", "content": content} 
	messages.append(new_message)
	
	var request_body = JSON.stringify({
		"messages": messages,
		"stream": true,
		"temperature": temperature,
		"model": model,
		"top_p": top_p
	})
	httpsse_client.connect_to_host(host, path, headers, request_body, chat_message_ai, 443)

func chat_without_stream(content):
	var messages = [system_message]
	var last_N_messages = chat.slice(-history_count, chat.size(), 1) 
	messages.append_array(last_N_messages)
	
	var new_message = {"role": "user", "content": content} 
	messages.append(new_message)
	
	var request_body = JSON.stringify({
		"messages": messages,
		"temperature": temperature,
		"model": model
	})
	var err := http_request.request(request_url, headers, HTTPClient.METHOD_POST, request_body)
	
	if err != OK:
		print("Error initiating HTTP request: ", err)

## 返回请求
func _on_request_completed(_result, _response_code, _headers, body):
	var json = JSON.new()
	var body_string = body.get_string_from_utf8()
	var _Error = json.parse(body_string)
	var response = json.get_data()
	var message = response["choices"][0]["message"]["content"]
	chat_msg_add(message)

func _on_new_sse_event(partial_reply: Array, _ai_status_message: ChatMessageAI):
	for msg in partial_reply:
		if msg == '[DONE]':
			# reply is over
			httpsse_client.close_connection()
			chat.append({"role": "assistant", "content":chat_message_ai.text})
			Globals.is_busy = false
# hide diague
			canvas.start_hide_dialogue()
		elif msg == "[EMPTY DELTA]":
			continue
		elif msg == "[ERROR]":
			pass
		else:
			chat_msg_add(msg)

func chat_msg_add(msg:String):
	if stream:
		chat_message_ai.add_text(msg)
	else:
		chat_message_ai.text = msg



