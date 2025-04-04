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

  String get accountNumber => _accounts[selectedAccountIndex].accountNumber;

  String get getSelectedAccountBalance =>
      _accounts[selectedAccountIndex].balance.toStringAsFixed(2);

  int getInputAccountIndex(String accountNumber) {
    return _accounts.indexWhere((e) => e.accountNumber == accountNumber);
  }

  // * --------------------- Display actions --------------------------------------------- //
  bool checkAccountInput(String chosenAccountEntry) {
    int? tmpConvertedChosenAccountEntry = int.tryParse(chosenAccountEntry);
    if ((tmpConvertedChosenAccountEntry != null) &&
        (tmpConvertedChosenAccountEntry > 0) &&
        (tmpConvertedChosenAccountEntry <= _accounts.length)) {
      selectedAccountIndex = tmpConvertedChosenAccountEntry - 1;
      return true;
    }
    return false;
  }

  // * --------------------- Display actions --------------------------------------------- //

  void displaySelectedAccountInformation() {
    print(_accounts[selectedAccountIndex].displayAccountInformation());
  }

  ///
  /// Method Name: displayAccountInformation
  /// This Function Show:
  /// `User Name`, `Created Time`, Accounts and it's amount.
  ///
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

  ///
  /// Method Name: displayClientInformation
  /// Return : String
  /// This Function Show:
  /// `User Name`, `Created Time`, Number of account which user have.
  ///
  String displayClientInformation() {
    String tmpReturnString = 'Client Name : ${super.userName}\n';
    tmpReturnString += 'Created Date : ${super.createdTime.customFormate}\n';
    tmpReturnString += 'Accounts Number : ${_accounts.length}';

    return tmpReturnString;
  }

  void createNewAccount({required double amount}) {
    _accounts = [..._accounts, AccountModel(balance: amount)];
  }

  void displayAvailableAccounts() {
    for (int index = 0; index < _accounts.length; index++) {
      print('${index + 1} ${_accounts[index].displayAccountInformation()}');
    }
    print('b for back');
  }

  List<String> readAvailableAccountToTransferMoney() {
    List<String> tmpAvailableAccounts = [];
    for (int index = 0; index < _accounts.length; index++) {
      if (_accounts[selectedAccountIndex] != _accounts[index]) {
        tmpAvailableAccounts = [...tmpAvailableAccounts, _accounts[index].accountNumber];
      }
    }
    return tmpAvailableAccounts;
  }

  bool isNotEmptyBalance() {
    return _accounts[selectedAccountIndex].balance > 0;
  }

  // * --------------------- Transactions actions --------------------------------------------- //

  void deposit(double addAmount, {bool showBalance = true}) {
    _accounts[selectedAccountIndex].newBalance =
        _accounts[selectedAccountIndex].balance + addAmount;
    print('Your New balance is ${_accounts[selectedAccountIndex].balance}');
  }

  bool withdraw(double withDrawAmount) {
    if (withDrawAmount <= _accounts[selectedAccountIndex].balance) {
      _accounts[selectedAccountIndex].newBalance =
          _accounts[selectedAccountIndex].balance - withDrawAmount;
      print('Your New balance is ${_accounts[selectedAccountIndex].balance}');
      return true;
    }
    return false;
  }

  bool completedTransferAmount({required String transferAccount, required double transferAmount}) {
    if (transferAmount <= _accounts[selectedAccountIndex].balance) {
      int transferAccountIndex = _accounts.indexWhere((e) => e.accountNumber == transferAccount);
      if (transferAccountIndex != -1) {
        withdraw(transferAmount);
        _accounts[transferAccountIndex].newBalance =
            _accounts[transferAccountIndex].balance + transferAmount;
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  // ------------------------------------------------------------------------------------------------------- //

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

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "accounts": _accounts.isNotEmpty ? _accounts.map((element) => element.toJson()).toList() : [],
      "accountNumber": null,
      "token": null,
    };
  }
}
