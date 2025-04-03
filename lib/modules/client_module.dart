import 'dart:io';

import '../core/constants/app_constants.dart';

import '../core/enums/app_messages_enum.dart'
    show ClientEntryMessageEnum, ClientEntryMessageExtension;
import '../core/enums/user_actions_enums.dart';

import '../core/utils/user_selected_input_conversion.dart';

import '../data/universal_data.dart';
import '../data/models/client_model.dart';

class ClientModule {
  const ClientModule._();

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

      if (RegExp(r'^(c|cancel)$', caseSensitive: false).hasMatch(userInput)) {
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

  void _clientTransactionsActions() {
    // TODO: Set here user transaction options.
  }
}
