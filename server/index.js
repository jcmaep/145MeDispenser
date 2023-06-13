const express = require("express");
//const bodyParser = require('body-parser')
const SerialPort = require('serialport');
//onst request = require('request');
const arduinoUrl = 'http://192.168.5.2/arduino';
//const { Timestamp } = require("firebase/compat/firestore"); // Import the Timestamp class


// initialize firebase admin sdk
const admin = require("firebase-admin");
const serviceAccount = require("./medispenser-c25fb-firebase-adminsdk-yzb5c-d256f125fc.json");

admin.initializeApp({
	credential: admin.credential.cert(serviceAccount),
	databaseURL: "https://medispenser-c25fb.firebaseio.com",
});

const db = admin.firestore();

const app = express();
const port = 3000;
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
            // Accessing individual elements of the array
            //const first_timestamp_array = prescription.first_timestamp;
            const start_timestampp = prescription.start_timestamp;
            const start_timestampp_millis = start_timestampp.toMillis();
            const start_timestampp_date = new Date(start_timestampp_millis);
            //const formatted_date = start_timestampp_date.toLocaleString(); // Convert to formatted date string
            //const start_timestamppp = Date(start_timestampp_millis)
            //Console.log processes it as normal!
            console.log(start_timestampp_date);
			htmlOutput += `
            <li>
                <ul>
                    <li>${prescription.id}</li>
                    <li>${start_timestampp_date}</li>
                    <li>${prescription.prescriptionName}</li>
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


// Post request from Arduino, when pills are successfully dispensed.
app.post('/test', (req, res) => {
    console.log('Received POST request from Arduino: from ' + req.ip[7] + ' with body: ' + JSON.stringify(req.body));
    console.log(req.body);
    let json = req.body;
    console.log(json);
    // Get the decimal IP address
    //let machineID = json.MachineID;
    let json_response = {
        command: 'dispense',
        message: req.ip.slice(5)
    };

    console.log(json_response);
	console.log(req.ip);
    //console.log(`Input received: ${machineID}`);
    res.send(req.body);
});

//Update database

// Loop to check database data, then send dispensing signal to Arduino if timestamp is == current time
async function timestampLoop() {
    while (true) {

    }
    //Get updated database
    //
}

// Timestamp mechanism, push notification if missed


// Start the server
app.listen(port, () => {
	console.log(`Server is listening on port ${port}`);
});


function decimalToOctet(decimalIP) {
    const octetArr = [];
  
    for (let i = 0; i < 4; i++) {
      const octet = decimalIP & 255; // Extract the last 8 bits
      octetArr.unshift(octet.toString()); // Prepend octet to the array
      decimalIP = decimalIP >> 8; // Shift right by 8 bits
    }
  
    return octetArr.join(".");
}