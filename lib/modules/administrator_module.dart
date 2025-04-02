import '../core/enums/app_messages_enum.dart'
    show AdministratorEntryMessageEnum, AdministratorEntryMessageExtension;
import '../core/utils/user_selected_input_conversion.dart';

import '../data/universal_data.dart';
import '../data/models/admistrator_model.dart';

class AdministratorModule {
  const AdministratorModule._();

  static void administratorLoginActions() {
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
        bankData.displayAllLogs();
        break;

      case AdministratorEntryMessageEnum.showAdminInformation:
        print('=========== Your Information is ===========================');
        (userModel as AdministratorModel).displayAccountInformation();
        break;

      case AdministratorEntryMessageEnum.showClientInformations:
        print('=========== Clients Information is ===========================');
        bankData.displayAllClientInformation();
        break;

      case AdministratorEntryMessageEnum.logout:
        isLogged = false;
        break;

      case AdministratorEntryMessageEnum.shutdownSystem:
        isRunSystem = false;
        isLogged = false;
        print('We will shutdown System');
        break;

      default:
        print('You Enter Wrong action\nplease try again');
    }
  }
}
