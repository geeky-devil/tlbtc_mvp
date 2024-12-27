extends Node2D
@onready var path = $Path2D/PathFollow2D
@onready var cursor = $Path2D/PathFollow2D/cursor

@export var coordinates = {
	'dragon': 0.3315,
	'cave' : 0.5815
}
var tween
var forward = true

func _ready():
	path.progress_ratio=0
	tween = get_tree().create_tween()
	tween.stop()
	appear()
	#moveTo('dragon')
func moveTo(place:String):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.stop()
	var coordinate = coordinates[place]
	tween.tween_property(path,"progress_ratio",coordinate,1)
	
	tween.play()
	await tween.finished

func appear():
	tween.tween_property(cursor,"scale",Vector2(.3,.3),0.3)
	tween.play()
	await tween.finished
	tween.stop()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		path.progress_ratio=0
		#moveTo('dragon')
		moveTo('cave')
