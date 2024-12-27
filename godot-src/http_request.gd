extends HTTPRequest

var api_key
var azure_key
var body
var text
var url
var header
var window
var callback=JavaScriptBridge.create_callback(_onCallback)
signal startViseme
func _ready():
	if OS.is_debug_build():
		return
	window=JavaScriptBridge.get_interface('window')
	#connect('startViseme',Viseme.startAnim)
	#Gonna keep this for future
	var file = FileAccess.open("res://env.txt", FileAccess.READ)
	var content = file.get_as_text()
	var lines=content.split('\n')
	var Groq_Split=lines[0].split("=")
	api_key=Groq_Split[1]
	azure_key=lines[1].split("=")[1]
	file.close()
	window.initializeTTS(azure_key)
	#JavaScriptBridge.eval("initializeTTS('%s')"% azure_key.replace("'", "\\'"))
	
func _onCallback(args):
	print('callbackworking')
	window.speak()
	%AIResponse.text=window.aiResponse
	#startViseme.emit()


func sendRequest():
	text=%STTresponse.text
	%STTresponse.clear()
	if text=='' or text=="Awaiting Response...":
		print("No text to send")
		return
	%AIstate.text='thinking'
	print('Getting Response')
	window.getResponse(str(api_key))
