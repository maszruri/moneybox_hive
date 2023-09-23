import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneybox/models/money_model.dart';
import 'package:intl/intl.dart';
import 'package:currency_formatter/currency_formatter.dart';

class MainController extends GetxController {
  CurrencyFormatterSettings currencySettings = CurrencyFormatterSettings(
    symbol: 'Rp.',
    thousandSeparator: ',',
    decimalSeparator: '.',
    symbolSeparator: ' ',
  );
  RxInt currentIndex = 0.obs;
  DateTime dateNow = DateTime.now();
  RxString dateTitle = DateFormat('dd MMMM yyyy').format(DateTime.now()).obs;
  RxBool isVisible = false.obs;
  String? dateBox;
  RxBool isExpense = false.obs;
  DateTime? dateFormat;
  RxList incomeList = [].obs;
  RxInt incomeTotal = 0.obs;
  RxList outcomeList = [].obs;
  RxInt outcomeTotal = 0.obs;

  final Box moneyBox = Hive.box('moneyBox');

  createData(
      String title, String desc, String money, String date, bool isExpense) {
    MoneyModel moneyModel = MoneyModel(
        title: title,
        desc: desc,
        money: money,
        date: date,
        isExpense: isExpense);
    moneyBox.add(moneyModel);
  }

  removeData(index) {
    moneyBox.deleteAt(index);
    totalIncome();
    totalOutcome();
  }

  totalOutcome() {
    outcomeTotal.value = 0;
    outcomeList.value = [];
    for (var i = 0; i < moneyBox.length; i++) {
      if (moneyBox.getAt(i).isExpense == true) {
        String parseMoney =
            moneyBox.getAt(i).money.replaceAll(RegExp('[^0-9]'), '');
        outcomeList.add(int.parse(parseMoney));
        int sum = 0;
        for (int element in outcomeList) {
          sum += element;
          outcomeTotal.value = sum;
        }
      }
    }
  }

  totalIncome() {
    incomeTotal.value = 0;
    incomeList.value = [];
    for (var i = 0; i < moneyBox.length; i++) {
      if (moneyBox.getAt(i).isExpense == false) {
        String parseMoney =
            moneyBox.getAt(i).money.replaceAll(RegExp('[^0-9]'), '');
        incomeList.add(int.parse(parseMoney));
        int sum = 0;
        for (int element in incomeList) {
          sum += element;
          incomeTotal.value = sum;
        }
      }
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    totalOutcome();
    totalIncome();
    super.onInit();
  }
}
