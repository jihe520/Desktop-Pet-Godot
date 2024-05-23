extends  Node


## GPT3.5
"""
#var url : String = 'https://api.openai.com/v1/chat/completions'
var url: String = 'https://api.chatanywhere.tech/v1/chat/completions'
var api_key :String =  'sk-21qKA5RnQak9bespmINCRSr4Zc45uQ1S0Bv8cx7ljXfxTMib'
var model : String = "gpt-3.5-turbo"
"""

## DeepSeek

var url: String = 'https://api.deepseek.com/v1/chat/completions'
var api_key :String =  "sk-696c482afc8b43dda4c707521426353a"
var model : String = "deepseek-chat"





var headers = ["Content-Type: application/json", "Authorization: Bearer " + api_key]
var instruction: String = "You are a knowledgeable and concise Godot expert, providing focused guidance on using the game engine effectively."
var conversation = []
var request: HTTPRequest
var messages = []
var temperature : float = 0.5
var max_tokens : int = 1024


@onready var canvas: Node2D = $Canvas


func _ready():
	request =  HTTPRequest.new()
	add_child(request)
	request.request_completed.connect(_on_request_completed)
	Globals.send_button_press.connect(_on_Btn_send)
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()


func _on_request_completed(result, response_code, headers, body: PackedByteArray):
	var json = JSON.new()
	var body_string = body.get_string_from_utf8()
	var Error = json.parse(body.get_string_from_utf8())
	var response = json.get_data()

	var message = response["choices"][0]["message"]["content"]
	
	canvas.set_dialogue_label(message)
	

func dialogue_request(player_dialogue):
	messages.append({
		"role": "user",
		"content": player_dialogue
		})
		
	var body = JSON.new().stringify({
		"messages": messages,
		"temperature": temperature,
		"max_tokens": max_tokens,
		"model": model
	})
	var send_request = request.request(url, headers, HTTPClient.METHOD_POST, body)
	if send_request != OK:
		print("There was an error!")
	else:
		print('OK')


func _on_Btn_send(msg:String):
	dialogue_request(msg)
	
