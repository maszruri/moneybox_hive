import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneybox/controllers/main_controller.dart';
import 'package:moneybox/views/home_view.dart';
import 'package:intl/intl.dart';

class AddView extends GetView<MainController> {
  AddView({super.key});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController moneyController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text("Add"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              CupertinoTextField(
                controller: titleController,
                placeholder: "Title",
              ),
              const SizedBox(height: 15),
              CupertinoTextField(
                controller: descController,
                placeholder: "Description",
              ),
              const SizedBox(height: 15),
              CupertinoTextField(
                controller: moneyController,
                placeholder: "Money",
              ),
              const SizedBox(height: 15),
              CupertinoTextField(
                onTap: () async {
                  DateTime? calendarPicker = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2013),
                      lastDate: DateTime(2033));
                  if (calendarPicker != null) {
                    controller.dateFormat = calendarPicker;

                    dateController.text =
                        DateFormat('dd MMMM yyyy').format(calendarPicker);
                  }
                },
                readOnly: true,
                controller: dateController,
                placeholder: "Pick a Date",
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: controller.isExpense.value == true ? 0 : 1,
                        child: const Text("Income"),
                      )),
                  const SizedBox(width: 5),
                  Obx(() => CupertinoSwitch(
                        trackColor: CupertinoColors.systemGreen,
                        activeColor: CupertinoColors.systemRed,
                        value: controller.isExpense.value,
                        onChanged: (value) {
                          controller.isExpense.value = value;
                          // print(controller.isExpense);
                        },
                      )),
                  const SizedBox(width: 5),
                  Obx(() => AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: controller.isExpense.value == true ? 1 : 0,
                        child: const Text("Outcome"),
                      )),
                ],
              ),
              const SizedBox(height: 15),
              CupertinoButton.filled(
                child: const Text("Add"),
                onPressed: () {
                  if (controller.dateFormat != null &&
                      dateController.text.isNotEmpty &&
                      titleController.text.isNotEmpty &&
                      descController.text.isNotEmpty &&
                      moneyController.text.isNotEmpty) {
                    controller.createData(
                        titleController.text,
                        descController.text,
                        moneyController.text,
                        DateFormat('yyyyMMdd').format(controller.dateFormat!),
                        controller.isExpense.value);
                    controller.totalIncome();
                    controller.totalOutcome();
                    Get.back();
                  } else {
                    // print("KOSONG");
                    Get.snackbar(
                      "Error",
                      "Pastikan mengisi semua form",
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(15),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
