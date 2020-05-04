const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);
//admin.initializeApp(functions.config());

//var newData;
var deviceTokens;

exports.sendToDevice = functions.firestore.document('call/{receiverId}').onCreate( async (snapshot, context) => {
//exports.messageTrigger = functions.firestore.document('call/{receiverId}').onWrite( async (snapshot, context) => {
    if(snapshot.empty){
        console.log('No Devices found!');
        return;
    }

    //var tokens = [];

    //newData = snapshot.data;

    //var token = await admin.firestore().document('users/{token}').get();

    //const deviceTokens = await
    //    admin.firestore().collection('call').document('call/{receiverId}')
    //    .collection('users').document('users/{token}')
    //    .get();

    deviceTokens = await
            admin.firestore().collection('call').document('call/{receiverId}')
            .collection('users').document('users/{token}')
            .get();

    //for (var token of deviceTokens) {
    //    tokens.push(token.data().device_token);
    //}

    var payload = {
        notification: {
            title: 'Ligação do Luzia', body: 'Alguém precisa da sua ajuda!', sound: 'default'
        },
        data: {
            click_action: 'FLUTTER_NOTIFICATION_CLICK', //message: newData.message
        },
    };
    try{
        //const response = await admin.messaging().sendToDevice(token, payload);
        const response = await admin.messaging().sendToDevice(deviceTokens, payload);
        //const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log('Notification sent succesfully');
    } catch(err){
        console.log('Error sending notification');
    }
}) ;


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
