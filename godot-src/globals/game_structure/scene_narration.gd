# Narration Class
class_name SceneNarration

extends Object 

var transcript: String
var character: GameCharacter

func _init(transcript: String, character: GameCharacter):
	self.transcript = transcript
	self.character = character
