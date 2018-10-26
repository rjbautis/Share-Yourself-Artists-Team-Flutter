
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

var db = admin.firestore();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
//exports.helloWorld = functions.https.onRequest((request, response) => {
//	response.send("Hello from Firebase!");
//});

// Adds a user with a name and age to the database
exports.testFunction = functions.https.onRequest((request, response) => {
    var data = {
        name: request.body.name,
        age: parseInt(request.body.age)
	};
    
	var setDoc = db.collection('users').add(data);
	response.json({result: `User ${data.name} at age ${data.age} added.`});
	return;
});

// Returns a JSON object with the URL to a picture of le chat
exports.getChat = functions.https.onRequest ((request, response) => {
    response.json({url: 'https://firebasestorage.googleapis.com/v0/b/sya-dummy.appspot.com/o/Cat03.jpg?alt=media&token=004d9b0b-78f1-436d-833a-69cc622879d6'});
    return;
});

// Gets a specific user's name and age
exports.getUserData = functions.https.onRequest ((request, response) => {
	var data;
 
	var user = db.collection('users').doc('mVd1xepaNibMO9iu1O0d').get().then(doc => {
    if (doc.exists) {
        data = {
		    userID: 'mVd1xepaNibMO9iu1O0d',
		    name: doc.data().name
	    };
	    response.json(data);
	    return;
    } 
    else {
      throw new Error("Profile doesn't exist")
    }

    });
});

exports.deleteUserData = functions.https.onRequest ((request, response) => {
	var deleteDoc = db.collection('users').doc(request.body.id).delete();
	response.json({result: `User ${request.body.id} deleted.`})
	return;
});


