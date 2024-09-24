import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/twat.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  Future<void> addTwat(Twat twat) async {
    await _db.collection('twats').add(twat.toMap());
  }

  Stream<List<Twat>> getTwats() {
    try {
      return _db
          .collection('twats')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Twat.fromFirestore(doc.data()))
              .toList());
    } catch (e) {
      print('Error fetching twats: $e');
      return Stream.value([]);
    }
  }

  Future<bool> likeTwat(String twatId) async {
    try {
      final querySnapshot =
          await _db.collection('twats').where('id', isEqualTo: twatId).get();
      if (querySnapshot.docs.isEmpty) {
        print('Twat not found');
        return false;
      }
      final doc = querySnapshot.docs.first;
      final twatData = doc.data() as Map<String, dynamic>?;
      if (twatData == null) {
        print('Twat data is null');
        return false;
      }
      twatData['likes']++;
      await _db.collection('twats').doc(doc.id).set(twatData);
      return true;
    } catch (e) {
      print('Error liking twat: $e');
      return false;
    }
  }

  Future<bool> retwat(String twatId, Twat newTwat) async {
    try {
      final querySnapshot =
          await _db.collection('twats').where('id', isEqualTo: twatId).get();
      if (querySnapshot.docs.isEmpty) {
        print('Original twat not found');
        return false;
      }
      final doc = querySnapshot.docs.first;
      final twatData = doc.data() as Map<String, dynamic>?;
      if (twatData == null) {
        print('Original twat data is null');
        return false;
      }
      twatData['retwats']++;
      await _db.collection('twats').doc(doc.id).set(twatData);
      await addTwat(newTwat);
      return true;
    } catch (e) {
      print('Error retweeting: $e');
      return false;
    }
  }

  Future<Twat> getTwat(String twatId) async {
    try {
      final twat = await _db.collection('twats').doc(twatId).get();
      return Twat.fromFirestore(twat.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error fetching twat: $e');
      rethrow;
    }
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      final id = _uuid.v4();
      final imagesRef = _storage.ref().child('images/$id.jpg');

      await imagesRef.putFile(imageFile);

      String downloadURL = await imagesRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }
}
