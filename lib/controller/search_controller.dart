import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/model/user.dart';
import 'package:tiktok_clone/constants.dart';

class Searchcontroller extends GetxController {
  final Rx<List<user>> _searchedUser = Rx<List<user>>([]);
  List<user> get searchedUser => _searchedUser.value;
  searchUser(String typedUser) async {
    _searchedUser.bindStream(cloudFirestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: typedUser)
        .snapshots()
        .map((QuerySnapshot query) {
      List<user> retVal = [];
      for (var elemnt in query.docs) {
        retVal.add(user.fromSnap(elemnt));
      }
      return retVal;
    }));
  }
}
