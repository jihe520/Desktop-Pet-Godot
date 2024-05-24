extends  Node


## GPT3.5
"""
#var url : String = 'https://api.openai.com/v1/chat/completions'
var url: String = 'https://api.chatanywhere.tech/v1/chat/completions'
var api_key :String =  'sk-21qKA5RnQak9bespmINCRSr4Zc45uQ1S0Bv8cx7ljXfxTMib'
var model : String = "gpt-3.5-turbo"
"""

## DeepSeek

@export var api_key = "sk-696c482afc8b43dda4c707521426353a"
# var max_tokens = 1024
@export var temperature = 0.5
@export var model = "deepseek-chat"
@export var stream : bool = true
var system_message : Dictionary
var messages = []

var headers = ["Authorization: Bearer " + api_key, "Content-Type: application/json"]
var host = "https://api.deepseek.com"
#var host = "https://api.openai.com"
var path = "/v1/chat/completions"
var request_url = host+path


@onready var canvas: Node2D = $Canvas
@onready var chat_message_ai: ChatMessageAI = $Canvas/Dialogue/PanelContainer/MarginContainer/ChatMessageAI

var http_request : HTTPRequest
var httpsse_client: HTTPSSEClient 


func _ready():
	Globals.send_button_press.connect(_on_Btn_send)
	
	if stream:
		httpsse_client = HTTPSSEClient.new()
		add_child(httpsse_client)
		httpsse_client.new_sse_event.connect(_on_new_sse_event)
	else:
		http_request = HTTPRequest.new()
		add_child(http_request)
		http_request.request_completed.connect(_on_request_completed)
	
	system_message = {"role": "system", "content": "你是一个 godot 助手，你懂得大量的godot游戏引擎的知识."}
	messages = [system_message]



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()


func _on_Btn_send(msg:String):
	if stream:
		chat_message_ai.clear()
		chat_with_stream(msg)
	else:
		chat_without_stream(msg)

func chat_msg_add(msg:String):
	if stream:
		chat_message_ai.add_text(msg)
	else:
		chat_message_ai.text = msg

## 发送请求
func chat_with_stream(prompt:String):
	var msg = {"role": "user", "content": prompt}
	messages.append(msg)
	var request_body = JSON.stringify({
		"messages": messages,
		"stream": true,
		"temperature": temperature,
		"model": model
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
