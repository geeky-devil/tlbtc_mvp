// Store ip addr
window.onload = () => {
	fetch('https://api.ipify.org?format=json')
		.then(response => response.json())
		.then(data => {
			console.log('Client Public IP Address:', data.ip);
			window.ip = data.ip;
		})
		.catch(error => {
			console.error('Error fetching IP:', error);
		});
}

async function send_log() {
	const log = JSON.stringify({ ip: window.ip || 'anon', data: msgs });
	try {

		const res = await fetch('http://127.0.0.1:9000/log', {
			//mode:'no-cors',
			method: 'POST',
			headers: {
				'Content-Type': 'application/json',
			},
			body: log + '\r\n',
		})
		if (res.ok || res.status == 200) {
			console.log(res.status)
			console.log('Logged');
		}
		else {
			console.log(res.status)
			throw Error('Other issue');
		}


	}
	catch (e) {
		console.warn("Server error, saving locally", e);
		save_log(log);
		if (retryId) {
			console.log('Already retrying..')
			return;
		}
		retryId = setInterval(() => {
			console.log('Error relogging, retrying in 30');
			resend_logs();
		}, 30000);
	}
	finally {
		console.log('clearing chats');
		resetChat();
	}
}

function save_log(data) {
	localStorage.setItem(Date.now() + Math.random(), data);
	console.log("saved_locally");
}

async function resend_logs() {
	var log = [];
	const keys = Object.keys(localStorage);
	keys.forEach(key => {
		log.push(JSON.parse(localStorage[key]));
	})
	try {

		const res = await fetch('http://127.0.0.1:9000/log', {
			method: 'POST',
			headers: {
				'Access-Control-Allow-Origin': true,
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({ multi: log }),
		})
		if (res.ok || res.status == 200) {
			console.log('Logged, clearing storage');
			localStorage.clear();
			clearInterval(retryId);
			retryId = null;
		}
		else throw Error('Other issue');

	}
	catch (e) {
		console.warn(e, "retrying...");
	}

}