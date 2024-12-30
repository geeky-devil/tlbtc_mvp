import SpeechRecognizer from "./speechRecognizer.js";
//import { resetChat } from "./conversation.js";

// Create a namespace for your project
window.TLBTC = window.TLBTC || {};

const speechRecognizer = new SpeechRecognizer();
window.TLBTC.speechRecognizer = speechRecognizer;

//window.resetChat = resetChat;

//let retryId;

//let visemesReceived = false;

//window.initializeTTS = initializeTTS;
//window.playViseme = playViseme;

//let aiResponse = "";

//let ttsState = 'idle'; //unused

//window.ttsState = ttsState;
//window.aiResponse = '';

//window.send_log = send_log;
//window.getResponse = getResponse;
//window.selectPrompt1 = selectPrompt1;
//window.selectPrompt2 = selectPrompt2;