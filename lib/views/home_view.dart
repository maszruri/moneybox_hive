import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../controllers/main_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

final MainController controller = Get.find();

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Card(
                child: ListTile(
                  onTap: () async {
                    DateTime? calendarPicker = await showDatePicker(
                        context: context,
                        initialDate: controller.dateNow,
                        firstDate: DateTime(2013),
                        lastDate: DateTime(2033));
                    if (calendarPicker != null) {
                      controller.dateNow = calendarPicker;
                      controller.dateTitle.value =
                          DateFormat('dd MMMM yyyy').format(controller.dateNow);
                    }
                    setState(() {});
                  },
                  leading: const Icon(Icons.calendar_month),
                  title: Obx(() => Text(controller.dateTitle.value)),
                ),
              ),
            ),
            const Divider(thickness: 2),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ValueListenableBuilder(
                  valueListenable: controller.moneyBox.listenable(),
                  builder: (context, value, child) {
                    if (value.isEmpty) {
                      return const Center(
                        child: Text("No Data"),
                      );
                    } else {
                      controller.isVisible.value = false;
                      return ListView.builder(
                        itemCount: controller.moneyBox.length,
                        itemBuilder: (context, index) {
                          var getData = controller.moneyBox.getAt(index);
                          if (getData.date ==
                              DateFormat('yyyyMMdd')
                                  .format(controller.dateNow)) {
                            controller.isVisible.value = true;
                            return Visibility(
                              visible: controller.isVisible.value,
                              child: Card(
                                child: ListTile(
                                  leading: getData.isExpense == true
                                      ? const Icon(
                                          Icons.upload,
                                          color: CupertinoColors.systemRed,
                                        )
                                      : const Icon(
                                          Icons.download,
                                          color: CupertinoColors.systemGreen,
                                        ),
                                  title: Text(getData.title),
                                ),
                              ),
                            );
                          } else {
                            controller.isVisible.value = false;

                            return Visibility(
                              visible: controller.isVisible.value,
                              child: const Card(),
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
