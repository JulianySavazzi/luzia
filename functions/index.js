const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);


exports.getDetailsforCallNotification = functions.firestore.document('call/{receiver_id}').onCreate(async(snapshot, context) => {
    console.log('Receiverid found', snapshot.data());
    //Get data from snapshot
    const data = snapshot.data();
    //Get receiverId from the call document
    const receiver_id = data['receiver_id'];
    //Get receiverId token
    return admin.firestore().doc('users/' + receiver_id).get().then(userDoc => {
        const userToken = userDoc.get('token');

    //function sendNotification(userToken, receiver_id){
        
        //create a message
        const payload = {
            notification: {title: 'Ligação do Luzia', body: 'Alguém precisa de sua ajuda! Clique Aceito para atender a ligação.'},
            icon: 'your-icon-url',
            token: userToken,
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
        }
        //send message with admin.message()
        return admin.messaging()
        .sendToDevice(userToken, payload)
        .then(response => {
            console.log("Message sent", response);
        })
        .catch(error => {
            console.log("Error sending message", error);
        })

    //}

})

}); //END OF getDetailsforCallNotification FCM



