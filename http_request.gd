extends HTTPRequest

var api_key
var body
var text
var url
var header
var window
var callback=JavaScriptBridge.create_callback(_onCallback)
func _ready():
	window=JavaScriptBridge.get_interface('window')
	#Gonna keep this for future
	#var file = FileAccess.open("res://env.txt", FileAccess.READ)
	#var content = file.get_as_text()
	#var contentSplit=content.split("=")
	#api_key=contentSplit[1]
	#file.close()
	
func _onCallback(args):
	print('callbackworking')
	window.speak()
	%AIResponse.text=window.aiResponse


func sendRequest():
	text=%STTresponse.text
	%STTresponse.clear()
	if text=='' or text=="Awaiting Response...":
		print("No text to send")
		return
	%AIstate.text='thinking'
	print('Getting Response')
	window.getResponse(api_key).then(callback)


func _on_api_container_text_submitted(new_text):
	api_key=new_text
