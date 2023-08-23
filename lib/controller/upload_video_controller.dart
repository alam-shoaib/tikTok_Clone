import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:video_compress/video_compress.dart';
import 'package:tiktok_clone/model/Video.dart';

class UploadVideoController extends GetxController {
  _compressVideo(String videoPath) async {
    final compressed = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality);
    return compressed!.file;
  }

  Future<String> _uploadVideoToStorage(String videoId, String videoPath) async {
    Reference ref = storage.ref().child('videos').child('id');
    UploadTask task = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await task;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> _imageToStorage(String videoPath, String id) async {
    Reference ref = storage.ref().child('videos').child('thumbnail');
    UploadTask task = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await task;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumnail;
  }

  uploadVideo(String videoPath, String caption, String songName) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot snap =
          await cloudFirestore.collection('users').doc(uid).get();
      var alldoc = await cloudFirestore.collection('videos').get();
      int len = alldoc.docs.length;
      String url = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnail = await _imageToStorage(videoPath, "Video $len");
      Video video = Video(
          username: (snap.data()! as Map<String, dynamic>)['name'],
          uid: uid,
          profilePhoto: (snap.data()! as Map<String, dynamic>)['profilePhoto'],
          id: "Video $len",
          like: [],
          commentCount: 0,
          shareCount: 0,
          songName: songName,
          caption: caption,
          videoUrl: url,
          thumbnail: thumbnail);
      await cloudFirestore
          .collection('videos')
          .doc('Video $len')
          .set(video.toJson());
      Get.back();
    } catch (e) {
      Get.snackbar("Error uploading video...", e.toString());
    }
  }
}
