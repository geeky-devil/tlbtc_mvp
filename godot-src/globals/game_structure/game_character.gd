# Character Class
class_name GameCharacter

extends Object  

var name: String
var voice: String
var face_animations: GameCharacterAnimations

func _init(name: String, voice: String, face_animations: GameCharacterAnimations):
	self.name = name
	self.voice = voice
	self.face_animations = face_animations
