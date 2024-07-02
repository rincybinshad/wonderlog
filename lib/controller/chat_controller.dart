import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wanderlog/model/message_model.dart';

class CommunicationController {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  sendmessage(reciveid, String message, String messageType) async {
    final senderEmailid = auth.currentUser!.email;
    final String curentuserid = auth.currentUser!.uid;

    final Timestamp timestamp = Timestamp.now();

    MessageModel messageModel = MessageModel(
      messageType: messageType,
      senderID: curentuserid,
      senderEmail: senderEmailid.toString(),
      reciverID: reciveid,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [curentuserid, reciveid];

    ids.sort();

    String chatroomid = ids.join('_');

    await db
        .collection('chat_room')
        .doc(chatroomid)
        .collection('message')
        .add(messageModel.tojsone());
  }

  Stream<QuerySnapshot> getMessage(userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatroomid = ids.join('_');

    return db
        .collection('chat_room')
        .doc(chatroomid)
        .collection('message')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
