part of 'wallet_bloc.dart';

enum WalletStatus {
  initial,
  loading,
  loaded,
  error,
  logOut,
  update,
  moneyTransferedSuccess,
  moneyTransferedFailure,
  addMoneyWebViewUrl,
  walletPageReUpdate,
  showPaymentGateway,
  paymentUpdate,
  walletPaymentSuccess,
  walletPaymentFailure,
  saveCardSuccess,
}

class WalletState extends Equatable {
  final WalletStatus status;
  final String textDirection;
  final String languageCode;
  final bool isLoading;
  final bool firstLoad;
  final bool loadMore;
  final List<PaymentGateway> walletPaymentGatways;
  final List<WalletHistoryData> walletHistoryList;
  final WalletPagination? walletPaginations;
  final WalletResponseModel? walletResponse;
  final WithdrawModel? withdrawResponse;
  final bool showRefresh;
  final PaymentAuthData? paymentAuthData;
  final CardFormEditController? cardFormEditController;
  final CardFieldInputDetails? cardDetails;
  final List<SavedCardDetails> savedCardsList;
  final dynamic addMoney;
  final UserDetail? userDetail;
  final List withdrawData;
  final List bankDetails;
  final List choosenBankList;
  final bool firstWithdrawLoad;
  final bool isWithdrawLoading;
  final bool addBankInfo;
  final int? choosenBankMethod;
  final bool editBank;
  final int? choosenPaymentIndex;
  final String dropdownValue;

  const WalletState({
    required this.status,
    required this.textDirection,
    required this.languageCode,
    required this.isLoading,
    required this.firstLoad,
    required this.loadMore,
    required this.walletPaymentGatways,
    required this.walletHistoryList,
    required this.walletPaginations,
    required this.walletResponse,
    required this.withdrawResponse,
    required this.showRefresh,
    required this.paymentAuthData,
    required this.cardFormEditController,
    required this.cardDetails,
    required this.savedCardsList,
    required this.addMoney,
    required this.userDetail,
    required this.withdrawData,
    required this.bankDetails,
    required this.choosenBankList,
    required this.firstWithdrawLoad,
    required this.isWithdrawLoading,
    required this.addBankInfo,
    required this.choosenBankMethod,
    required this.editBank,
    required this.choosenPaymentIndex,
    required this.dropdownValue,
  });

  static WalletState initial() => const WalletState(
        status: WalletStatus.initial,
        textDirection: 'ltr',
        languageCode: '',
        isLoading: false,
        firstLoad: true,
        loadMore: false,
        walletPaymentGatways: [],
        walletHistoryList: [],
        walletPaginations: null,
        walletResponse: null,
        withdrawResponse: null,
        showRefresh: false,
        paymentAuthData: null,
        cardFormEditController: null,
        cardDetails: null,
        savedCardsList: [],
        addMoney: null,
        userDetail: null,
        withdrawData: [],
        bankDetails: [],
        choosenBankList: [],
        firstWithdrawLoad: true,
        isWithdrawLoading: false,
        addBankInfo: false,
        choosenBankMethod: null,
        editBank: false,
        choosenPaymentIndex: 0,
        dropdownValue: 'user',
      );

  WalletState copyWith({
    WalletStatus? status,
    String? textDirection,
    String? languageCode,
    bool? isLoading,
    bool? firstLoad,
    bool? loadMore,
    List<PaymentGateway>? walletPaymentGatways,
    List<WalletHistoryData>? walletHistoryList,
    WalletPagination? walletPaginations,
    WalletResponseModel? walletResponse,
    WithdrawModel? withdrawResponse,
    bool? showRefresh,
    PaymentAuthData? paymentAuthData,
    CardFormEditController? cardFormEditController,
    CardFieldInputDetails? cardDetails,
    List<SavedCardDetails>? savedCardsList,
    dynamic addMoney,
    UserDetail? userDetail,
    List? withdrawData,
    List? bankDetails,
    List? choosenBankList,
    bool? firstWithdrawLoad,
    bool? isWithdrawLoading,
    bool? addBankInfo,
    int? choosenBankMethod,
    bool? editBank,
    int? choosenPaymentIndex,
    String? dropdownValue,
  }) =>
      WalletState(
        status: status ?? this.status,
        textDirection: textDirection ?? this.textDirection,
        languageCode: languageCode ?? this.languageCode,
        isLoading: isLoading ?? this.isLoading,
        firstLoad: firstLoad ?? this.firstLoad,
        loadMore: loadMore ?? this.loadMore,
        walletPaymentGatways: walletPaymentGatways ?? this.walletPaymentGatways,
        walletHistoryList: walletHistoryList ?? this.walletHistoryList,
        walletPaginations: walletPaginations ?? this.walletPaginations,
        walletResponse: walletResponse ?? this.walletResponse,
        withdrawResponse: withdrawResponse ?? this.withdrawResponse,
        showRefresh: showRefresh ?? this.showRefresh,
        paymentAuthData: paymentAuthData ?? this.paymentAuthData,
        cardFormEditController:
            cardFormEditController ?? this.cardFormEditController,
        cardDetails: cardDetails ?? this.cardDetails,
        savedCardsList: savedCardsList ?? this.savedCardsList,
        addMoney: addMoney ?? this.addMoney,
        userDetail: userDetail ?? this.userDetail,
        withdrawData: withdrawData ?? this.withdrawData,
        bankDetails: bankDetails ?? this.bankDetails,
        choosenBankList: choosenBankList ?? this.choosenBankList,
        firstWithdrawLoad: firstWithdrawLoad ?? this.firstWithdrawLoad,
        isWithdrawLoading: isWithdrawLoading ?? this.isWithdrawLoading,
        addBankInfo: addBankInfo ?? this.addBankInfo,
        choosenBankMethod: choosenBankMethod ?? this.choosenBankMethod,
        editBank: editBank ?? this.editBank,
        choosenPaymentIndex: choosenPaymentIndex ?? this.choosenPaymentIndex,
        dropdownValue: dropdownValue ?? this.dropdownValue,
      );

  @override
  List get props => [
        status,
        textDirection,
        languageCode,
        isLoading,
        firstLoad,
        loadMore,
        walletPaymentGatways.map((e) => e).hashCode,
        walletHistoryList.map((e) => e).hashCode,
        walletPaginations,
        walletResponse,
        withdrawResponse,
        showRefresh,
        paymentAuthData,
        cardFormEditController,
        cardDetails,
        savedCardsList.map((e) => e).hashCode,
        addMoney,
        userDetail,
        withdrawData.map((e) => e).hashCode,
        bankDetails.map((e) => e).hashCode,
        choosenBankList.map((e) => e).hashCode,
        firstWithdrawLoad,
        isWithdrawLoading,
        addBankInfo,
        choosenBankMethod,
        editBank,
        choosenPaymentIndex,
        dropdownValue,
      ];
}
