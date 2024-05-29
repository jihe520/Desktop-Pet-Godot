extends  Node

@export var api_key = "sk-21qKA5RnQak9bespmINCRSr4Zc45uQ1S0Bv8cx7ljXfxTMib"
@export var model = "gpt-4o"

var host :String = "https://api.chatanywhere.com.cn"
var path :String= "/v1/chat/completions"
var request_url :String = host+path
var max_tokens = 1024
var history_count : int
@export var temperature : float = 0.5
@export var stream : bool = true
var top_p:float
var system_message : Dictionary

var messages = []

var headers = ["Authorization: Bearer " + api_key, "Content-Type: application/json"]



@onready var canvas: Node2D = $Canvas
@onready var chat_message_ai: ChatMessageAI = $Canvas/Dialogue/PanelContainer/MarginContainer/ChatMessageAI

var http_request : HTTPRequest
var httpsse_client: HTTPSSEClient 


func _ready():
	Globals.send_button_press.connect(_on_Btn_send)
	Globals.update_request.connect(_on_Btn_update_request)
	
	if stream:
		httpsse_client = HTTPSSEClient.new()
		add_child(httpsse_client)
		httpsse_client.new_sse_event.connect(_on_new_sse_event)
	else:
		http_request = HTTPRequest.new()
		add_child(http_request)
		http_request.request_completed.connect(_on_request_completed)
	
	system_message = {"role": "system", "content": "回复简短"}
	messages = [system_message]
	
	#if !Globals.json_read("user://request.json").is_empty():
		#request_set(Globals.json_read("user://request.json")["das"])


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()


func _on_Btn_send(content:Array):
	if api_key == "" or model == "" or host == "":
		$Send.title = "请先配置好“请求”参数"
		return
	$Send.title = "SendBox"
	if stream:
		chat_message_ai.clear()
		chat_with_stream(content)
	else:
		#chat_without_stream(content)
		pass

func _on_Btn_update_request(request :Dictionary):
	request_set(request)


# 复制请求的参数
func request_set(preset :Dictionary):
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
	messages = [system_message]
	if !Globals.presets.has(preset["name"]):
		Globals.presets[preset["name"]] = preset
	Globals.json_store_file(Globals.presets)

func chat_msg_add(msg:String):
	if stream:
		if msg != "[EMPTY DELTA]":
			chat_message_ai.add_text(msg)
	else:
		chat_message_ai.text = msg

## 发送请求
func chat_with_stream(content):
	var msg = {"role": "user", "content": content}
	messages.append(msg)
	var request_body = JSON.stringify({
		"messages": messages,
		"stream": true,
		"temperature": temperature,
		"model": model,
		"top_p": top_p
	})
	httpsse_client.connect_to_host(host, path, headers, request_body, chat_message_ai, 443)

func chat_without_stream(prompt:String):
	var msg = {"role": "user", "content": prompt}
	messages.append(msg)
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
			httpsse_client.close_connection()
		else:
			chat_msg_add(msg)
