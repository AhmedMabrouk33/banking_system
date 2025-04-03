import '../core/enums/app_messages_enum.dart'
    show AdministratorEntryMessageEnum, AdministratorEntryMessageExtension;
import '../core/enums/user_actions_enums.dart';
import '../core/utils/user_selected_input_conversion.dart';

import '../data/universal_data.dart';
import '../data/models/admistrator_model.dart';

class AdministratorModule {
  const AdministratorModule._();

  static void administratorLoginActions() {
    do {
      print('PLease Choose what you want to DO');
      for (int index = 0; index < (AdministratorEntryMessageEnum.values.length - 1); index++) {
        print('${index + 1} ${AdministratorEntryMessageEnum.values[index].printMessage}');
      }
      var chosenMessage = convertUserSelectedInput<AdministratorEntryMessageEnum>(
        AdministratorEntryMessageEnum.values,
      );

      switch (chosenMessage) {
        case AdministratorEntryMessageEnum.showLogs:
          print('=========== System Log is ===========================');
          bankData.displayLogs(null);
          bankData.addLog(
            userActionState: UserActionsEnums.showLogAction,
            receiveAccountNumber: null,
            amount: null,
          );
          break;

        case AdministratorEntryMessageEnum.showAdminInformation:
          print('=========== Your Information is ===========================');
          (userModel as AdministratorModel).displayAccountInformation();
          bankData.addLog(
            userActionState: UserActionsEnums.showHisAccountInformationAction,
            receiveAccountNumber: null,
            amount: null,
          );
          break;

        case AdministratorEntryMessageEnum.showClientInformations:
          print('=========== Clients Information is ===========================');
          bankData.displayAllClientInformation();
          bankData.addLog(
            userActionState: UserActionsEnums.showAllAccountsInformationAction,
            receiveAccountNumber: null,
            amount: null,
          );
          break;

        case AdministratorEntryMessageEnum.logout:
          isLogged = false;
          bankData.addLog(
            userActionState: UserActionsEnums.logoutAction,
            receiveAccountNumber: null,
            amount: null,
          );
          break;

        case AdministratorEntryMessageEnum.shutdownSystem:
          isRunSystem = false;
          isLogged = false;
          bankData.addLog(
            userActionState: UserActionsEnums.shutdownSystemAction,
            receiveAccountNumber: null,
            amount: null,
          );
          print('We will shutdown System');
          break;

        default:
          print('You Enter Wrong action\nplease try again');
      }
    } while (isLogged);
  }
}
