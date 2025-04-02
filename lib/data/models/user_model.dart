import 'package:uuid/v4.dart';

import '../../core/extensions/date_time_extension.dart';

class UserModel {
  final String _userId;
  final String _password;
  final String _pin;
  final String userName;
  final DateTime _createdTime;

  UserModel.empty({String userId = '', String password = '', this.userName = '', String pin = ''})
    : _userId = userId,
      _password = password,
      _pin = pin,
      _createdTime = DateTime.now();

  UserModel({
    String? userID,
    required String password,
    required String pin,
    required this.userName,
    DateTime? createTime,
  }) : _userId = userID ?? UuidV4().generate().split(' - ').first,
       _password = password,
       _pin = pin,
       _createdTime = createTime ?? DateTime.now();

  String get userID => _userId;

  bool isSamePassword(String password) {
    return (password == _password) || (password == _pin);
  }

  bool isSameUserID(String userID) {
    return userID == _userId;
  }

  void displayAccountInformation() {
    print('You Information is ');
  }

  DateTime get createdTime => _createdTime;

  Map<String, dynamic> toJson() {
    return {
      "userId": _userId,
      "userName": userName,
      "password": _password,
      "createdTime": _createdTime.toStringConvert,
      "pin": _pin,
    };
  }
}
