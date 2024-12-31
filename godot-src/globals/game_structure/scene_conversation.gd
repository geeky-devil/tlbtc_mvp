# SceneConversation Class
class_name SceneConversation
extends Object  

var prompt: String
var characters: Array[GameCharacter]

func _init(prompt: String, characters: Array[GameCharacter]):
	self.prompt = prompt
	self.characters = characters
