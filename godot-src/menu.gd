extends Control
@onready var micButton=$MicButton
@onready var animPlayer=$AnimationPlayer
@onready var banim = $Viseme/BodyAnim
@onready var menuMusic=$AudioStreamPlayer2D
#@onready var volume_bar=$MicContainer/VolumeBar
@onready var narrator = $Narrator
@onready var mic_container=$MicContainer
@onready var audio_out=$micOutput
@onready var bg = $S1Img1
@export var dialogue_res : DialogueResource
var reverse=false
var record_bus_index:int
var record_effect:AudioEffectRecord
var recording:AudioStream
@onready var audios = {}
var narrationMap={
	'B':'res://narrations/C_1.wav',
	'C_1':'res://narrations/C_1.wav',
	'C_2':'res://narrations/C_2.wav',
	'C_3':'res://narrations/C_3.wav',
	'D':'res://narrations/D.wav',
	'E_1':'res://narrations/E_1.wav',
	'E_2':'res://narrations/E_2.wav',
	'E_3':'res://narrations/E_3.wav',
	'E_4':'res://narrations/E_4.wav',
	'F_1':'res://narrations/F_1.wav',
	'F_2':'res://narrations/F_2.wav',
	'F_3':'res://narrations/F_3.wav',
	'F_4':'res://narrations/F_4.wav',
}
var bg_textures={
	'S1':'res://scenes/S1_img1.png',
	'S2':'res://scenes/S2_img1.png',
	'S3':'res://scenes/S3_img1.png',
	'HK_talk':'res://scenes/host_kid_talk.png',
	#'jungle_j1':'res://scenes/jungle_journey_1.png',
	#'jungle_j2':'res://scenes/jungle_journey_2.png',
	#'jungle_j3':'res://scenes/jungle_journey_3.png',
	'dragon_q':'res://scenes/dragon_s1.png', # Ai overlay
	'dragon_qf':'res://scenes/dragon_complete.png',
	'election_q':'res://scenes/election_s1.png', # Ai overlay
	'election_qf':'res://scenes/election_complete.png',
	'eq_q':'res://scenes/eq_s1.png', # Ai overlay
	'eq_qf':'res://scenes/eq_complete.png',
	'outro':'res://scenes/outro_s1.png'
}
var DialogueTitles = [
	'Start',
	'scene_2',
	'scene_3',
	'jungle_talk',
	#'jungle_qbegin',
	#'jungle_q2',
	#'jungle_q3',
	'dragon_qbegin',
	'dragon_qend',
	'election_qbegin',
	'election_qend',
	'eq_qbegin',
	'eq_qend',
	'game_end'
]
var Title2Bg = {
	'Start':'S1',
	'scene_2':'S2',
	'scene_3':'S3',
	'jungle_talk':'HK_talk',
	'jungle_qbegin':'jungle_j1',
	'jungle_q2':'jungle_j2',
	'jungle_q3':'jungle_j3',
	'dragon_qbegin':'dragon_q',
	'dragon_qend':'dragon_qf',
	'election_qbegin':'election_q',
	'election_qend':'election_qf',
	'eq_qbegin':'eq_q',
	'eq_qend':'eq_qf',
	'game_end':'outro'
}

var DindexToDiag={
	8:'dq_result',
	10:'election_result',
	12:'eq_result'
}
var dialogue_index = 4
func _ready():
	for i in narrationMap.keys():
		audios[i]=load(narrationMap[i])
	$Bg1.modulate.a=1
	SceneLoader.connect("retryAct",_onRetry)
	SceneLoader.connect("narrate",_narrate)
	DialogueManager.connect('dialogue_ended',_onDiagEnd)
	
	mic_container.modulate.a=0
	%Begin.self_modulate.a=0
	#%Record.self_modulate.a=0
	$AIcontainer.modulate.a=0
	mic_container.process_mode=Node.PROCESS_MODE_DISABLED
	print('Ready')
	animPlayer.play('title')
	menuMusic.play()
	record_bus_index=AudioServer.get_bus_index('Record')
	record_effect=AudioServer.get_bus_effect(record_bus_index,0)
	
	
#func _process(_delta):
	#var sample=AudioServer.get_bus_peak_volume_left_db(record_bus_index,0)
	#var linearSample=db_to_linear(sample)
	#volume_bar.value=linearSample
	#pass

