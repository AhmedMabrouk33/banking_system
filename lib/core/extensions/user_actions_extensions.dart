import '../enums/user_actions_enums.dart';

extension UserActionString on UserActionsEnums {
  String get name {
    return switch (this) {
      UserActionsEnums.depositsAction => 'Deposits',
      UserActionsEnums.withdrawalsAction => 'Withdrawals',
      UserActionsEnums.transfersAction => 'Transfers',
      UserActionsEnums.showAction => 'Show',
    };
  }
}
