extends Node

var console
var window
var received_text
var isListening

func _ready():
	isListening=false
	setup_microphone()
	console=JavaScriptBridge.get_interface('console')
	#window=JavaScriptBridge.get_interface('window')
# Functions to control the JavaScript audio functions
func setup_microphone() -> void:
	JavaScriptBridge.call("eval", "setupMicrophone();")

func start_recording() -> void:
	JavaScriptBridge.call("eval", "startRecording();")

func stop_recording() -> void:
	JavaScriptBridge.call("eval", "stopRecording();")

func play_audio() -> void:
	JavaScriptBridge.call("eval", "playAudio();")

func start_listening() -> void:
	JavaScriptBridge.call("eval", "startListening();")

func stop_listening() ->void:
	JavaScriptBridge.call("eval","stopListening();")

func get_recognized_text() -> String:
	return JavaScriptBridge.call("eval", "window.recognizedText || ''")


func _on_play_pressed():
	play_audio()


func _on_stop_pressed():
	stop_recording()


func _on_start_pressed():
	start_recording()

func _on_record_pressed():
	%Record.scale(1.3)
	print('Listening...')
	isListening=true
	start_listening()
	



func _on_record_button_up():
	print('Button released, aint listening')
	stop_listening()
	%Record.scale(1)
	isListening=false

func  _process(delta):
	%AIstate.text=JavaScriptBridge.call('eval','window.ttsState')
	%STTresponse.text=get_recognized_text()
	var state = JavaScriptBridge.call("eval","window.recognitionState")
	match state:
		"listening":
			%State.text=state
			isListening=true
		"idle":
			%State.text=state
			isListening=false
			#%STTresponse.clear()
		"error":
			%State.text=state
			
