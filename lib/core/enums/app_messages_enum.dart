part '../extensions/app_messages_extensions.dart';

enum EntryMessageEnum { createAccount, login, exit }

enum AdministratorEntryMessageEnum {
  showLogs,
  showAdminInformation,
  showClientInformations,
  logout,
  shutdownSystem,
  wrongMessage,
}

enum ClientEntryMessageEnum {
  showUserLogs,
  addNewAccount,
  showUserInformation,
  logout,
  wrongMessage,
}
