// Dependencies and initializations =======================================
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const gcs = require('@google-cloud/storage')();
admin.initializeApp();
var db = admin.firestore();

// testFunction ===========================================================
// Adds a user with a name and age to the database
exports.testFunction = functions.https.onRequest((request, response) => {
    var parse_age = parseInt(request.body.age, 10);
    var data = {
        name: request.body.name,
        age: parse_age
	};
	var setDoc = db.collection('users').add(data).then(ref => {
      response.json({result: `User ${data.name} at age ${data.age} added.`});
      return;
    });
	return;
});

// getChat ================================================================
// Returns a JSON object with the URL to a picture of le chat. Delete this
// when Franz finishes implementing getArtworks into the app.
exports.getChat = functions.https.onRequest ((request, response) => {
    response.json({url: 'https://firebasestorage.googleapis.com/v0/b/sya-dummy.appspot.com/o/Cat03.jpg?alt=media&token=004d9b0b-78f1-436d-833a-69cc622879d6'});
    return;
});

// getUserData ============================================================
// Gets a specific user's name and age. Leave this here for reference until something pushable is implemented.
exports.getUserData = functions.https.onRequest ((request, response) => {
    var data = [];
	var users = db.collection('users');

    var allUsers = users.get()
        .then(snapshot => {
            snapshot.forEach(doc => {
                data.push(doc.data());
            });
            response.json({result: data});
            return;
        });
});

// deleteUserData =========================================================
// Deleted a given user's data
exports.deleteUserData = functions.https.onRequest ((request, response) => {
	var deleteDoc = db.collection('users').doc(request.body.id).delete();
	response.json({result: `User ${request.body.id} deleted.`})
	return;
});

// getArtworks ============================================================
// Gets all artworks in the artworks collections on server. 
// Later, this function will take a business user ID as input and return 
// a list of all artworks submitted to that business.
exports.getArtworks = functions.https.onRequest ((request, response) => {
	var allArtworks = artworks.get().then(snapshot => {
        var data = [];
		var artworks = db.collection('artworks');

        snapshot.forEach(doc => {
            var pic = doc.data(); //get JSON data from the doc
            pic["id"] = doc.id;   //add the id into the JSON object to be parsed in-app
            data.push(pic);       //add JSON object to the list
        });
        response.json({result: data});
        return;
    });
});

// uploadArtworks =========================================================
// On image upload, configure a new document in the artworks collection.
// TODO!!!
exports.uploadArtwork = functions.storage.object().onFinalize((object) => {
    return;
});
