/*
Name: File main của app
Last Modified: 6/7/21
Description: Nơi viết hàm main
Notes: 
*/

import 'package:exchange/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/signin.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SE304.L23',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: mainColor,
        ),
        home: Signin());
  }
}
