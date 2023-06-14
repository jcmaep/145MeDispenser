const express = require("express");
// const SerialPort = require('serialport');
// const arduinoUrl = 'http://192.168.5.2/arduino';

// initialize firebase admin sdk
const admin = require("firebase-admin");
const serviceAccount = require("./medispenser-c25fb-firebase-adminsdk-yzb5c-d256f125fc.json");

admin.initializeApp({
	credential: admin.credential.cert(serviceAccount),
	databaseURL: "https://medispenser-c25fb.firebaseio.com",
});

const db = admin.firestore();

const app = express();
const PORT = process.env.PORT || 3000;
var ipDict = {};

app.use(express.json());

// Endpoint to fetch prescription data
app.get("/", async (req, res) => {
	try {
		// Retrieve prescription data from Firestore
		const snapshot = await db.collection("medicine-prescription").get();
		const prescriptions = [];

		// Extract relevant data from snapshot
		snapshot.forEach((doc) => {
			const prescription = doc.data();
			prescription.id = doc.id;
			prescriptions.push(prescription);
		});

		// Generate HTML output
		let htmlOutput = "<html><body><h1>Prescriptions</h1>";
		htmlOutput += "<ul>";
		prescriptions.forEach((prescription) => {
			htmlOutput += `
            <li>${prescription.id}
                <ul>
                    <li>${prescription.patientName}</li>
                    <li>${prescription.machineID}</li>
                    <li>${prescription.medicineName}</li>
                    <li>${prescription.intakeInterval}</li>
                    <li>${prescription.intakeTimes}</li>
                </ul>
            </li>`;
		});
		htmlOutput += "</ul></body></html>";

		// Send HTML response
		res.send(htmlOutput);
	} catch (error) {
		console.error("Error fetching prescriptions:", error);
		res.status(500).send("Error fetching prescriptions");
	}
});

// Start the server
app.listen(PORT, () => {
	console.log(`Server is listening on port ${PORT}`);
});

app.post("/ipaddr", (req, res) => {
	const ipAddr = req.headers["x-forwarded-for"]; //|| // For typical proxy setups
	// req.headers["x-real-ip"] || // For Nginx proxy setup
	// req.socket.remoteAddress; // Fallback to remote address

	const machineID = req.body.machineID;

	console.log("IP address of machine: " + ipAddr);
	console.log("Machine ID: " + machineID);

	ipDict[machineID] = ipAddr;
	console.log(ipDict);
});

// Post request from Arduino, when pills are successfully dispensed.
app.post("/test", (req, res) => {
	console.log(
		"Received POST request from Arduino: from " +
			req.headers["x-forwarded-for"] +
			" with body: " +
			JSON.stringify(req.body)
	);
	console.log(req.body);
	let json = req.body;
	console.log(json);
	// Get the decimal IP address
	//let machineID = json.MachineID;
	let json_response = {
		command: "dispense",
		message: req.headers["x-forwarded-for"].slice(5),
	};

	console.log(json_response);
	console.log(req.headers["x-forwarded-for"]);
	//console.log(`Input received: ${machineID}`);
	res.send(req.body);
});

// Loop to check database data, then send dispensing signal to Arduino if timestamp is == current time
setInterval(async () => {
	//Get updated database
	const snapshot = await db.collection("medicine-prescription").get();
	const currentTime = Date.now();
	// console.log(currentTime);

	snapshot.forEach(async (doc) => {
		const prescription = doc.data();
		const nextIntakeTimeMillis = prescription.nextIntakeTime.toMillis();

		if (currentTime >= nextIntakeTimeMillis) {
			if (prescription.intakeTimes === 0) {
				// continue;
			} else {
				const lastIntakeTime = prescription.nextIntakeTime.toMillis();
				console.log("Last intake: " + Date(lastIntakeTime));
				console.log("Interval: " + prescription.intakeInterval * 3600000);
				const newDateMillis =
					lastIntakeTime + prescription.intakeInterval * 3600000;
				// console.log("Next intake: " + newDateMillis);
				// console.log(prescription.nextIntakeTime);

				changeTime(admin.firestore.Timestamp.fromMillis(newDateMillis), doc.id);
				// // Arduino dispenses - START
				// // Assuming arduino sensed a hand
				// const arduinoCommand = {
				// 	command: "dispense",
				// 	machineID: prescription.machineID,
				// };
				// // Convert the arduinoCommand object to JSON string
				// const commandString = JSON.stringify(arduinoCommand);

				// // Send the command to the Arduino using SerialPort
				// const port = new SerialPort("COM1", { baudRate: 9600 }); // Replace "COM1" with the appropriate port name
				// port.write(commandString, (err) => {
				// 	if (err) {
				// 		console.error("Error writing to serial port:", err);
				// 	} else {
				// 		console.log("Dispensing signal sent to Arduino.");
				// 	}

				// 	// Close the serial port
				// 	port.close();
				// });
				// // Arduino dispenses - END

				// console.log("LastIntakeTime " + lastIntakeTime + "\n" + "Interval Time: " + prescription.intakeInterval * 3600000)
				// console.log("NextIntakeTime " + nextIntakesss);

				// Update IntakeTimes
				prescription.intakeTimes;
			}
		}
	});
}, 1000);

// Timestamp mechanism, push notification if missed

function decimalToOctet(decimalIP) {
	const octetArr = [];

	for (let i = 0; i < 4; i++) {
		const octet = decimalIP & 255; // Extract the last 8 bits
		octetArr.unshift(octet.toString()); // Prepend octet to the array
		decimalIP = decimalIP >> 8; // Shift right by 8 bits
	}

	return octetArr.join(".");
}

function changeTime(timestamp, uniqueId) {
	const db = admin.firestore();

	// Get a reference to the document using the unique ID
	const docRef = db.collection("medicine-prescription").doc(uniqueId);

	// Update the timestamp field with the provided timestamp value
	docRef
		.update({ nextIntakeTime: timestamp })
		.then(() => {
			console.log("Timestamp field updated successfully");
		})
		.catch((error) => {
			console.error("Error updating timestamp field:", error);
		});
}

// Powershell command
// $headers = @{ "Content-Type" = "application/json" }
// $body = @{ "machineID" = "123456" } | ConvertTo-Json

// Invoke-RestMethod -Method POST -Uri "https://medispenser.onrender.com/ipaddr" -Headers $headers -Body $body
