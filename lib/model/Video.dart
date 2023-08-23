import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String username;
  String uid;
  String profilePhoto;
  String id;
  List like;
  int commentCount;
  int shareCount;
  String songName;
  String videoUrl;
  String thumbnail;
  String caption;

  Video({
    required this.username,
    required this.uid,
    required this.profilePhoto,
    required this.id,
    required this.like,
    required this.commentCount,
    required this.shareCount,
    required this.songName,
    required this.caption,
    required this.videoUrl,
    required this.thumbnail,
  });
  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "profilePhoto": profilePhoto,
        "id": id,
        "likes": like,
        "commentCount": commentCount,
        "shareCount": shareCount,
        "songName": songName,
        "caption": caption,
        "videoUrl": videoUrl,
        "thumbnail": thumbnail
      };
  static Video fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Video(
        username: snapshot['username'],
        uid: snapshot['uid'],
        profilePhoto: snapshot['profilePhoto'],
        id: snapshot['id'],
        like: snapshot['likes'],
        commentCount: snapshot['commentCount'],
        shareCount: snapshot['shareCount'],
        songName: snapshot['songName'],
        caption: snapshot['caption'],
        videoUrl: snapshot['videoUrl'],
        thumbnail: snapshot['thumbnail']);
  }
}
