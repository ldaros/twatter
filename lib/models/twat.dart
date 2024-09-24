import 'package:cloud_firestore/cloud_firestore.dart';

class Twat {
  final String id;
  final String userId;
  final String username;
  final String handle;
  final String content;
  final DateTime timestamp;
  final String avatarUrl;
  final String? imageUrl;
  int likes;
  int retwats;
  String? replyToHandle;
  String? retweetedFrom;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'handle': handle,
      'content': content,
      'timestamp': timestamp,
      'avatarUrl': avatarUrl,
      'imageUrl': imageUrl,
      'likes': likes,
      'retwats': retwats,
      'replyToHandle': replyToHandle,
      'retweetedFrom': retweetedFrom,
    };
  }

  factory Twat.fromFirestore(Map<String, dynamic> data) {
    return Twat(
      id: data['id'],
      userId: data['userId'],
      username: data['username'],
      handle: data['handle'],
      content: data['content'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      avatarUrl: data['avatarUrl'],
      imageUrl: data['imageUrl'],
      likes: data['likes'],
      retwats: data['retwats'],
      replyToHandle: data['replyToHandle'],
      retweetedFrom: data['retweetedFrom'],
    );
  }

  Twat({
    required this.id,
    required this.userId,
    required this.username,
    required this.handle,
    required this.content,
    required this.timestamp,
    required this.avatarUrl,
    this.imageUrl,
    this.likes = 0,
    this.retwats = 0,
    this.replyToHandle,
    this.retweetedFrom,
  });
}