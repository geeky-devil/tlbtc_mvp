extends HTTPRequest

var api_key
var body
var text
var url
var header
var window
var callback=JavaScriptBridge.create_callback(_onCallback)
func _ready():
	var file = FileAccess.open("res://env.txt", FileAccess.READ)
	var content = file.get_as_text()
	var contentSplit=content.split("=")
	api_key=contentSplit[1]
	file.close()
	#Handling api calls in js
	window=JavaScriptBridge.get_interface('window')
	url="https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=%s" %api_key
	var requestCode="""
	let aiResponse = '';
	async function getResponse(url){
		var txt=recognizedText;
		try {
		const response = await fetch(url, {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({
				contents: [{
					parts: [{
						text: txt
					}]
				}]
			})
		});
		const data = await response.json();
			if (response.ok){
				aiResponse='';
				const generatedText = data.candidates[0].content.parts[0].text;
				console.log("Generated text:", generatedText);
				aiResponse=generatedText;
				window.aiResponse=aiResponse;
				return generatedText;
			}
			else {
				console.log(URL,response.body,text);
				//throw new Error (`Response Status :${response.status}`);
			}
			const json = await response.json();
		} catch(error){
			console.error(error.message);
		}
	}
	window.getResponse=getResponse; 
	window.aiResponse=aiResponse;
	"""
	JavaScriptBridge.call("eval",requestCode)
	
func _on_send_pressed():
	text=%STTresponse.text
	%STTresponse.clear()
	if text=='' or text=="Awaiting Response...":
		print("No text to send")
		return
	%AIstate.text='thinking'
	window.getResponse(str(url)).then(callback)
	
func _onCallback(args):
	print('callbackworking')
	window.speak()
	%AIResponse.text=window.aiResponse
