extends Control
@onready var micButton=$MicButton
@onready var animPlayer=$AnimationPlayer
@onready var menuMusic=$AudioStreamPlayer2D
@onready var volume_bar=$MicContainer/VolumeBar
@onready var volume_txt=$MicContainer/VolumeText
@onready var mic_container=$MicContainer
@onready var audio_out=$micOutput
var reverse=false
var record_bus_index:int
var record_effect:AudioEffectRecord
var recording:AudioStream
func _ready():
	mic_container.modulate.a=0
	mic_container.process_mode=Node.PROCESS_MODE_DISABLED
	print('ready')
	animPlayer.play('title')
	menuMusic.play()
	record_bus_index=AudioServer.get_bus_index('Record')
	record_effect=AudioServer.get_bus_effect(record_bus_index,0)
	
	
func _process(_delta):
	var sample=AudioServer.get_bus_peak_volume_left_db(record_bus_index,0)
	var linearSample=db_to_linear(sample)
	volume_bar.value=linearSample
	volume_txt.text='%s db'%round(sample)

func _on_animplayer_animation_finished(anim_name):
	print(anim_name,reverse)
	if anim_name=="micTest":
		if reverse:
			print('AUdio enabled')
			mic_container.process_mode=Node.PROCESS_MODE_INHERIT
			

func _on_mic_button_pressed():
	#if animPlayer.is_playing() and animPlayer.current_animation=='title':return
	if animPlayer.is_playing():return
	if reverse:
		animPlayer.play_backwards('micTest')
		menuMusic.play()
		mic_container.process_mode=Node.PROCESS_MODE_DISABLED
		reverse=!reverse
		print('AUdio disabled')
		return
	animPlayer.play("micTest")
	menuMusic.stop()
	reverse=!reverse
	
func start_recording():
	record_effect.set_recording_active(true)
func stop_recording():
	record_effect.set_recording_active(false)
	recording=record_effect.get_recording()
	audio_out.stream=recording
	#audio_out.play()


func _on_record_pressed():
	print('record pressed')
	if record_effect.is_recording_active():
		stop_recording()
		%Record.text='Record'
	else:
		%Record.text='Stop'
		start_recording()


func _on_play_pressed():
	audio_out.play()
