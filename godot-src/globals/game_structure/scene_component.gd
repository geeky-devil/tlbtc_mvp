# SceneComponent Class
class_name SceneComponent

extends Object 

const CONTEXT_PROMPT: String = ""
const EMOTION_PROMPT: String = ""
const CHARACTER_PROMPT: String = ""

var narrations: Array[SceneNarration]
var background: SceneBackground
var conversation: SceneConversation

func _init(narration: Array[SceneNarration], background: SceneBackground, conversation: SceneConversation):
	self.narration = narration
	self.background = background
	self.conversation = conversation
