extends Node

class GameCharacters:
	extends Object

	static var NARRATOR: GameCharacter
	static var ASTRO: GameCharacter
	static var LION: GameCharacter
	static var MONKEY: GameCharacter
	static var FOX: GameCharacter
	static var OWL: GameCharacter

	static func _static_init():
		NARRATOR = GameCharacter.new(
			"Narrator",
			"res://path_to_voice.ogg",
			GameCharacterAnimations.new("a", "b", "c", "d", "e", "f")
		)

		ASTRO = GameCharacter.new(
			"Astro",
			"res://path_to_voice.ogg",
			GameCharacterAnimations.new("idle1", "listen1", "think1", "approve1", "encourage1", "disapprove1")
		)

		LION = GameCharacter.new(
			"Lion",
			"res://path_to_voice.ogg",
			GameCharacterAnimations.new("idle2", "listen2", "think2", "approve2", "encourage2", "disapprove2")
		)

		MONKEY = GameCharacter.new(
			"Monkey",
			"res://path_to_voice.ogg",
			GameCharacterAnimations.new("idle3", "listen3", "think3", "approve3", "encourage3", "disapprove3")
		)

		FOX = GameCharacter.new(
			"Fox",
			"res://path_to_voice.ogg",
			GameCharacterAnimations.new("idle4", "listen4", "think4", "approve4", "encourage4", "disapprove4")
		)

		OWL = GameCharacter.new(
			"Owl",
			"res://path_to_voice.ogg",
			GameCharacterAnimations.new("idle5", "listen5", "think5", "approve5", "encourage5", "disapprove5")
		)

static var GAME_CONFIG: GameConfig

static func _static_init():
	GAME_CONFIG = GameConfig.new([
		GameScene.new("A", [
			SceneComponent.new(
				[SceneNarration.new(
					"Opening narration",
					Globals.GameCharacters.NARRATOR
					)
				],
				SceneBackground.new(AudioStream.new(), VideoStream.new()),
				SceneConversation.new("Welcome to the journey!", [Globals.GameCharacters.ASTRO])
			)
		]),
		GameScene.new("B", [
			SceneComponent.new(
				[SceneNarration.new(
					"Opening narration",
					Globals.GameCharacters.NARRATOR
					)
				],
				SceneBackground.new(AudioStream.new(), VideoStream.new()),
				SceneConversation.new("Welcome to the journey!", [Globals.GameCharacters.ASTRO])
			)
		]),
		GameScene.new("C", [
			SceneComponent.new(
				[SceneNarration.new(
					"Opening narration",
					Globals.GameCharacters.NARRATOR
					)
				],
				SceneBackground.new(AudioStream.new(), VideoStream.new()),
				SceneConversation.new("Welcome to the journey!", [Globals.GameCharacters.ASTRO])
			)
		]),
	])
