class SpeechRecognizer {
    constructor() {
        this.recognizedText = "";
        this.recognitionState = ""; //Merge this with isListening
        this.isListening = false

        this.recognition = new (window.SpeechRecognition || window.webkitSpeechRecognition)();
        this.recognition.lang = "en-US";
        this.recognition.continuous = true;
        this.recognition.interimResults = true;

        this.setupRecognitionHandlers();
		this.setupMicrophone();
    }

    async setupMicrophone() {
        try {
            const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
            this.mediaRecorder = new MediaRecorder(stream);

            this.mediaRecorder.ondataavailable = (event) => {
                this.audioChunks.push(event.data);
            };

            this.mediaRecorder.onstop = () => {
                this.audioBlob = new Blob(this.audioChunks, { 'type': 'audio/wav; codecs=opus' });
                this.audioURL = URL.createObjectURL(this.audioBlob);
                this.audioChunks = [];
            };

            console.log("Microphone setup complete.");
        } catch (error) {
            console.error("Error accessing microphone:", error);
        }
    }

    setupRecognitionHandlers() {
        this.recognition.onstart = () => {
            console.log("Speech recognition started");
            this.recognitionState = 'listening';
        };

        this.recognition.onend = () => {
            console.log("Speech recognition ended");
            this.recognitionState = 'idle';
            // If Button is still held down
            if (this.isListening) this.recognition.start();
        };

        this.recognition.onresult = (event) => {
            this.recognizedText = ""; // Clear previous results for fresh display
            for (let i = 0; i < event.results.length; i++) {
                this.recognizedText += event.results[i][0].transcript;
            }
            console.log("Recognized Text (real-time):", this.recognizedText);
            window.recognizedText = this.recognizedText;
        };

        this.recognition.onerror = (event) => {
            console.error("Speech recognition error:", event.error);
            this.recognitionState = 'error';
        };
    }

    startListening() {
        this.recognition.start();
		this.isListening = true;
    }

    stopListening() {
        this.recognition.stop();
        this.isListening = false;
    }

    getRecognizedText() {
        return this.recognizedText;
    }
}

export default SpeechRecognizer;