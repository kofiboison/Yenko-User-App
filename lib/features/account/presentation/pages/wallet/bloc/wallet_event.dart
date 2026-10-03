part of 'wallet_bloc.dart';

abstract class WalletEvent {}

class WalletGetDirectionEvent extends WalletEvent {}

class WalletUpdateEvent extends WalletEvent {}

class WalletPageInitEvent extends WalletEvent {
  final WalletPageArguments arg;

  WalletPageInitEvent({required this.arg});
}

class WalletPageScrollListenerEvent extends WalletEvent {}

class WithdrawPageScrollListenerEvent extends WalletEvent {}

class LoadMoreUpdateEvent extends WalletEvent {
  final bool loadMore;

  LoadMoreUpdateEvent({required this.loadMore});
}

class GetWalletHistoryListEvent extends WalletEvent {
  final int pageIndex;
  GetWalletHistoryListEvent({required this.pageIndex});
}

class TransferMoneySelectedEvent extends WalletEvent {
  final String selectedTransferAmountMenuItem;

  TransferMoneySelectedEvent({required this.selectedTransferAmountMenuItem});
}

class MoneyTransferedEvent extends WalletEvent {
  final String transferMobile;
  final String role;
  final String transferAmount;

  MoneyTransferedEvent(
      {required this.transferMobile,
      required this.role,
      required this.transferAmount});
}

class PaymentAuthenticationEvent extends WalletEvent {
  final PaymentMethodArguments arg;

  PaymentAuthenticationEvent({required this.arg});
}

class AddCardDetailsEvent extends WalletEvent {
  BuildContext context;
  UserDetail userDetail;

  AddCardDetailsEvent({
    required this.context,
    required this.userDetail,
  });
}

class CardListEvent extends WalletEvent {}

class DeleteCardEvent extends WalletEvent {
  final String cardId;

  DeleteCardEvent({required this.cardId});
}

class ShowPaymentGatewayEvent extends WalletEvent {}

class AddMoneyFromCardEvent extends WalletEvent {
  final String amount;
  final String cardToken;

  AddMoneyFromCardEvent({required this.amount, required this.cardToken});
}

class PaymentOnTapEvent extends WalletEvent {
  final int selectedPaymentIndex;

  PaymentOnTapEvent({required this.selectedPaymentIndex});
}

class AddMoneyWebViewUrlEvent extends WalletEvent {
  dynamic from;
  dynamic url;
  dynamic userId;
  dynamic requestId;
  dynamic currencySymbol;
  dynamic money;
  BuildContext context;

  AddMoneyWebViewUrlEvent({
    this.url,
    this.from,
    this.userId,
    this.requestId,
    this.currencySymbol,
    this.money,
    required this.context,
  });
}


class AddBankEvent extends WalletEvent {
  final int? choosen;

  AddBankEvent({
    required this.choosen,
  });
}

class EditBankEvent extends WalletEvent {
  final int? choosen;

  EditBankEvent({
    required this.choosen,
  });
}

class UpdateBankDetailsEvent extends WalletEvent {
  final dynamic body;
  UpdateBankDetailsEvent({required this.body});
}

class GetWithdrawDataEvent extends WalletEvent {
  final int pageIndex;
  GetWithdrawDataEvent({required this.pageIndex});
}

class GetWithdrawInitEvent extends WalletEvent {}

class RequestWithdrawEvent extends WalletEvent {
  final String amount;
  RequestWithdrawEvent({required this.amount});
}

class GetBankDetails extends WalletEvent {}

class UpdateShowRefreshEvent extends WalletEvent {
  final bool showRefresh;

  UpdateShowRefreshEvent({required this.showRefresh});
}

class OnCardChangeEvent extends WalletEvent {
  final CardFieldInputDetails? card;

  OnCardChangeEvent({required this.card});
}

class AddMoneyUpdateEvent extends WalletEvent {
  final dynamic addMoney;

  AddMoneyUpdateEvent({required this.addMoney});
}