import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneybox/controllers/main_controller.dart';
import 'package:moneybox/views/edit_view.dart';
import 'package:intl/intl.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:currency_formatter/currency_formatter.dart';

class HistoryView extends GetView<MainController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Card(
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text("Total Income"),
                        const SizedBox(height: 5),
                        Obx(() => Text(
                              CurrencyFormatter.format(
                                  controller.incomeTotal.value,
                                  controller.currencyFormat),
                              style: const TextStyle(fontSize: 20),
                            )),
                      ],
                    ),
                    const Divider(),
                    Column(
                      children: [
                        const Text("Total Outcome"),
                        const SizedBox(height: 5),
                        Obx(() => Text(
                              CurrencyFormatter.format(
                                  controller.outcomeTotal.value,
                                  controller.currencyFormat),
                              style: const TextStyle(fontSize: 20),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(thickness: 2),
          const SizedBox(height: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(0),
              // listen some value from moneyBox variable
              child: ValueListenableBuilder(
                valueListenable: controller.moneyBox.listenable(),
                builder: (context, value, child) {
                  if (value.isEmpty) {
                    return const Align(
                      alignment: Alignment(0, 0),
                      child: Text("Clean"),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: controller.moneyBox.length,
                      itemBuilder: (context, index) {
                        var getData = controller.moneyBox.getAt(index);
                        // swipable card for more options
                        return SwipeActionCell(
                          key: ObjectKey(getData),
                          trailingActions: [
                            // delete section
                            SwipeAction(
                              icon: const Icon(Icons.delete),
                              color: Theme.of(context).scaffoldBackgroundColor,
                              style: const TextStyle(color: Colors.black),
                              nestedAction: SwipeNestedAction(
                                  title: "Are you Sure?",
                                  icon: const Icon(Icons.delete)),
                              title: "Delete",
                              onTap: (CompletionHandler handler) async {
                                await handler(true);
                                controller.removeData(index);
                              },
                            ),
                            // edit section
                            SwipeAction(
                              style: const TextStyle(color: Colors.black),
                              icon: const Icon(Icons.edit),
                              title: "Edit",
                              color: Theme.of(context).scaffoldBackgroundColor,
                              onTap: (handler) {
                                // pass some data to update view
                                Get.to(
                                  () => EditView(
                                    index: index,
                                    moneyModel: getData,
                                    moneyController: getData.money,
                                    dateController: getData.date,
                                    titleController: getData.title,
                                    descController: getData.desc,
                                    isExpense: getData.isExpense,
                                  ),
                                );
                              },
                            ),
                          ],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Card(
                              color: getData.isExpense == true
                                  ? CupertinoColors.systemRed
                                  : CupertinoColors.systemGreen,
                              child: ExpansionTile(
                                textColor: Colors.black87,
                                iconColor: Colors.black54,
                                // onExpansionChanged: (value) {
                                //   controller.isExpand.value = value;
                                //   print(controller.isExpand);
                                // },
                                title: Text(getData.title),
                                subtitle: Text(
                                  DateFormat('dd MMMM yyyy').format(
                                    DateTime.parse(getData.date),
                                  ),
                                ),
                                childrenPadding: const EdgeInsets.all(15),
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Description : ${getData.desc}",
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        const SizedBox(height: 15),
                                        Text(
                                            "Money : ${CurrencyFormatter.format(getData.money, controller.currencyFormat)}"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
