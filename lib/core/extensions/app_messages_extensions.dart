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

extension ClientEntryMessageExtension on ClientEntryMessageEnum {
  String get printMessage {
    return switch (this) {
      ClientEntryMessageEnum.showUserLogs => 'Show User Logs',
      ClientEntryMessageEnum.addNewAccount => 'Add New Account',
      ClientEntryMessageEnum.showUserInformation => 'Show User Information',
      ClientEntryMessageEnum.logout => 'Log out',
      ClientEntryMessageEnum.wrongMessage => '',
    };
  }
}
