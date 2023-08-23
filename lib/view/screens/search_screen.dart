import 'package:flutter/material.dart';
import 'package:tiktok_clone/controller/search_controller.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/model/user.dart';
import 'package:tiktok_clone/view/screens/profile_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  final Searchcontroller searchcontroller = Get.put(Searchcontroller());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: TextFormField(
            decoration: const InputDecoration(
              filled: false,
              hintText: 'Search',
              hintStyle: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onFieldSubmitted: (value) => searchcontroller.searchUser(value),
          ),
        ),
        body: searchcontroller.searchedUser.isEmpty
            ? const Center(
                child: Text(
                  'Search for user!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: searchcontroller.searchedUser.length,
                itemBuilder: (context, index) {
                  user use = searchcontroller.searchedUser[index];
                  return InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfileScreen(uid: use.uid))),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(use.profilePhoto),
                      ),
                      title: Text(
                        use.name,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }),
      );
    });
  }
}
