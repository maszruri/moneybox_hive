import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'controllers/main_controller.dart';
import 'models/money_model.dart';
import 'views/main_view.dart';

void main(List<String> args) async {
  await Hive.initFlutter();
  Hive.registerAdapter(MoneyModelAdapter());
  await Hive.openBox('moneyBox');
  Get.put(MainController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainView(),
    );
  }
}
