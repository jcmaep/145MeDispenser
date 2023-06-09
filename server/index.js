const express = require('express');
const bodyParser = require('body-parser')

// initialize firebase admin sdk
const admin = require('firebase-admin');
const serviceAccount = require('./medispenser-c25fb-firebase-adminsdk-yzb5c-d256f125fc.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

const app = express();

let messages = {message: 'Hello World'};

app.use(express.json());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.get('/', (req, res) => {
	res.send('hello world')
});

app.post('/', (req, res) => {
    let data = req.body;
    res.send('Data Received: ' + JSON.stringify(data));
})

//insert actual ip when deployed
app.listen(3000, '10.13.8.101', () => {
	console.log('running...');
});