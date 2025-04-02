import 'dart:io';

import '../core/constants/app_constants.dart';

import '../core/enums/register_field_enum.dart';
import '../core/enums/app_messages_enum.dart'
    show RegisterAccountEntryMessageEnum, RegisterAccountEntryMessageExtension;

import '../core/extensions/custom_string_extension.dart';

import '../core/utils/user_selected_input_conversion.dart';

import '../data/universal_data.dart' show isLogged, bankData, userModel;

import './client_module.dart';
import './administrator_module.dart';

class RegisterModule {
  const RegisterModule._();

  static void createNewAccount() {
    List<String> userRequiredInput = List.filled(RegisterFieldEnum.values.length, '');
    RegisterAccountEntryMessageEnum selectedCreatedAccount =
        RegisterAccountEntryMessageEnum.wrongMessage;
    do {
      print('PLease Choose what you want to DO');
      for (int index = 0; index < (RegisterAccountEntryMessageEnum.values.length - 1); index++) {
        print('${index + 1} ${RegisterAccountEntryMessageEnum.values[index].printMessage}');
      }
      selectedCreatedAccount = convertUserSelectedInput<RegisterAccountEntryMessageEnum>(
        RegisterAccountEntryMessageEnum.values,
      );
    } while (selectedCreatedAccount == RegisterAccountEntryMessageEnum.wrongMessage);

    if (selectedCreatedAccount != RegisterAccountEntryMessageEnum.back) {
      int userInputLength =
          selectedCreatedAccount == RegisterAccountEntryMessageEnum.administrator
              ? RegisterFieldEnum.values.length
              : (RegisterFieldEnum.values.length - 1);

      selectedCreatedAccount != RegisterAccountEntryMessageEnum.administrator
          ? userRequiredInput.last = 'NAN'
          : null;

      String? userInput;
      String? validateInput;
      print("We need Your information\nPlease Enter it carefully");
      for (int index = 0; index < userInputLength; index++) {
        if ((RegisterFieldEnum.values[index] != RegisterFieldEnum.confirmPassword) &&
            (RegisterFieldEnum.values[index] != RegisterFieldEnum.confirmPin)) {
          validateInput = null;
        } else if (RegisterFieldEnum.values[index] == RegisterFieldEnum.confirmPassword) {
          validateInput = userRequiredInput[RegisterFieldEnum.password.index];
        } else {
          validateInput = userRequiredInput[RegisterFieldEnum.pin.index];
        }
        userInput = RegisterModule._()._getUserInputData(
          RegisterFieldEnum.values[index].consolMessage,
          validateInput,
          (index == userInputLength - 1) &&
              (selectedCreatedAccount == RegisterAccountEntryMessageEnum.administrator),
        );

        if (userInput != null) {
          userRequiredInput[index] = userInput;
          continue;
        }

        print('Sorry We can\'t complete\nPlease try again');
        break;
      }

      if (!userRequiredInput.contains('')) {
        isLogged = true;
        userModel = bankData.createAccount(
          userName: userRequiredInput[RegisterFieldEnum.userName.index],
          password: userRequiredInput[RegisterFieldEnum.password.index],
          pin: userRequiredInput[RegisterFieldEnum.pin.index],
          token: userRequiredInput[RegisterFieldEnum.token.index],
          isAdministrator: selectedCreatedAccount == RegisterAccountEntryMessageEnum.administrator,
        );

        print('Please save This information to login again');
        print('Your user ID is ${userModel?.userID}');

        selectedCreatedAccount == RegisterAccountEntryMessageEnum.administrator
            ? AdministratorModule.administratorLoginActions()
            : ClientModule.clientLoginActions();
      }
    }
  }

  String? _getUserInputData(String inputMessage, String? validateInput, bool isToken) {
    String? tmpString;

    for (int index = AppConstants.loginMaxTry; index > 0; index--) {
      stdout.write("Enter $inputMessage : ");
      tmpString = stdin.readLineSync() ?? '';
      if (!isToken && tmpString.validated(validateInput)) {
        break;
      } else {
        if (bankData.validatedAdministratorToken(tmpString)) {
          break;
        } else {
          print('Your token is Wrong\nPlease try Again');
        }
      }
      print('Remain Tries are ${index - 1}');
      tmpString = null;
    }
    return tmpString;
  }
}

// Validate on each action. Max input is 3 times for each one,
