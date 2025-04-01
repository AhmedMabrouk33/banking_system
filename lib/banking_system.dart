import 'dart:io';

import './core/utils/json_helper.dart';
import './data/universal_data.dart';
import 'data/models/bank_model.dart';

void runApp() async {
  try {
    isRunSystem = true;
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
    print(bankData.toString());
    do {
      print('Welcome to Bank ${bankData.bankName}');
      String userChoose = stdin.readLineSync() ?? '';
      isRunSystem = false;
    } while (isRunSystem);
  }
}
