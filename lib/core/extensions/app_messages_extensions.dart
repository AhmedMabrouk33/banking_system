part of '../enums/app_messages_enum.dart';

extension EntryMessageExtension on EntryMessageEnum {
  String get printMessage {
    return switch (this) {
      EntryMessageEnum.createAccount => 'Create New Account',
      EntryMessageEnum.login => 'Log in Existed Account',
      EntryMessageEnum.exit => 'Exit',
    };
  }
}

extension AdministratorEntryMessageExtension on AdministratorEntryMessageEnum {
  String get printMessage {
    return switch (this) {
      AdministratorEntryMessageEnum.showLogs => 'Show System Logs',
      AdministratorEntryMessageEnum.showAdminInformation => 'Show your information',
      AdministratorEntryMessageEnum.showClientInformations => 'Show All Client Information',
      AdministratorEntryMessageEnum.shutdownSystem => 'Shutdown System',
      AdministratorEntryMessageEnum.logout => 'Log out',
      AdministratorEntryMessageEnum.wrongMessage => '',
    };
  }
}