func _on_animplayer_animation_finished(anim_name):
	#print(anim_name,reverse)
	if anim_name=="micTest":
		if !reverse:
			#print('Audio enabled')
			mic_container.process_mode=Node.PROCESS_MODE_INHERIT
	if anim_name=="title2scene1":
		#animPlayer.stop()
		DialogueManager.show_example_dialogue_balloon(dialogue_res,"start")

func _on_mic_button_pressed():
	#if animPlayer.is_playing() and animPlayer.current_animation=='title':return
	if animPlayer.is_playing():return
	if reverse:
		animPlayer.play_backwards('micTest')
		menuMusic.play()
		mic_container.process_mode=Node.PROCESS_MODE_DISABLED
		reverse=!reverse
		#print('AUdio disabled')
		return
	animPlayer.play("micTest")
	menuMusic.stop()
	reverse=!reverse


func _on_begin_pressed():
	if animPlayer.current_animation=='title':return
	animPlayer.play("title2scene1")
	


func _on_skip_btn_pressed():
	if dialogue_index in [5,7,9]:
		mic_container.process_mode=Node.PROCESS_MODE_DISABLED
		animPlayer.play_backwards("micTest")
	dialogue_index+=1
	var sname=Title2Bg[DialogueTitles[dialogue_index]]
	_transitionTo(sname)
	return
	SceneLoader.scene_name="res://wake_up.tscn"
	SceneLoader.load()

	
func _transitionTo(anim_name):
	#print('changing to ',anim_name)
	var tween = get_tree().create_tween()
	tween.stop()
	tween.tween_property(self,'modulate:a',0,1.2)
	tween.play()
	await tween.finished
	tween.stop()
	
	bg.texture=load(bg_textures[anim_name])
	#bg.call_deferred("set", "texture", ResourceLoader.load(bg_textures[anim_name]))
	
	bg.texture=ResourceLoader.load(bg_textures[anim_name])
	tween.tween_property(self,'modulate:a',1,1.5)
	tween.play()
	await tween.finished
	tween.stop()
	DialogueManager.show_example_dialogue_balloon(dialogue_res,DialogueTitles[dialogue_index])

func _onDiagEnd(diag):
	if narrator.playing:narrator.stop()
	if SceneLoader.act_result == 2 and dialogue_index in [5,7,9]:
		return
	dialogue_index+=1
	if dialogue_index == len(DialogueTitles) :return
	var sname=Title2Bg[DialogueTitles[dialogue_index]]
	if dialogue_index in [5,7,9]:
		JavaScriptBridge.call("eval","window.resetChat()")
		if dialogue_index == 5:
			JavaScriptBridge.call("eval","window.selectPrompt1()")
			print('Switched to dragon prompt')
		elif dialogue_index == 7:
			JavaScriptBridge.call("eval","window.selectPrompt2()")
			print('Switched to election prompt')
		else:
			JavaScriptBridge.call("eval","window.selectPrompt3()")
			print('Switched to EQ prompt')
		# entry animation
		animPlayer.play("micTest")
		await  animPlayer.animation_finished
		banim.play("greet")
		return
	_transitionTo(sname)
	return
	
func _on_convo_ended():
	mic_container.process_mode=Node.PROCESS_MODE_DISABLED
	#exit animation
	banim.play("greet")
	await  banim.animation_finished
	animPlayer.play_backwards("micTest")
	await  animPlayer.animation_finished
	JavaScriptBridge.call("eval","window.send_log()")
	#Handle the dialogue based on the acts, c
	DialogueManager.show_example_dialogue_balloon(dialogue_res,DindexToDiag[dialogue_index])
	#dialogue_index+=1
	#var sname=Title2Bg[DialogueTitles[dialogue_index]]
	#_transitionTo(sname)
	
func _onRetry():
	JavaScriptBridge.call("eval","window.resetChat()")
	#SceneLoader.act_result = 6
	#print("retrying current act")
	animPlayer.play("micTest")
	await  animPlayer.animation_finished
	banim.play("greet")

func _narrate(part):
	if narrator.playing:
		narrator.stop()
	narrator.stream= audios[part]
	narrator.play()
