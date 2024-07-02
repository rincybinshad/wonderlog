import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String senderID;
  String senderEmail;
  String reciverID;
  String message;
  Timestamp timestamp;
  String messageType;

  MessageModel({
    required this.messageType,
    required this.senderID,
    required this.senderEmail,
    required this.reciverID,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> tojsone() => {
    'messageType':messageType,
        'senderid': senderID,
        'senderemail': senderEmail,
        'message': message,
        'timestamp': timestamp,
        'reciverid': reciverID,
      };

  factory MessageModel.fromjsone(Map<String, dynamic> jsone) {
    return MessageModel(
      messageType:jsone['messageType'],
      senderID: jsone['senderid'],
      senderEmail: jsone['senderemail'],
      reciverID: jsone['reciverid'],
      message: jsone['message'],
      timestamp: jsone['timestamp'],
    );
  }
}
