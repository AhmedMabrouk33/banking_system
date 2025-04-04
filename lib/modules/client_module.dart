import 'dart:io';

import '../core/constants/app_constants.dart';

import '../core/enums/app_messages_enum.dart'
    show
        ClientEntryMessageEnum,
        ClientEntryMessageExtension,
        ClientTransactionsEntryMessageEnum,
        ClientTransactionsEntryMessageExtension,
        ClientTransferMoneyEntryMessageEnum,
        ClientTransferMoneyEntryMessageExtension;
import '../core/enums/user_actions_enums.dart';

import '../core/utils/user_selected_input_conversion.dart';

import '../data/universal_data.dart';
import '../data/models/client_model.dart';

class ClientModule {
  const ClientModule._();

  static final RegExp _cancelRegExp = RegExp(r'^(c|cancel)$', caseSensitive: false);
  static final RegExp _backRegExp = RegExp(r'^(b|back)$', caseSensitive: false);

  static void clientLoginActions() {
    do {
      print('PLease Choose what you want to DO');
      for (int index = 0; index < (ClientEntryMessageEnum.values.length - 1); index++) {
        print('${index + 1} ${ClientEntryMessageEnum.values[index].printMessage}');
      }
      var chosenMessage = convertUserSelectedInput<ClientEntryMessageEnum>(
        ClientEntryMessageEnum.values,
      );
      switch (chosenMessage) {
        case ClientEntryMessageEnum.chooseAccountForTransactionAction:
          _clientChooseAccountActions();

          break;

        case ClientEntryMessageEnum.addNewAccount:
          _clientAddNewAccountProcess();

          break;
        case ClientEntryMessageEnum.showUserInformation:
          userModel?.displayAccountInformation();
          bankData.addLog(
            userActionState: UserActionsEnums.showHisAccountInformationAction,
            receiveAccountNumber: null,
            amount: null,
          );
          break;

        case ClientEntryMessageEnum.showUserLogs:
          bankData.displayLogs(userModel?.userID);
          bankData.addLog(
            userActionState: UserActionsEnums.showHisLogAction,
            receiveAccountNumber: null,
            amount: null,
          );
          break;

        case ClientEntryMessageEnum.logout:
          isLogged = false;
          bankData.saveClientImage((userModel as ClientModel));
          bankData.addLog(
            userActionState: UserActionsEnums.logoutAction,
            receiveAccountNumber: null,
            amount: null,
          );
          break;
        default:
          print('You Entered wrong input\nPlease Try Again');
      }
    } while (isLogged);
  }

  static void _clientAddNewAccountProcess() {
    for (int index = AppConstants.loginMaxTry - 1; index > 0; index--) {
      print('Please Set The Account of money\nIn case cancel Action please press "C"');
      stdout.write("Enter a number to select an option: ");

      // Read user input and try parsing it
      String userInput = stdin.readLineSync() ?? '';

      if (_cancelRegExp.hasMatch(userInput)) {
        break;
      } else {
        double? convertedBalance = double.tryParse(userInput);
        if (convertedBalance != null) {
          (userModel as ClientModel).createNewAccount(amount: convertedBalance);
          print('Your new Account is ');
          print("============================================");
          (userModel as ClientModel).displaySelectedAccountInformation();
          bankData.addLog(
            userActionState: UserActionsEnums.createNewAccountAction,
            receiveAccountNumber: null,
            amount: convertedBalance,
          );
          break;
        }
      }
      print('You Entered wrong input\nPlease try again\nRemained Tries is ${index - 1}');
      print('================================================================================');
    }
  }

  static void _clientChooseAccountActions() {
    bool isBackAction = false;
    String userEntryValue;
    do {
      print('=====================================');
      print('Choose Your Account to make transaction');
      (userModel as ClientModel).displayAvailableAccounts();

      stdout.write("Enter a Account number or Back {b} to go to main screen: ");

      // Read user input and try parsing it
      userEntryValue = stdin.readLineSync() ?? '';

      if (_backRegExp.hasMatch(userEntryValue)) {
        isBackAction = true;
        break;
      } else {
        if ((userModel as ClientModel).checkAccountInput(userEntryValue)) {
          isBackAction = false;
          break;
        } else {
          print('========================================================================');
          print('You Entered Wrong Input');
          print('========================================================================');
        }
      }
    } while (true);

    if (!isBackAction) {
      _clientTransactionsActions();
    }
  }

