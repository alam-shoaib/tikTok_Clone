import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/model/comment.dart';
//import 'auth_Controller.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _comment = Rx<List<Comment>>([]);

  List<Comment> get comments => _comment.value;
  String _postid = "";

  updatePost(String id) {
    _postid = id;
    getComment();
  }

  getComment() async {
    _comment.bindStream(
      cloudFirestore
          .collection('videos')
          .doc(_postid)
          .collection('comments')
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<Comment> retVal = [];
          for (var elements in query.docs) {
            retVal.add(Comment.fromSnap(elements));
          }
          return retVal;
        },
      ),
    );
  }

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot snap = await cloudFirestore
            .collection('users')
            .doc(authController.user.uid)
            .get();
        var allDocs = await cloudFirestore
            .collection('videos')
            .doc(_postid)
            .collection('comments')
            .get();
        int len = allDocs.docs.length;
        Comment comment = Comment(
            username: (snap.data()! as dynamic)['name'],
            comment: commentText.trim(),
            datePublish: DateTime.now(),
            likes: [],
            profilePhoto: (snap.data()! as dynamic)['profilePhoto'],
            uid: authController.user.uid,
            id: 'Comment $len');
        await cloudFirestore
            .collection('videos')
            .doc(_postid)
            .collection('comments')
            .doc('Comment $len')
            .set(comment.toJson());
        DocumentSnapshot doc =
            await cloudFirestore.collection('videos').doc(_postid).get();
        await cloudFirestore.collection('videos').doc(_postid).update({
          'commentCount': (doc.data()! as dynamic)['commentCount'] + 1,
        });
      }
    } catch (e) {
      Get.snackbar('Error while uploading comments', e.toString());
    }
  }

  likeComment(String id) async {
    var uid = authController.user.uid;
    DocumentSnapshot doc = await cloudFirestore
        .collection('videos')
        .doc(_postid)
        .collection('comments')
        .doc(id)
        .get();
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await cloudFirestore
          .collection('videos')
          .doc(_postid)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await cloudFirestore
          .collection('videos')
          .doc(_postid)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
