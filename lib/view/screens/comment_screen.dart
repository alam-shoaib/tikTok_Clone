import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/controller/comment_controller.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as tago;

class CommentScreen extends StatelessWidget {
  final String id;
  CommentScreen({required this.id,Key? key}) : super(key: key);
  final TextEditingController _commentController = TextEditingController();
  CommentController commentController=Get.put(CommentController());


  @override
  Widget build(BuildContext context) {
    commentController.updatePost(id);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(
                  child: Obx(() {
                      return ListView.builder(
                          itemCount: commentController.comments.length,
                          itemBuilder: (context, index) {
                            final commets=commentController.comments[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.black,
                                backgroundImage: NetworkImage(commets.profilePhoto),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    commets.username,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    commets.comment,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    tago.format(commets.datePublish.toDate()),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '${commets.likes.length} like',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              trailing: InkWell(
                                onTap: () => commentController.likeComment(commets.id),
                                child: Icon(Icons.favorite,
                                    size: 25, color: commets.likes.contains(authController.user.uid)? Colors.red: Colors.white),
                              ),
                            );
                          });
                    }
                  )),
              const Divider(),
              ListTile(
                title: TextFormField(
                  controller: _commentController,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  decoration: const InputDecoration(
                      labelText: 'Comment',
                      labelStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red))),
                ),
                trailing: TextButton(
                  onPressed: () =>commentController.postComment(_commentController.text),
                  child: const Text(
                    'send',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
