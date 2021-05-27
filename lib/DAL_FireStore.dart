
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comeon_flutter/MessageModel.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('guestbook');

class DAL_FireStore {
  
Future<DocumentReference> addMessageToGuestBook(String message) {

    return _mainCollection.add({
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': 'testUser12',
      'userId': "sdf6s51se65",
    });
}
Stream<QuerySnapshot> readMessageFromGuestBook() {

 return _mainCollection
            .orderBy('timestamp', descending: true)
            .snapshots();
}

  // ...
}