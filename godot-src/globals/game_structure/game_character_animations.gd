# Character Class
class_name GameCharacterAnimations

extends Object  

var idle: String
var listening: String
var thinking: String
var talking_approving: String
var talking_encouraging: String
var talking_dissapproving: String

func _init(idle: String, listening: String, thinking: String, talking_approving: String, talking_encouraging: String, talking_dissapproving: String):
	self.idle = idle
	self.listening = listening
	self.thinking = thinking
	self.talking_approving = talking_approving
	self.talking_encouraging = talking_encouraging
	self.talking_dissapproving = talking_dissapproving
