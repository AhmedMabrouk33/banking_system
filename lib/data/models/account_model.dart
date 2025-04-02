import 'package:uuid/v4.dart';
import '../../core/extensions/date_time_extension.dart';

class AccountModel {
  final String accountNumber;
  double _balance;
  final DateTime createdDate;
  AccountModel({required double balance, String? accountNo, DateTime? createdTime})
    : accountNumber = accountNo ?? 'ACC - ${UuidV4().generate().split(' - ').first}',
      createdDate = createdTime ?? DateTime.now(),
      _balance = balance;

  set newBalance(double newBalance) => _balance = newBalance;

  double get balance => _balance;

  String get displayFullInformation {
    return '''Create Date is ${createdDate.customFormate}
The Account Number is $accountNumber, Balance is ${_balance.toStringAsFixed(2)} LE''';
  }

  String displayAccountInformation() {
    return 'The Account Number is $accountNumber, Balance is ${_balance.toStringAsFixed(2)} LE';
  }

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      balance: double.tryParse(json['balance'].toString()) ?? 0.0,
      accountNo: json['id'] ?? '',
      createdTime: DateTime.tryParse(json['createdTime'].toString()) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": accountNumber, "balance": _balance, "createdTime": createdDate.toStringConvert};
  }
}
