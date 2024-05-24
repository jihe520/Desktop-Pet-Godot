class_name HTTPSSEClient
extends Node

signal new_sse_event
signal connected
signal connection_error(error)


var httpclient = HTTPClient.new()
var is_connected = false

var domain
var url_after_domain
var headers : PackedStringArray
var body: String
var port
var told_to_connect = false
var connection_in_progress = false
var request_in_progress = false
var is_requested = false
var response_body = PackedByteArray()

var ai_status_message

func connect_to_host(domain : String, url_after_domain : String, headers: PackedStringArray, body: String, ai_message: ChatMessageAI, port : int = -1):
	self.domain = domain
	self.url_after_domain = url_after_domain
	self.port = port
	self.headers = headers
	self.body = body
	told_to_connect = true
	ai_status_message = ai_message
	
func close_connection():
	httpclient.close()
	is_connected = false
	told_to_connect = false
	connection_in_progress = false
	request_in_progress = false
	is_requested = false

func attempt_to_connect():
	var err = httpclient.connect_to_host(domain, port)
	if err == OK:
		emit_signal("connected")
		is_connected = true
	else:
		emit_signal("connection_error", str(err))

func attempt_to_request(httpclient_status):
	if httpclient_status == HTTPClient.STATUS_CONNECTING or httpclient_status == HTTPClient.STATUS_RESOLVING:
		return
		
	if httpclient_status == HTTPClient.STATUS_CONNECTED:
		var err = httpclient.request(HTTPClient.METHOD_POST, url_after_domain, headers, body)
		if err == OK:
			is_requested = true

func _process(delta):
	if !told_to_connect:
		return
		
	if !is_connected:
		if !connection_in_progress:
			attempt_to_connect()
			connection_in_progress = true
		return
		
	httpclient.poll()
	var httpclient_status = httpclient.get_status()
	if !is_requested:
		if !request_in_progress:
			attempt_to_request(httpclient_status)
		return
		
	var httpclient_has_response = httpclient.has_response()
		
	if httpclient_has_response or httpclient_status == HTTPClient.STATUS_BODY:
		var response_headers = httpclient.get_response_headers_as_dictionary()

		httpclient.poll()
		var chunk = httpclient.read_response_body_chunk()
		if(chunk.size() == 0):
			return
		else:
			# each chunk sometimes can contain more than one delta of data.
			response_body = chunk 
			
		var string_body = response_body.get_string_from_utf8()
		if string_body:
			var partial_reply = get_open_ai_events_data(string_body)
			emit_signal("new_sse_event", partial_reply, ai_status_message)


# Since each chunk sometimes can contain more than one delta of data this
# function will iterate through each "data" block found and extract its
# content concatenating it in an array.
func get_open_ai_events_data(string_body: String) -> Array:
	var results = []
	string_body = string_body.strip_edges()  # Remove leading and trailing whitespaces, including new lines
	var data_entries = string_body.split("\n\n")  # Split the body into individual data entries

	for entry in data_entries:
		if entry == "data: [DONE]":
			results.append("[DONE]")
			continue

		entry = entry.replace("data: ", "")
		var parsed_data = JSON.parse_string(entry)
		if parsed_data == null:
			printerr("Error: Received data is not a valid JSON object")
			results.append("[ERROR]")
		else:
			if "choices" in parsed_data and parsed_data["choices"].size() > 0:
				var choices = parsed_data["choices"][0]
				if "delta" in choices:
					var delta = choices["delta"]
					if "content" in delta:
						results.append(delta["content"])
					elif delta.is_empty():
						results.append("[EMPTY DELTA]")
					else:
						printerr("Error: 'content' field not found in the 'delta'")
						results.append("[ERROR]")
				else:
					printerr("Error: 'delta' field not found in the first choice")
					results.append("[ERROR]")
			else:
				printerr("Error: 'choices' field not found in the received data")
				results.append("[ERROR]")

	return results


func _exit_tree():
	if httpclient:
		httpclient.close()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if httpclient:
			httpclient.close()
		get_tree().quit()
