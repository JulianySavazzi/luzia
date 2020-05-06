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
    admin.firestore().doc('users/' + receiver_id).get().then(userDoc => {
        const tokens = userDoc.get('token');

        //create a message
        var payload = {
            notification: {title: 'Ligação do Luzia', body: 'teste', sound: 'default'},
            data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'teste' },
        };

        try {
            const response = admin.messaging().sendToDevice(tokens, payload);
            console.log('A mensagem foi enviada com sucesso', response);
        } catch (error){
            console.log('A mensagem não foi enviada', error);
        }

})

}); //END OF getDetailsforCallNotification FCM



