# Character Class
class Character:
	extends Object  

	var name: String
	var voice: AudioStream
	var face_animations: Dictionary

	func _init(name: String, voice: AudioStream, face_animations: Dictionary):
		self.name = name
		self.voice = voice
		self.face_animations = face_animations

# GameConfig
class GameConfig
	extends Object

	var scenes: Array

	func _init(scenes: Array):
		self.scenes = scenes

# Scene Class
class Scene:
	extends Object  

	var scene_id: int
	var components: Array

	func _init(scene_id: int, components: Array):
		self.scene_id = scene_id
		self.components = components


# SceneComponent Class
class SceneComponent:
	extends Object 

	const CONTEXT_PROMPT: String = ""
	const EMOTION_PROMPT: String = ""
	const CHARACTER_PROMPT: String = ""

	var narration: Array
	var background: Background
	var conversation: Conversation

	func _init(narration: Array, background: Background, conversation: Conversation):
		self.narration = narration
		self.background = background
		self.conversation = conversation


# Narration Class
class Narration:
	extends Object 

	var audio: AudioStream
	var transcript: String
	var character: Character

	func _init(audio: AudioStream, transcript: String, character: Character):
		self.audio = audio
		self.transcript = transcript
		self.character = character


# Background Class
class Background:
	extends Object  

	var music: AudioStream
	var art: VideoStream

	func _init(music: AudioStream, art: VideoStream):
		self.music = music
		self.art = art


# Conversation Class
class Conversation:
	extends Object  

	var prompt: String
	var characters: Array

	func _init(prompt: String, characters: Array):
		self.prompt = prompt
		self.characters = characters
