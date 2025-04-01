import 'admistrator_model.dart';
import 'client_model.dart';
import 'logs_model.dart';
import 'user_model.dart';

class BankModel {
  final String bankName;
  final List<UserModel> _users;
  final List<LogsModel> logs;
  final List<String> _administratorToken;

  const BankModel({
    required this.bankName,
    required List<UserModel> users,
    required this.logs,
    required List<String> administratorToken,
  }) : _administratorToken = administratorToken,
       _users = users;

  BankModel.empty({required this.bankName, required List<String> administratorToken})
    : _administratorToken = administratorToken,
      _users = [],
      logs = [];

  UserModel? loginAction({required String userID, required String password}) {
    int tmpUserIndex = _users.indexWhere(
      (element) => element.isSameUserID(userID) && element.isSamePassword(password),
    );

    return _users.elementAtOrNull(tmpUserIndex);
  }

  factory BankModel.fromJson(Map<String, dynamic> json) {
    List<UserModel> tmpUsers = [];
    List<LogsModel> tmpLogs = [];
    List<String> tmpAdministratorToken = [];

    if ((json['users'] ?? []).isNotEmpty) {
      for (var singleUser in (json['users'] ?? [])) {
        tmpUsers = [
          ...tmpUsers,
          singleUser['isClient'] ?? false
              ? ClientModel.fromJson(singleUser)
              : AdministratorModel.fromJson(singleUser),
        ];
      }
    }
    if ((json['logs'] ?? []).isNotEmpty) {
      for (var singleLog in (json['logs'] ?? [])) {
        tmpLogs = [...tmpLogs, LogsModel.fromJson(singleLog)];
      }
    }
    if ((json['administratorToken'] ?? []).isNotEmpty) {
      for (var singleAdministratorToken in (json['administratorToken'] ?? [])) {
        tmpAdministratorToken = [...tmpAdministratorToken, singleAdministratorToken];
      }
    }

    return BankModel(
      bankName: json['bankName'] ?? '',
      users: tmpUsers,
      logs: tmpLogs,
      administratorToken: tmpAdministratorToken,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "bankName": bankName,
      "users":
          _users.isNotEmpty
              ? [
                ..._users.map(
                  (element) =>
                      (element is ClientModel)
                          ? element.toJson()
                          : (element as AdministratorModel).toJson(),
                ),
              ]
              : [],
      "logs": logs.isNotEmpty ? [...logs.map((element) => element.toJson())] : [],
      "administratorToken": [..._administratorToken],
    };
  }

  @override
  String toString() {
    return 'BankModel(bankName: $bankName, _users: $_users, logs: $logs, _administratorToken: $_administratorToken)';
  }
}
