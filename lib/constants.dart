import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tiktok_clone/view/screens/profile_screen.dart';
import 'package:tiktok_clone/view/screens/search_screen.dart';
import 'controller/auth_Controller.dart';
import 'view/screens/add_video_screen.dart';
//import 'view/screens/home_screen.dart';
import 'view/screens/video_screen.dart';

List pages = [
  VideoScreen(),
  SearchScreen(),
  const AddVideoScreen(),
  Text('Message Screen'),
  ProfileScreen(uid: authController.user.uid)
];

const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

//Firebase
var firebaseAuth = FirebaseAuth.instance;
var cloudFirestore = FirebaseFirestore.instance;
var storage = FirebaseStorage.instance;

//Controller
var authController = AuthController.instance;
