extends Node
signal startAct
signal retryAct
signal narrate
var scene_name
var status=0
var progress=[]
var bar=null
var current_scene=null
var loading=preload("res://loading.tscn").instantiate()
var tween
var act_result = 2
var scenes = {
	'wakeUp' : "res://wake_up.tscn",
	'main' : "res://main.tscn",
}

func _ready():
	#await DialogueManager.ready
	#DialogueManager.connect('dialogue_ended',_onDialogueEnd)
	set_process(false)
	set_process_input(false)
func load(name='NONE'):
	if name!='NONE' :
		scene_name=scenes[name]
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	tween= get_tree().create_tween()
	tween.stop()
	tween.tween_property(current_scene,'modulate',Color(0,0,0,0),1)
	tween.play()
	await  tween.finished
	root.remove_child(current_scene)
	current_scene.queue_free()
	root.add_child(loading)
	#bar=root.get_child(1).get_node("Bar")
	ResourceLoader.load_threaded_request(scene_name)
	set_process(true)
func  _process(_delta):
	status=ResourceLoader.load_threaded_get_status(scene_name,progress)
	#bar.value=int(progress[0]*100)
	if status==ResourceLoader.THREAD_LOAD_LOADED:
		var newScene=ResourceLoader.load_threaded_get(scene_name)
		set_process(false)
		get_tree().root.remove_child(loading)
		get_tree().change_scene_to_packed(newScene)
		reset()
	if status==ResourceLoader.THREAD_LOAD_FAILED:
		set_process(false)
	if status==ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
		set_process(false)
func reset():
	scene_name=null

func retryOrStartAct():
	print('act_reset')
	startAct.emit()
