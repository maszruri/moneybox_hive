import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneybox/controllers/main_controller.dart';
import 'package:moneybox/models/money_model.dart';
import 'package:intl/intl.dart';

final MainController controller = Get.find();

class EditView extends StatefulWidget {
  final int? index;
  final MoneyModel? moneyModel;
  // ignore: prefer_typing_uninitialized_variables
  final titleController;
  // ignore: prefer_typing_uninitialized_variables
  final descController;
  // ignore: prefer_typing_uninitialized_variables
  final moneyController;
  // ignore: prefer_typing_uninitialized_variables
  final dateController;
  // ignore: prefer_typing_uninitialized_variables
  final isExpense;

  const EditView(
      {super.key,
      this.index,
      this.moneyModel,
      this.titleController,
      this.descController,
      this.moneyController,
      this.dateController,
      this.isExpense});

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  bool chooseExpense = false;
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final TextEditingController _moneyController;
  late final TextEditingController _dateController;

  @override
  void initState() {
    // TODO: implement initState
    _titleController = TextEditingController(text: widget.titleController);
    _descController = TextEditingController(text: widget.descController);
    _moneyController = TextEditingController(text: widget.moneyController);
    _dateController = TextEditingController(
        text: DateFormat('dd MMMM yyyy')
            .format(DateTime.parse(widget.dateController)));
    chooseExpense = widget.isExpense;
    super.initState();
  }

  editData(String dateNew) {
    MoneyModel newMoneyModel = MoneyModel(
        title: _titleController.text,
        desc: _descController.text,
        money: _moneyController.text,
        date: dateNew,
        isExpense: controller.isExpense.value);
    controller.moneyBox.putAt(widget.index!, newMoneyModel);
  }

  @override
  Widget build(BuildContext context) {
    controller.isExpense.value = chooseExpense;
    controller.dateFormat = DateTime.parse(widget.dateController);
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text("Edit"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                CupertinoTextField(
                  controller: _titleController,
                  placeholder: "Title",
                ),
                const SizedBox(height: 15),
                CupertinoTextField(
                  controller: _descController,
                  placeholder: "Description",
                ),
                const SizedBox(height: 15),
                CupertinoTextField(
                  controller: _moneyController,
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

                      _dateController.text =
                          DateFormat('dd MMMM yyyy').format(calendarPicker);
                    }
                  },
                  readOnly: true,
                  controller: _dateController,
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
                            chooseExpense = value;
                            controller.isExpense.value = chooseExpense;
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
                  child: const Text("Update"),
                  onPressed: () {
                    if (controller.dateFormat != null &&
                        _dateController.text.isNotEmpty &&
                        _titleController.text.isNotEmpty &&
                        _descController.text.isNotEmpty &&
                        _moneyController.text.isNotEmpty) {
                      editData(DateFormat('yyyyMMdd')
                          .format(controller.dateFormat!));
                      controller.totalIncome();
                      controller.totalOutcome();
                      Get.back();
                    } else {
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
      ),
    );
  }
}
