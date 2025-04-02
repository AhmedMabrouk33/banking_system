import '../../core/enums/user_actions_enums.dart';
import '../../core/extensions/date_time_extension.dart';
import '../../core/extensions/user_actions_extensions.dart';

class LogsModel {
  final String userID;
  final String userName;
  final String accountNumber;
  final UserActionsEnums userActionState;
  final String? receiveAccountNumber;
  final double? amount;
  final DateTime createdDateTime;

  LogsModel({
    required this.userID,
    required this.userName,
    required this.accountNumber,
    required this.userActionState,
    this.receiveAccountNumber,
    this.amount,
    DateTime? createdTime,
  }) : createdDateTime = createdTime ?? DateTime.now();

  @override
  String toString() {
    String returnString = '''
     Action : ${userActionState.name},
     User Name : $userName,
     accountNumber: ${accountNumber.isNotEmpty ? accountNumber : 'Administrator'},
     createdDateTime: ${createdDateTime.customFormate}''';
    if (userActionState == UserActionsEnums.transfersAction) {
      returnString += '\nReceived Account : $receiveAccountNumber';
    }
    if ((userActionState == UserActionsEnums.depositsAction) ||
        (userActionState == UserActionsEnums.transfersAction) ||
        (userActionState == UserActionsEnums.withdrawalsAction)) {
      returnString += '\nAmount : ${(amount ?? 0).toStringAsFixed(2)}';
    }

    return returnString;
  }

  factory LogsModel.fromJson(Map<String, dynamic> json) {
    return LogsModel(
      userID: json['userID'] ?? '',
      userName: json['userName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      userActionState:
          UserActionsEnums.values[int.tryParse(json['userActionState'].toString()) ??
              (UserActionsEnums.values.length - 1)],
      receiveAccountNumber: json['receiveAccountNumber'],
      createdTime: DateTime.tryParse(json['createdDateTime'].toString()) ?? DateTime.now(),
      amount: double.tryParse(json['amount'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userID": userID,
      "userName": userName,
      "accountNumber": accountNumber,
      "userActionState": userActionState.index,
      "receiveAccountNumber": receiveAccountNumber,
      "createdDateTime": createdDateTime.toStringConvert,
      "amount": amount,
    };
  }
}
