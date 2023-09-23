import 'package:hive/hive.dart';

part 'money_model.g.dart';

@HiveType(typeId: 1)
class MoneyModel {
  @HiveField(0)
  String title;

  @HiveField(1)
  String desc;

  @HiveField(2)
  String money;

  @HiveField(3)
  String date;

  @HiveField(4)
  bool isExpense;

  MoneyModel(
      {required this.title,
      required this.desc,
      required this.money,
      required this.date,
      required this.isExpense});
}
