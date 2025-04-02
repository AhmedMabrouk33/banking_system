import '../enums/user_actions_enums.dart';

extension UserActionString on UserActionsEnums {
  String get name {
    return switch (this) {
      UserActionsEnums.depositsAction => 'Deposits',
      UserActionsEnums.withdrawalsAction => 'Withdrawals',
      UserActionsEnums.transfersAction => 'Transfers',
      UserActionsEnums.showLogAction => 'Show Log',
      UserActionsEnums.showAllAccountsInformationAction => 'Show all account information',
      UserActionsEnums.showHisAccountInformationAction => 'Show his account information',
      UserActionsEnums.loginAction => 'Log in action',
      UserActionsEnums.createNewAccountAction => 'Create new account',
      UserActionsEnums.registeredAction => 'Registered',
      UserActionsEnums.shutdownSystemAction => 'Shutdown system',
      UserActionsEnums.logoutAction => 'Log out',
    };
  }
}
