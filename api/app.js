const express = require('express')
const app = express()
var http = require('http');
var http = require('https');
var request = require('request');
const port = 3000

var firebase = 'https://us-central1-sya-dummy.cloudfunctions.net/'

app.listen(port, () => console.log(`Example app listening on port ${port}!`))

// Test function to test communications with Firebase
app.put('/user', function (req, res) {
	var url = firebase + 
	          'testFunction' + 
	          '?name=' + 
	          req.query.name +
	          '&age=' +
	          req.query.age;

	console.log(url);

    request(url, function(error, response, body) {
    	if (!error && response.statusCode == 200) console.log(body);
    });
    res.send('Done');
})