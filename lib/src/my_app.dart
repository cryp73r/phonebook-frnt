import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './screens/home.dart';
import '../controller/contact_controller.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final ContactController contactController=Get.put(ContactController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "PhoneBook",
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
