import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneybox/controllers/main_controller.dart';
import 'package:moneybox/views/add_view.dart';
import 'package:moneybox/views/history_view.dart';
import 'package:moneybox/views/home_view.dart';

// ignore: must_be_immutable
class MainView extends GetView<MainController> {
  MainView({super.key});

  final PageController pageController = PageController();

  // animate switching pages via bottom navigation bar
  void onItemTap(int index) {
    controller.currentIndex.value = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text("MoneyBox"),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (index) {
          controller.currentIndex.value = index;
        },
        children: const <Widget>[
          HomeView(),
          HistoryView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Get.to(() => AddView(), transition: Transition.upToDown);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: onItemTap,
            items: const [
              BottomNavigationBarItem(
                label: "Home",
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                label: "History",
                icon: Icon(Icons.history),
              ),
            ],
          )),
    );
  }
}
