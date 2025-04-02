import './core/utils/json_helper.dart';
import './data/universal_data.dart';
import './data/models/bank_model.dart';

import './core/enums/app_messages_enum.dart';
import './core/utils/user_selected_input_conversion.dart';

import './modules/login_module.dart';

void runApp() async {
  try {
    Map<String, dynamic> json = await JsonHelper.readJson();
    bankData = BankModel.fromJson(json);
  } catch (e) {
    print('Error : $e');
    bankData = BankModel.empty(
      bankName: 'DJ',
      administratorToken: [
        "2005091e-deb7-44ca-a4ea-f27bb709efb8",
        "4b72ae0a-51ae-4be7-b40b-3816722fd93d",
        "52ae62cf-aebe-4c7c-8cc9-0f94da0c1005",
        "0a6a613d-ea51-49cb-8fca-d4da3b3110fd",
      ],
    );
  } finally {
    isRunSystem = true;
    print(bankData.toString());
    late EntryMessageEnum chosenMessage;
    do {
      print('=========== Welcome to Bank ${bankData.bankName} ===========');
      print('PLease Choose what you want to DO');
      for (int index = 0; index < EntryMessageEnum.values.length; index++) {
        print('${index + 1} ${EntryMessageEnum.values[index].printMessage}');
      }
      chosenMessage = convertUserSelectedInput(EntryMessageEnum.values);

      if (chosenMessage == EntryMessageEnum.createAccount) {
      } else if (chosenMessage == EntryMessageEnum.login) {
        LoginModule.loginProcess();
      } else {
        print('''You Entered Wrong Choose
 Thanks for Use Our banking system
 ============================================================

 ''');
      }
    } while (isRunSystem);
  }
  
  print('Please Wait Until System close\nIt will Tack Time');
  try {
    await JsonHelper.writeJson(bankData.toJson());
  } catch (e) {
    print('Error: $e');
  }
}
