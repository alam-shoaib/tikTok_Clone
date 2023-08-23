import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';

class  ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;
  Rx<String> _uid ="".obs;
  updateUid(String uid) {
    _uid.value = uid;
    getUpdate();
  }

  getUpdate() async {
    List<String> thumbnails = [];
    try {
      var myVideos = await cloudFirestore
          .collection('videos')
          .where('uid', isEqualTo: _uid.value)
          .get();
      for (int i = 0; i < myVideos.docs.length; i++) {
        thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
      }
      DocumentSnapshot userDoc =
      await cloudFirestore.collection('users').doc(_uid.value).get();
      final userData = userDoc.data()! as dynamic;
      String name = userData['name'];
      String profilePhoto = userData['profilePhoto'];
      int likes = 0;
      int followers = 0;
      int followings = 0;
      bool isFollowing = false;
      for (var items in myVideos.docs) {
        likes += (items.data()['likes'] as List).length;
      }
      var follwer = await cloudFirestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .get();
      var follwing = await cloudFirestore
          .collection('users')
          .doc(_uid.value)
          .collection('followings')
          .get();

      followers = follwer.docs.length;
      followings = follwing.docs.length;
      cloudFirestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .get()
          .then((value) {
        if (value.exists) {
          isFollowing = true;
        } else {
          isFollowing = false;
        }
      });
      _user.value = {
        'followers': followers.toString(),
        'followings': followings.toString(),
        'likes': likes.toString(),
        'name': name,
        'profilePhoto': profilePhoto,
        'isFollowing': isFollowing,
        'thumbnails': thumbnails,
      };
      update();
    }
    catch(e){
      Get.snackbar('Error while loading profile', e.toString());
    }
  }

  followUser() async {
    try{
    var doc = await cloudFirestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get();
    if (!doc.exists) {
      await cloudFirestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .set({});

      await cloudFirestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('followings')
          .doc(_uid.value)
          .set({});
      _user.value
          .update('followers', (value) => (int.parse(value) + 1).toString());
    }
    else{
      await cloudFirestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .delete();

      await cloudFirestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('followings')
          .doc(_uid.value)
          .delete();
      _user.value
          .update('followers', (value) => (int.parse(value) - 1).toString());
    }
    _user.value.update('isFollowing', (value) => !value);
    update();
  }
    catch(e){
      Get.snackbar('Error while loading profile', e.toString());
    }
  }

}
