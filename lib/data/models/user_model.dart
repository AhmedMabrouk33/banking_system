import 'package:uuid/v4.dart';

class UserModel {
  final String userId;
  final String _password;
  final String _pin;
  final String userName;
  final DateTime _createdTime;

  UserModel.empty({this.userId = '', String password = '', this.userName = '', String pin = ''})
    : _password = password,
      _pin = pin,
      _createdTime = DateTime.now();

  UserModel({
    String? userID,
    required String password,
    required String pin,
    required this.userName,
    DateTime? createTime,
  }) : userId = userID ?? UuidV4().generate().split(' - ').first,
       _password = password,
       _pin = pin,
       _createdTime = createTime ?? DateTime.now();

  bool isSamePassword(String password) {
    return (password == _password) || (password == _pin);
  }

  bool isSameUserID(String userID) {
    return userID == userId;
  }

  void displayAccountInformation() {
    print('You Information is ');
  }

  DateTime get createdTime => _createdTime;

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "userName": userName,
      "password": _password,
      "createdTime": _createdTime.toLocal(),
      "pin": _pin,
    };
  }
}