  static void _clientTransactionsActions() {
    var tmpUserModel = userModel as ClientModel;
    bool isTransactionAction = true;
    double? userEnteredAmount;
    do {
      print('Choose Your Transaction Action');
      for (int index = 0; index < (ClientTransactionsEntryMessageEnum.values.length - 1); index++) {
        print('${index + 1} ${ClientTransactionsEntryMessageEnum.values[index].printMessage}');
      }
      var chosenMessage = convertUserSelectedInput<ClientTransactionsEntryMessageEnum>(
        ClientTransactionsEntryMessageEnum.values,
      );

      if (chosenMessage == ClientTransactionsEntryMessageEnum.deposit) {
        userEnteredAmount = _getClientAmount(actionTypeMessage: 'Deposit');
        if (userEnteredAmount != null) {
          tmpUserModel.deposit(userEnteredAmount);
          bankData.addLog(
            userActionState: UserActionsEnums.withdrawalsAction,
            receiveAccountNumber: null,
            amount: userEnteredAmount,
          );
        }
      } else if (chosenMessage == ClientTransactionsEntryMessageEnum.withdraw) {
        if (tmpUserModel.isNotEmptyBalance()) {
          userEnteredAmount = _getClientAmount(actionTypeMessage: 'Withdraw');
          if (userEnteredAmount != null) {
            if (tmpUserModel.withdraw(userEnteredAmount)) {
              bankData.addLog(
                userActionState: UserActionsEnums.withdrawalsAction,
                receiveAccountNumber: null,
                amount: userEnteredAmount,
              );
            } else {
              print('You Can\'t Withdraw this Amount \nPlease Check you balance');
              print(
                '================================================================================',
              );
            }
          }
        } else {
          print('You Can\'t Make Withdraw Action \nPlease Deposit Amount to make this process');
          print('================================================================================');
        }
      } else if (chosenMessage == ClientTransactionsEntryMessageEnum.transferMoney) {
        if (tmpUserModel.isNotEmptyBalance()) {
          _transferMoneyProcess();
        } else {
          print('You Can\'t Make Transfer Action \nPlease Deposit Amount to make this process');
          print('================================================================================');
        }
      } else if (chosenMessage == ClientTransactionsEntryMessageEnum.showBalance) {
        print('Your balance : ${(userModel as ClientModel).getSelectedAccountBalance}');
        bankData.addLog(
          userActionState: UserActionsEnums.showAccountBalance,
          receiveAccountNumber: null,
          amount: userEnteredAmount,
        );
      } else if (chosenMessage == ClientTransactionsEntryMessageEnum.back) {
        isTransactionAction = false;
      } else if (chosenMessage == ClientTransactionsEntryMessageEnum.logout) {
        isTransactionAction = false;
        isLogged = false;
        bankData.saveClientImage((userModel as ClientModel));
        bankData.addLog(
          userActionState: UserActionsEnums.logoutAction,
          receiveAccountNumber: null,
          amount: userEnteredAmount,
        );
      }
    } while (isTransactionAction);
  }

  static double? _getClientAmount({required String actionTypeMessage}) {
    for (int index = AppConstants.loginMaxTry - 1; index > 0; index--) {
      stdout.write("Enter $actionTypeMessage Amount or cancel {c} to cancel process: ");

      // Read user input and try parsing it
      String userInput = stdin.readLineSync() ?? '';

      if (_cancelRegExp.hasMatch(userInput)) {
        break;
      } else {
        double? convertedBalance = double.tryParse(userInput);
        if ((convertedBalance != null) && (convertedBalance > 0)) {
          return convertedBalance;
        } else if (convertedBalance != null) {
          print('You Entered wrong input\nPlease try again\nRemained Tries is ${index - 1}');
          print('================================================================================');
        } else {
          print(
            'You Can\'t entered Negative Number or Zero \nPlease try again\nRemained Tries is ${index - 1}',
          );
          print('================================================================================');
        }
      }
    }
    return null;
  }

