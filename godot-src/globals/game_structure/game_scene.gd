# Scene Class
class_name GameScene

extends Object  

var scene_id: String
var components: Array[SceneComponent]

func _init(scene_id: String, components: Array[SceneComponent]):
	self.scene_id = scene_id
	self.components = components
