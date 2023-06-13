const express = require("express");
// const bodyParser = require('body-parser')

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

// Endpoint to fetch prescription data
app.get("/", async (req, res) => {
	try {
		// Retrieve prescription data from Firestore
		const snapshot = await db.collection("medicine-prescription").get();
		const prescriptions = [];

		// Extract relevant data from snapshot
		snapshot.forEach((doc) => {
			const prescription = doc.data();
			prescriptions.push(prescription);
		});

		// Generate HTML output
		let htmlOutput = "<html><body><h1>Prescriptions</h1>";
		htmlOutput += "<ul>";
		prescriptions.forEach((prescription) => {
			htmlOutput += `
            <li>
                <ul>
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
