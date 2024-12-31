import { frame_dict, viseme_dict } from "./visemeMaps.js"; // If you have a visemeMaps file

let synthesizer; //global variable

function initializeTTS(key) {
	// Azure Speech Service credentials
	const subscriptionKey = String(key);
	const region = "eastus";

	// Initialize Speech SDK configuration
	let speechConfig = SpeechSDK.SpeechConfig.fromSubscription(subscriptionKey, region);
	speechConfig.speechSynthesisOutputFormat = SpeechSDK.SpeechSynthesisOutputFormat.Audio24Khz160KBitRateMonoWithMetadata;
	console.log('config_done');

	synthesizer = new SpeechSDK.SpeechSynthesizer(speechConfig);

	// Attach event listeners
	synthesizer.visemeReceived = (s, e) => {
		const visemeId = e.visemeId;
		const timestamp = e.audioOffset / 10000; // Convert nanoseconds to milliseconds
		visemeArr.push([visemeId, timestamp]);
		console.log(`Viseme: ${visemeMap[visemeId] || "Unknown"} (ID: ${visemeId}), Timestamp: ${timestamp}ms`);
	};

	synthesizer.synthesisStarted = () => console.log("Synthesis started...");
	synthesizer.synthesisCompleted = () => {
		console.log("Synthesis completed.");
		synthesizer.close(); // Clean up
	};
}

class faceGenerator {
	constructor() {
		window.TLBTC.currentViseme = 0;
		window.TLBTC.visemeArr = [];
	}

	// Function to handle speech synthesis
	generate(text) {
		if (!text) return;

		// SSML for speech synthesis
		const ssml = `<speak version='1.0' xml:lang='en-US' xmlns='http://www.w3.org/2001/10/synthesis' xmlns:mstts='http://www.w3.org/2001/mstts'> \\r\\n \\
				<voice name='en-US-JennyNeural'> \\r\\n \\
					<mstts:viseme type='redlips_front'/> \\r\\n \\
					${text} \\r\\n \\
					</voice> \\r\\n \\
					</speak>`;

		synthesizer.speakSsmlAsync(
			ssml,
			(result) => {
				if (result.reason === SpeechSDK.ResultReason.SynthesizingAudioCompleted) {
					console.log("Speech synthesis succeeded.");
				} else {
					console.error("Speech synthesis failed:", result.errorDetails);
				}
			},
			(error) => console.error("Error during synthesis:", error)
		);
	}
}

function testSample() {
	timeStamps.forEach(v => {
		var duration = v[1];
		setTimeout(() => {
			currentViseme = frame_dict[viseme_dict[v[0]]];
			console.log(currentViseme);
		}, duration);
	})
}

// Needs to be global due to the way it is called by the speechSDK. Ensures that viseme is only played once audio starts.
window.TLBTC.playViseme = () => {
	console.log("Starting Viseme anims");
	var index = 0;
	window.TLBTC.visemeArr.forEach(v => {
		var duration = v[1];
		setTimeout(() => {
			index++;
			window.TLBTC.currentViseme = frame_dict[viseme_dict[v[0]]];
			//console.log(window.TLBTC.currentViseme,viseme_dict[v[0]]);
			if (index == window.TLBTC.visemeArr.length) {
				window.TLBTC.currentViseme = -1;
				window.TLBTC.dialogue_state = 'idle'
			}
		}, duration);
	});
	//console.log(visemeArr);
}

export { initializeTTS, faceGenerator};