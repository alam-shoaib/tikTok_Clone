import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/view/screens/auth/login_screen.dart';
import 'constants.dart';
//import 'view/screens/auth/signup_screen.dart';
import 'controller/auth_Controller.dart';
//import 'view/screens/add_video_screen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value){
    Get.put(AuthController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'TikTok',
      theme: ThemeData.dark(useMaterial3: false).copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),

      home: login_screen(),
    );
  }
}

