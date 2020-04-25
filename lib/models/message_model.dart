import 'package:helping_hand/models/user_model_for_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final User sender;
  final Timestamp
      time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool isLiked;
  final bool unread;
  final String textID;

  Message({
    this.textID,
    this.sender,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
  });
}
