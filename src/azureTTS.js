import { frame_dict, viseme_dict } from "./visemeMaps.js"; // If you have a visemeMaps file

let speechConfig;
let synthesizer;
let visemeArr = [];
let currentViseme = 1;

function initializeTTS(key) {
	// Azure Speech Service credentials
	const subscriptionKey = String(key);
	const region = "eastus";

	// Initialize Speech SDK configuration
	speechConfig = SpeechSDK.SpeechConfig.fromSubscription(subscriptionKey, region);
	speechConfig.speechSynthesisOutputFormat = SpeechSDK.SpeechSynthesisOutputFormat.Audio24Khz160KBitRateMonoWithMetadata;
	console.log('config_done');
}

// Function to handle speech synthesis
function generateSpeech(text) {
	if (!text) return;
	visemeArr = [];
	//console.log('cleard old visemes',visemeArr);

	// SSML for speech synthesis
	const ssml = `<speak version='1.0' xml:lang='en-US' xmlns='http://www.w3.org/2001/10/synthesis' xmlns:mstts='http://www.w3.org/2001/mstts'> \\r\\n \\
				<voice name='en-US-JennyNeural'> \\r\\n \\
					<mstts:viseme type='redlips_front'/> \\r\\n \\
					${text} \\r\\n \\
					</voice> \\r\\n \\
					</speak>`;

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

function testSample() {
	timeStamps.forEach(v => {
		var duration = v[1];
		setTimeout(() => {
			currentViseme = frame_dict[viseme_dict[v[0]]];
			console.log(currentViseme);
		}, duration);
	})
}

async function playViseme() {
	console.log("Starting Viseme anims");
	var index = 0;
	visemeArr.forEach(v => {
		var duration = v[1];
		setTimeout(() => {
			index++;
			window.ttsState = 'Speaking';
			currentViseme = frame_dict[viseme_dict[v[0]]];
			//console.log(currentViseme,viseme_dict[v[0]]);
			if (index == visemeArr.length) {
				window.ttsState = "idle";
				currentViseme = 1;
				if (state == 1 || state == 2) window.act_over = true;
				else {
					emotion = 'neutral';
				}
			}

		}, duration);
	});
	//console.log(visemeArr);
}

export { initializeTTS, generateSpeech, playViseme };