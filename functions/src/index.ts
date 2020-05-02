import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendToDevice = functions.firestore
  .document('call/{receiverId}')
  .onCreate(async snapshot => {


    const call = snapshot.data();

    const querySnapshot = await db
      .collection('call')
      .doc(call.receiverId)
      .collection('users')
      .doc(users.token)
      .get();

    const token = querySnapshot.docs.map(snap => snap.id);

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'Ligação do Luzia',
        body: 'Alguém precisa da sua ajuda! Clique para atender a ligação.',
        icon: 'your-icon-url',
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

    return fcm.sendToDevice(token, payload);
  });