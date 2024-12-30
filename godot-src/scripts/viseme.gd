extends Node2D
@onready var anim=$AnimationPlayer
@onready var anim_tree=$AnimationTree
@onready var banim=$BodyAnim
@export var speed:float = 1.0
var lastAnim = 'idle'
var window
var dis_amount = 0
var sad_amount = 0
var currAnim = 'idle'
var emo2anim = {
	'sad':'sad',
	'encouraging':'surp',
	'disapproving':'dis',
	'neutral':'idle',
	'approving':'surp'
}
func _ready():
	SceneLoader.connect('retryAct',resetAnims)
	SceneLoader.connect('startAct',resetAnims)
	#var anims=$AnimationPlayer.get_animation_list()
	#for i in range(len(anims)):
		#for j in range(i+1,len(anims)):
			#$AnimationPlayer.set_blend_time(anims[i],anims[j],0.1)
	if OS.is_debug_build():
		print('DEBUG MODE')
		set_process(false)
		return
	window=JavaScriptBridge.get_interface("window")
func _process(delta):
	%lips.frame = JavaScriptBridge.call("eval","currentViseme;")
	%AIResponse.text=window.aiResponse
	%emotion.text=JavaScriptBridge.call("eval","emotion;")
	currAnim = emo2anim[JavaScriptBridge.call("eval","emotion;")]
	if !currAnim : return
	if currAnim == lastAnim :
		return
	#print('playing animation',currAnim,lastAnim)
	playAnim(currAnim)
	#anim_tree['parameters/dis/blend_amount'] = dis_amount
	#anim_tree['parameters/sad/blend_amount'] = sad_amount

func playAnim(aname):
	var tween = get_tree().create_tween().set_parallel(true)
	tween.stop()
	if aname=='idle':
		tween.tween_property(anim_tree,"parameters/%s/blend_amount" %lastAnim,0,speed)
		tween.play()
		lastAnim = 'idle'
		return
	if lastAnim == 'idle':
		tween.tween_property(anim_tree,"parameters/%s/blend_amount" %aname,1,speed)
		tween.play()
		lastAnim = aname
		return
	else:
		tween.tween_property(anim_tree,"parameters/%s/blend_amount" %lastAnim,0,speed)
		tween.tween_property(anim_tree,"parameters/%s/blend_amount" %aname,1,speed)
		tween.play()
		lastAnim = aname
	await tween.finished

func playIdle():
	var tween = get_tree().create_tween()
	tween.stop()
	tween.tween_property(anim_tree,"parameters/%s/blend_amount" %lastAnim,0,speed)
	#tween.tween_property(anim_tree,"parameters/%s/blend_amount" %aname,1,1)
	tween.play()
	#lastAnim = 'idle'
	
func _on_button_pressed():
	playAnim('sad')


func _on_dis_pressed():
	playAnim('dis')


func _on_idle_pressed():
	playAnim('idle')


func _on_surp_pressed():
	playAnim('surp')


func _on_greet_pressed():
	#banim.play("greet")
	banim.play("greet")

func resetAnims():
	playAnim('idle')
	lastAnim = 'dis'
	#JavaScriptBridge.call("eval","window.resetChat()")
	set_process(true)
