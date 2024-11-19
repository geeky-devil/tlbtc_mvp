extends HTTPRequest

var api_key
var body
var text
var url
var header
var window
var callback=JavaScriptBridge.create_callback(_onCallback)
func _ready():
	var file = FileAccess.open("res://env.txt", FileAccess.READ)
	var content = file.get_as_text()
	var contentSplit=content.split("=")
	api_key=contentSplit[1]
	file.close()
	window=JavaScriptBridge.get_interface('window')
	url="https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=%s" %api_key

	
func _on_send_pressed():
	text=%STTresponse.text
	%STTresponse.clear()
	if text=='' or text=="Awaiting Response...":
		print("No text to send")
		return
	%AIstate.text='thinking'
	window.getResponse(str(url)).then(callback)
	
func _onCallback(args):
	print('callbackworking')
	window.speak()
	%AIResponse.text=window.aiResponse