  static void _transferMoneyProcess() {
    double? userInputAmount;
    var chosenMessage = ClientTransferMoneyEntryMessageEnum.wrongMessage;
    do {
      print('PLease Choose what you want to DO');
      for (
        int index = 0;
        index < (ClientTransferMoneyEntryMessageEnum.values.length - 1);
        index++
      ) {
        print('${index + 1} ${ClientTransferMoneyEntryMessageEnum.values[index].printMessage}');
      }
      chosenMessage = convertUserSelectedInput<ClientTransferMoneyEntryMessageEnum>(
        ClientTransferMoneyEntryMessageEnum.values,
      );

      if (chosenMessage == ClientTransferMoneyEntryMessageEnum.yourAccount) {
        List<String> availableUserTransferAccounts =
            (userModel as ClientModel).readAvailableAccountToTransferMoney();
        int? selectedTransferAccountIndex;
        for (int index = AppConstants.loginMaxTry - 1; index > 0; index--) {
          print('Please select Account which will transfer to it');
          for (int index = 0; index < availableUserTransferAccounts.length; index++) {
            print('${index + 1}. ${availableUserTransferAccounts[index]} ');
          }
          stdout.write("Enter a Account index to select an option or `B` for Back: ");

          // Read user input and try parsing it
          String userEntry = stdin.readLineSync() ?? '';

          if (_backRegExp.hasMatch(userEntry)) {
            break;
          } else {
            selectedTransferAccountIndex = int.tryParse(userEntry);
            if ((selectedTransferAccountIndex != null) &&
                (selectedTransferAccountIndex < availableUserTransferAccounts.length) &&
                (selectedTransferAccountIndex >= 0)) {
              break;
            } else {
              selectedTransferAccountIndex = null;
              print('Wrong user input\nPlease Try again\nYour remain tries ${index - 1}');
            }
          }
        }

        if (selectedTransferAccountIndex != null) {
          userInputAmount = _getClientAmount(actionTypeMessage: 'Transfer Money');
          if (userInputAmount != null) {
            if ((userModel as ClientModel).completedTransferAmount(
              transferAccount: availableUserTransferAccounts[selectedTransferAccountIndex],
              transferAmount: userInputAmount,
            )) {
              bankData.addLog(
                userActionState: UserActionsEnums.transfersAction,
                receiveAccountNumber: availableUserTransferAccounts[selectedTransferAccountIndex],
                amount: userInputAmount,
              );
            } else {
              print('Error please check your balance\nPlease Try again');
              print('============================================================================');
            }
          }
        }
      } else if (chosenMessage == ClientTransferMoneyEntryMessageEnum.otherUserAccount) {
        _transferToAnotherAccountProcess();
      }
    } while (chosenMessage == ClientTransferMoneyEntryMessageEnum.wrongMessage);
  }

  static void _transferToAnotherAccountProcess() {
    stdout.write("Enter Transfer account Number or `b` for back: ");

    // Read user input and try parsing it
    String? transferAccount = stdin.readLineSync();

    if (transferAccount != null) {
      Map<String, dynamic> transferAccountData = bankData.getTransferAccountData(
        accountNumber: transferAccount,
      );
      if (transferAccount.isNotEmpty) {
        double? transferAmount = _getClientAmount(actionTypeMessage: 'Transfer Money');
        if (transferAmount != null) {
          if ((userModel as ClientModel).withdraw(transferAmount)) {
            bankData.transformAmountMoney(
              transferUserData: transferAccountData,
              transferAmount: transferAmount,
            );
            print(
              'You transferred ${transferAmount.toStringAsFixed(2)} to account $transferAccount',
            );
            print('========================================================');
            bankData.addLog(
              userActionState: UserActionsEnums.transfersAction,
              receiveAccountNumber: transferAccount,
              amount: transferAmount,
            );
          } else {
            print('Please Check your balance\nTry again');
            print('========================================================');
          }
        }
      } else {
        print('Can\'t complete the transfer process\nPlease check Account Number and try again');
      }
    } else {
      print('We couldn\'t complete Transfer process\nPlease try Again');
      print(
        '======================================================================================================',
      );
    }
  }
}
