import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/model/user.dart' as model;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/view/screens/auth/login_screen.dart';
import 'package:tiktok_clone/view/screens/home_screen.dart';
class AuthController extends GetxController {
  static AuthController instance=Get.find();
  late Rx<File?> _pickedImage;
  late Rx<User?> _user;
  User get user=>_user.value!;
  File? get Profil=> _pickedImage.value;
  @override
  void onReady() {
    // TODO: implement onReady
    _user=Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setinitialScreen);

  }
  _setinitialScreen(User? user)
  {
    if(user==null)
      {
        Get.offAll(()=>login_screen());
      }
    else
      {
        Get.offAll(()=>const Home_Screen());
      }
  }

  void pickImage()async
  {
     final pickImage=await ImagePicker().pickImage(source: ImageSource.gallery);
     if(pickImage!=null)
       {
         Get.snackbar('Profile Picture', 'Profile Picture Selected Successfully');
       }
     _pickedImage=Rx<File?>(File(pickImage!.path));
  }
  Future<String> _uploadProfile(File image)async
  {
    Reference ref=storage.ref().child('profile').child(firebaseAuth.currentUser!.uid);
    UploadTask task=ref.putFile(image);
    TaskSnapshot snap=await task;
    String downloadLinh=await snap.ref.getDownloadURL();
    return downloadLinh;
  }
  void registerUser(String email,String username,String password,File?image)
  async {
    try
    {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password);
        String downloadurl=await _uploadProfile(image);
        model.user user=model.user
          (
            uid: cred.user!.uid,
            email: email,
            name: username,
            profilePhoto: downloadurl
          );
        await cloudFirestore.collection('users').doc(cred.user!.uid).set(user.toJson());
      }
      else
        {
          Get.snackbar('Error creating an account', 'Please enter all the field');
        }
    }
    catch(e){
      Get.snackbar('Error creating an account', e.toString());
    }
  }
  void loginUser(String email,String password) async{
    try
    {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      }
      else
        {
          Get.snackbar('Error creating an account', 'Please enter all the field');
        }
    }
    catch(e)
    {
      Get.snackbar('Error creating an account', e.toString());
    }
  }
  void signOut()async{
    await firebaseAuth.signOut();
  }
}