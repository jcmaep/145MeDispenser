const express = require('express');
const bodyParser = require('body-parser')





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

app.listen(3000, () => {
	console.log('running...');
});