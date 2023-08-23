import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart ';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/model/Video.dart';


class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);
  List<Video> get videolist => _videoList.value;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _videoList.bindStream(cloudFirestore
        .collection('videos')
        .snapshots()
        .map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        retVal.add(Video.fromSnapshot(element));
      }
      return retVal;
    }));
  }

  likeVideo(String id) async {
    var user = authController.user.uid;
    DocumentSnapshot snapshot =
        await cloudFirestore.collection('videos').doc(id).get();
    if ((snapshot.data()! as dynamic)['likes'].contains(user)) {
      await cloudFirestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([user])
      });
    } else {
      await cloudFirestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([user])
      });
    }
  }
}
