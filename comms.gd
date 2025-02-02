extends Node

signal sendText
signal convo_ended

@onready var game_state = $GameState
@onready var viseme = $"../Viseme"
var console
var window
var received_text
var isListening
var act_end = false
var StoryStates = {
	0:'In-Progress',
	1:'Success',
	2:'Failed'
}
func _ready():
	#if !Engine.is_editor_hint():
		#print('No in editor')
		#set_process(false)
		#return
	SceneLoader.connect("startAct",_startAct)
	SceneLoader.connect("retryAct",_startAct)
	isListening=false
	connect('sendText',%HTTPRequest.sendRequest)
	setup_microphone()
	if OS.is_debug_build():
		set_process(false)
		return
	console=JavaScriptBridge.get_interface('console')
	window=JavaScriptBridge.get_interface('window')
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
	print('Listening...')
	isListening=true
	start_listening()
	

func _on_record_button_up():
	print('Button released, stopped listening')
	stop_listening()
	sendText.emit()
	isListening=false

func  _process(delta):
	var currentState = JavaScriptBridge.call('eval','window.state')
	var intState = int(JSON.parse_string(currentState))
	game_state.text=StoryStates[intState]
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
	act_end = JavaScriptBridge.call("eval","window.act_over")
	if act_end:
		set_process(false)
		viseme.set_process(false)
		SceneLoader.act_result = intState
		convo_ended.emit()
		return
		
func _resetStates():
	game_state.text=StoryStates[0]
	JavaScriptBridge.call("eval","window.resetChat()")
	%STTresponse.text= ''
func _startAct():
	_resetStates()
	print('act_started or restarted')
	act_end = false
	set_process(true)
	viseme.set_process(true)
#func restartAct():
	#_resetStates()
	#print('act restarted')
	#act_end = false
	#set_process(true)
	#viseme.set_process(true)
