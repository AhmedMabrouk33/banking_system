part of '../enums/register_field_enum.dart';

extension RegisterFieldExtension on RegisterFieldEnum {
  String get consolMessage {
    return switch (this) {
      RegisterFieldEnum.userName => 'User Name',
      RegisterFieldEnum.password => 'Password',
      RegisterFieldEnum.confirmPassword => 'Confirm Password',
      RegisterFieldEnum.pin => 'Pin',
      RegisterFieldEnum.confirmPin => 'Confirm Pin',
      RegisterFieldEnum.token => 'Token',
    };
  }
}
