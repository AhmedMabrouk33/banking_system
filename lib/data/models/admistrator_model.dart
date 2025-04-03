import 'package:uuid/v4.dart';

import 'user_model.dart';
import '../../core/extensions/date_time_extension.dart';

class AdministratorModel extends UserModel {
  final String _token;
  final String accountNumber;

  AdministratorModel({
    String? accountNumberIN,
    required super.password,
    required super.pin,
    required super.userName,
    required String token,
    super.createTime,
    super.userID,
  }) : accountNumber = accountNumberIN ?? 'ADD - ${UuidV4().generate().split(' - ').first}',
       _token = token;

  @override
  void displayAccountInformation() {
    super.displayAccountInformation();
    print('''User Name : $userName
    Created Date : ${createdTime.customFormate}
    ''');
  }

  factory AdministratorModel.fromJson(Map<String, dynamic> json) {
    return AdministratorModel(
      userID: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      accountNumberIN: json['accountNumber'] ?? '',
      password: json['password'] ?? '',
      createTime: DateTime.tryParse(json['createdTime'].toString()) ?? DateTime.now(),
      pin: json['pin'] ?? '',
      token: json['token'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), "accountNumber": accountNumber, "token": _token, "accounts": []};
  }
}
