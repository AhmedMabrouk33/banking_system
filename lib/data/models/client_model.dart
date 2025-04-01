import '../../core/extensions/date_time_extension.dart';

import 'user_model.dart';
import 'account_model.dart';

class ClientModel extends UserModel {
  List<AccountModel> _accounts;
  int selectedAccountIndex;

  ClientModel.withAccount({
    required super.userName,
    required super.password,
    required super.pin,
    this.selectedAccountIndex = 0,
    required double accountBalance,
  }) : _accounts = [AccountModel(balance: accountBalance)];

  ClientModel._internal({
    required super.userID,
    required super.createTime,
    required super.userName,
    required super.password,
    required super.pin,
    required this.selectedAccountIndex,
    required List<AccountModel> accounts,
  }) : _accounts = accounts;

  @override
  void displayAccountInformation() {
    super.displayAccountInformation();
    print('''User Name : $userName
    Created Date : ${createdTime.customFormate}
    ''');
    if (_accounts.isNotEmpty) {
      for (int index = 0; index < _accounts.length; index++) {
        print(_accounts[index].displayFullInformation);
      }
    } else {
      print('You have No Account');
    }
  }

  void createNewAccount({required double amount}) {
    _accounts = [..._accounts, AccountModel(balance: amount)];
  }

  void displayAvailableAccounts() {
    for (int index = 0; index < _accounts.length; index++) {
      print('${index + 1} ${_accounts[index].displayAccountInformation()}');
    }
  }

  bool isAvailableBalance(double balance) {
    return balance > _accounts[selectedAccountIndex].balance;
  }

  void deposit(double addAmount) {
    _accounts[selectedAccountIndex].newBalance =
        _accounts[selectedAccountIndex].balance + addAmount;
  }

  void withdraw(double withDrawAmount) {
    _accounts[selectedAccountIndex].newBalance =
        _accounts[selectedAccountIndex].balance - withDrawAmount;
  }

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    List<AccountModel> tmpAccounts = [];
    if ((json['accounts'] ?? []).isNotEmpty) {
      for (var account in (json['accounts'] ?? [])) {
        tmpAccounts = [...tmpAccounts, AccountModel.fromJson(account)];
      }
    }
    return ClientModel._internal(
      userID: json['userId'] ?? '',
      createTime: DateTime.tryParse(json['createdTime'].toString()) ?? DateTime.now(),
      userName: json['userName'] ?? '',
      password: json['password'] ?? '',
      pin: json['pin'] ?? '',
      selectedAccountIndex: 0,
      accounts: tmpAccounts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "accounts": _accounts.isNotEmpty ? _accounts.map((element) => element.toJson()).toList() : [],
    };
  }
}
