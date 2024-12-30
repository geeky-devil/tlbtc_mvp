import { generateSpeech } from "./azureTTS.js";
import { contextPrompt, emotionPrompt, prompts, prompt_index} from "./prompts.js"

//state 0 : The conversation has NOT finished.
//state 1 : The child successfully completes the activity and the conversation is over.
//state 2 : The child failes/denies to participate and the conversation is over.
let state = 0;

// listening, thinking, talking_encouraging, tlaking_approving, talking_disapproving
let emotion = 'neutral';

let msgs = [];
let transcript = ''
const models = ['llama-3.3-70b-versatile', 'llama3-70b-8192', 'llama-3.1-8b-instant', 'llama3-8b-8192'];

// This is how the chaining will work
// full_prompt = contextPrompt  + transcript + emotionPrompt
// after each conversation append msgs to transcript

// Call llm via fetch
async function getResponse(key) {
    var url = "https://api.groq.com/openai/v1/chat/completions";
    var model = models[0];
    const api_key = String(key);
    var txt = window.recognizedText;
    msgs.push({ role: "user", content: txt });
    //console.log("received key",api_key);
    try {
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${api_key}`,
                'Connection': 'keep-alive',
                'Cache-Control': 'max-age=1000',
                'Access-Control-Max-Age': 3000,
                'Max-Age': 4000,
            },
            body: JSON.stringify({
                model: model,
                messages: [
                    {
                        role: "system",
                        content: contextPrompt + transcript + prompts[prompt_index] + emotionPrompt
                    },
                    ...msgs
                ],
                max_tokens: 1024,
                response_format: { "type": "json_object" },
                stream: false,
            })
        });
        const data = await response.json();

        if (response.ok) {
            console.log('Response OK')
            window.aiResponse = "";
            try {
                const message = data.choices[0].message;
                const generatedJson = JSON.parse(data.choices[0].message.content);
                console.log("Generated text:", generatedJson);
                window.aiResponse = generatedJson.text;
                emotion = generatedJson.emotion.toLowerCase();
                state = generatedJson.state;
                console.log('emotion', emotion);
                console.log('text', window.aiResponse);
                console.log('state', generatedJson.state);
                msgs.push({ role: "assistant", content: window.aiResponse });
                if (state == 1) {
                    transcript += '\n' + prompts[prompt_index] + JSON.stringify(...msgs) + '\n';
                    console.log(transcript);
                    console.log(contextPrompt + JSON.parse(transcript) + prompts[prompt_index] + emotionPrompt) //to do
                }

            } catch (e) {
                console.warn("response is stuctured differently", e);
            }

        }
        else {
            console.log('error', response,);
        }

    } catch (error) {
        console.error('Error calling llm', error.message, window.recognizedText);
    } finally {
        //window.aiResponse=window.aiResponse.replace(/[?!]/g, '.');
        generateSpeech(window.aiResponse);

    }
}

function testTTS(text) {
    generateSpeech(text);
}

function chat(text) {
    window.recognizedText = text;
    getResponse('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');
}

function resetChat() {
    window.aiResponse = '';
    msgs = [];
    state = 0;
    window.state = state;
    window.act_over = false;
    emotion = 'neutral';
    window.recognizedText = '';
    console.log('Chat reset');
}

export {
    getResponse,
    resetChat,
    //setRecognizedText,
    // ...other conversation-related exports
  };