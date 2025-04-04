part '../extensions/app_messages_extensions.dart';

enum EntryMessageEnum { createAccount, login, exit }

enum RegisterAccountEntryMessageEnum { client, administrator, back, wrongMessage }

enum AdministratorEntryMessageEnum {
  showLogs,
  showAdminInformation,
  showClientInformations,
  logout,
  shutdownSystem,
  wrongMessage,
}

enum ClientEntryMessageEnum {
  chooseAccountForTransactionAction,
  showUserLogs,
  addNewAccount,
  showUserInformation,
  logout,
  wrongMessage,
}

enum ClientTransactionsEntryMessageEnum {
  deposit,
  withdraw,
  transferMoney,
  showBalance,
  back,
  logout,
  wrongMessage,
}

enum ClientTransferMoneyEntryMessageEnum {
  yourAccount,
  otherUserAccount,
  back,
  wrongMessage,
}
