class GameOrchestrator:
	extends Object  

	func _start():


"""
TO - DO
speechRecognizer.startListeningStop listening
		Set dialogue state


		Prompt handler call
		start conversation
		response = add turn()

		// you have text

		await (generateViseme(text), generateAudio(text))


		generateSpeech(window.aiResponse);
			speechsyntesizer (playViseme())

"""     
#Global variables 
var UserPrompt = 'xyz'
var SystemPromt = ''

class speechHandler:
	var _diaogueState:String = 'idle' # TTS state
	
	func _startListening():
		JavaScriptBridge.call("eval", "window.TLBTC.speechRecognizer.startListening();")
	func _stopListening():
		JavaScriptBridge.call("eval", "window.TLBTC.speechRecognizer.stopListening();")
	func _getRecognizedText():
		#TODO: check how recognized text is stored
		# This text will used as user prompt
		#GameOrchestrator.UserPrompt = 'RandomStuff'
		print(self.UserPrompt)
		pass

class promptHandler:
	var contextPrompt = ''
	var emotionPrompt = ''
	var transcript= ''
	var currentPrompt = ''
	func _init():
		#TODO: get prompts from prompts.js or declare here itself
		var contextPrompt = ''
		var emotionPrompt = ''
		var transcript= ''
		
	var systemPrompt = self.contextPrompt + self.transcript + self.currentPrompt + self.emotionPrompt
	
	
	func _getSystemPrompt():
		return systemPrompt
	func _getUserPrompt():
		pass

func _init():
	speechHandler.new()._getRecognizedText()
 



		
