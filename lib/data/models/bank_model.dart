import '../../core/enums/user_actions_enums.dart';
import 'admistrator_model.dart';
import 'client_model.dart';
import 'logs_model.dart';
import 'user_model.dart';

class BankModel {
  final String bankName;
  final List<UserModel> _users;
  final List<LogsModel> logs;
  final List<String> _administratorToken;
  int? _selectedUserIndex;

  BankModel({
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

  // ------------------------- * Model Actions ------------------------------------- //

  // * ------------------------ * Actions for Transfer  -------------------------------------- //
  Map<String, dynamic> getTransferAccountData({required accountNumber}) {
    int tmpUserAccountIndex = -1;
    for (int index = 0; index < _users.length; index++) {
      if ((index != _selectedUserIndex) && (_users[index] is ClientModel)) {
        tmpUserAccountIndex = (_users[index] as ClientModel).getInputAccountIndex(accountNumber);
        if (tmpUserAccountIndex != -1) {
          return {'userIndex': index, 'accountIndex': accountNumber};
        }
      }
    }
    return {};
  }

  void transformAmountMoney({
    required Map<String, dynamic> transferUserData,
    required double transferAmount,
  }) {
    (_users[transferUserData['userIndex'] ?? -1] as ClientModel).deposit(transferAmount, showBalance: false);
    
        
  }

  // * ------------------------ * Save Client Action  -------------------------------------- //
  void saveClientImage(ClientModel clientImageData) {
    if (_selectedUserIndex != null) {
      _users[_selectedUserIndex ?? -1] = clientImageData;
    }
  }

  // * ------------------------ * Validate Administrator Token  -------------------------------------- //

  bool validatedAdministratorToken(String inputValue) {
    return _administratorToken.contains(inputValue);
  }

  // * ------------------------ * Register/Log in Action -------------------------------------- //

  UserModel? loginAction({required String userID, required String password}) {
    int tmpUserIndex = _users.indexWhere(
      (element) => element.isSameUserID(userID) && element.isSamePassword(password),
    );

    if (tmpUserIndex != -1) {
      _selectedUserIndex = tmpUserIndex;
      return _users[tmpUserIndex];
    } else {
      _selectedUserIndex = null;
      return null;
    }
  }

  UserModel createAccount({
    required String userName,
    required String password,
    required String pin,
    required String token,
    required bool isAdministrator,
  }) {
    var tmpUser =
        isAdministrator
            ? AdministratorModel(password: password, pin: pin, userName: userName, token: token)
            : ClientModel.withAccount(
              userName: userName,
              password: password,
              pin: pin,
              accountBalance: 0,
            );

    _users.add(tmpUser);
    _selectedUserIndex = _users.length - 1;
    return tmpUser;
  }

  // * ------------------------ * Log Actions -------------------------------------- //

  void addLog({
    required UserActionsEnums userActionState,
    required String? receiveAccountNumber,
    required double? amount,
  }) {
    if (_selectedUserIndex != null) {
      logs.add(
        LogsModel(
          userID: _users[_selectedUserIndex ?? -1].userID,
          userName: _users[_selectedUserIndex ?? -1].userName,
          accountNumber:
              (_users[_selectedUserIndex ?? -1] is AdministratorModel)
                  ? (_users[_selectedUserIndex ?? -1] as AdministratorModel).accountNumber
                  : (_users[_selectedUserIndex ?? -1] as ClientModel).accountNumber,
          userActionState: userActionState,
          amount: amount,
          receiveAccountNumber: receiveAccountNumber,
        ),
      );
    }
  }

  void displayLogs(String? userID) {
    if (logs.isNotEmpty) {
      for (var singleLog in logs) {
        if ((userID == null) || (singleLog.userID == userID)) {
          print('${singleLog.toString()}\n====================================================\n');
        }
      }
    } else {
      print('There is No Logs\n==============================================================');
    }
  }

  // * ------------------------ * Display Action -------------------------------------- //

  void displayAllClientInformation() {
    for (var singleUser in _users) {
      if (singleUser is ClientModel) {
        print('====Client====\n${singleUser.displayClientInformation()}');
      } else {
        print('====Administrator====');
        (singleUser as AdministratorModel).displayAccountInformation();
      }
    }
  }

  // ---------------------------------------------------------------------------------- //

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
                ..._users.map<Map<String, dynamic>>(
                  (element) =>
                      (element is ClientModel)
                          ? {...element.toJson(), "isClient": true}
                          : {...(element as AdministratorModel).toJson(), "isClient": false},
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
