import 'dart:io';

import '../core/enums/user_actions_enums.dart';
import '../data/models/admistrator_model.dart';
import '../data/universal_data.dart';
import '../data/models/client_model.dart';

import '../core/constants/app_constants.dart';

import './client_module.dart';
import './administrator_module.dart';

class LoginModule {
  const LoginModule._internal();

  static void loginProcess() {
    late String userID;
    late String password;

    print('=== Login Process ===');

    try {
      for (int index = AppConstants.loginMaxTry; index > 0; index--) {
        print('Please Enter your userID');
        userID = stdin.readLineSync()?.trim() ?? '';
        print('Please Enter your Password');
        password = stdin.readLineSync()?.trim() ?? '';

        userModel = bankData.loginAction(userID: userID, password: password);
        if (userModel != null) {
          isLogged = true;
          break;
        } else {
          print('Error: Please check Your UserID, or password');
          index - 1 > 0 ? print('Your Remain tries are ${index - 1}') : throw ();
        }
      }
      if (userModel is ClientModel) {
        ClientModule.clientLoginActions();
      } else {
        bankData.addLog(
          userID: userID,
          userName: userModel?.userName ?? '',
          accountNumber: (userModel as AdministratorModel).accountNumber,
          userActionState: UserActionsEnums.loginAction,
          receiveAccountNumber: null,
          amount: null,
        );
        AdministratorModule.administratorLoginActions();
      }
      print('Thanks For Use Our System\nWe need to see you again');
    } catch (e) {
      print('/n');
    }
  }
}
