import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bus_booking/core/utils/custom_loader.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../di/locator.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../home/domain/models/user_details_model.dart';
import '../../../../domain/models/card_list_model.dart';
import '../../../../domain/models/payment_method_model.dart';
import '../../../../domain/models/walletpage_model.dart';
import '../../../../domain/models/withdraw_model.dart';
import '../../../../application/usecase/acc_usecases.dart';

part 'wallet_event.dart';

part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final profileEditFormKey = GlobalKey<FormState>();
  final paymentKey = GlobalKey();
  List<TextEditingController> bankDetailsTextEditControllers = [];
  ScrollController scrollController = ScrollController();

  WalletBloc() : super(WalletState.initial()) {
    on<WalletUpdateEvent>((event, emit) =>
        emit(state.copyWith(status: WalletStatus.update, isLoading: false)));
    on<UpdateShowRefreshEvent>(
        (event, emit) => emit(state.copyWith(showRefresh: event.showRefresh)));
    on<OnCardChangeEvent>(
        (event, emit) => emit(state.copyWith(cardDetails: event.card)));
    on<AddMoneyUpdateEvent>(
        (event, emit) => emit(state.copyWith(addMoney: event.addMoney)));
    on<LoadMoreUpdateEvent>(
        (event, emit) => emit(state.copyWith(loadMore: event.loadMore)));
    // Wallet Page
    on<WalletGetDirectionEvent>(walletGetDirection);
    on<WalletPageInitEvent>(walletInitEvent);
    on<WalletPageScrollListenerEvent>(walletPageScrollListener);
    on<GetWalletHistoryListEvent>(_getWalletHistoryList);
    on<TransferMoneySelectedEvent>(_onTransferMoneySelected);
    on<MoneyTransferedEvent>(moneyTransfered);
    on<PaymentAuthenticationEvent>(paymentAuth);
    on<CardListEvent>(getCardList);
    on<DeleteCardEvent>(deleteCard);
    on<ShowPaymentGatewayEvent>(showPaymentGateways);
    on<AddCardDetailsEvent>(addCardDetails);
    on<AddMoneyFromCardEvent>(addMoneyFromCard);
    on<PaymentOnTapEvent>(_selectedPaymentIndex);

    // Withdraw Page
    on<GetWithdrawInitEvent>(withdrawInitEvent);
    on<WithdrawPageScrollListenerEvent>(withdrawPageScrollListener);
    on<GetWithdrawDataEvent>(getWithdrawData);
    on<RequestWithdrawEvent>(requestWithdraw);
    on<GetBankDetails>(getBankDetails);
    on<AddBankEvent>(addBankFunc);
    on<EditBankEvent>(editBankFunc);
    on<UpdateBankDetailsEvent>(updateBankDetails);
    on<AddMoneyWebViewUrlEvent>(addMoneyWebViewUrl);
  }
//Get Direction
  Future<void> walletGetDirection(
      WalletGetDirectionEvent event, Emitter<WalletState> emit) async {
    emit(state.copyWith(status: WalletStatus.loading));
    final languageCode = await AppSharedPreference.getSelectedLanguageCode();
    final textDirection = await AppSharedPreference.getLanguageDirection();
    emit(state.copyWith(
        status: WalletStatus.loaded,
        languageCode: languageCode,
        textDirection: textDirection));
  }

  Future<void> walletInitEvent(
      WalletPageInitEvent event, Emitter<WalletState> emit) async {
    // transferPhonenumber.clear();
    // transferAmount.clear();
    emit(state.copyWith(
        userDetail: event.arg.userData, firstLoad: true, isLoading: true));
    add(GetWalletHistoryListEvent(pageIndex: 1));
    add(WalletPageScrollListenerEvent());
  }

  Future<void> walletPageScrollListener(
      WalletPageScrollListenerEvent event, Emitter<WalletState> emit) async {
    scrollController.addListener(
      () {
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            !state.isLoading &&
            !state.loadMore) {
          if (state.walletPaginations != null &&
              state.walletPaginations!.pagination.currentPage <
                  state.walletPaginations!.pagination.totalPages) {
            add(LoadMoreUpdateEvent(loadMore: true));
            add(GetWalletHistoryListEvent(
                pageIndex:
                    state.walletPaginations!.pagination.currentPage + 1));
          } else {
            if (state.walletPaginations!.pagination.currentPage ==
                state.walletPaginations!.pagination.totalPages) {
              add(LoadMoreUpdateEvent(loadMore: false));
            }
          }
        }
      },
    );
  }

  Future<void> _onTransferMoneySelected(
      TransferMoneySelectedEvent event, Emitter<WalletState> emit) async {
    emit(state.copyWith(dropdownValue: event.selectedTransferAmountMenuItem));
  }

  FutureOr<void> moneyTransfered(
      MoneyTransferedEvent event, Emitter<WalletState> emit) async {
    emit(state.copyWith(isLoading: true));
    final data = await serviceLocator<AccUsecase>().moneyTransfer(
        transferMobile: event.transferMobile,
        role: event.role,
        transferAmount: event.transferAmount);
    data.fold(
      (error) {
        debugPrint(error.toString());
        showToast(message: error.message.toString());
        emit(state.copyWith(
            isLoading: false, status: WalletStatus.moneyTransferedFailure));
      },
      (success) {
        add(GetWalletHistoryListEvent(
            pageIndex: state.walletPaginations!.pagination.currentPage));
        emit(state.copyWith(
            isLoading: false, status: WalletStatus.moneyTransferedSuccess));
      },
    );
  }

  Future<void> paymentAuth(
      PaymentAuthenticationEvent event, Emitter<WalletState> emit) async {
    emit(state.copyWith(userDetail: event.arg.userData));
    final data = await serviceLocator<AccUsecase>().stripeSetupIntent();
    data.fold((error) {
      debugPrint(error.toString());
    }, (success) {
      emit(state.copyWith(paymentAuthData: success.data));
    });
  }

  FutureOr getCardList(CardListEvent event, Emitter<WalletState> emit) async {
    final data = await serviceLocator<AccUsecase>().cardList();
    data.fold((error) {
      debugPrint(error.toString());
    }, (success) {
      List<SavedCardDetails>? savelist = List.of(state.savedCardsList);
      savelist.clear();
      savelist = success.data;
      emit(state.copyWith(
          status: WalletStatus.loaded, savedCardsList: savelist));
    });
  }

  FutureOr deleteCard(DeleteCardEvent event, Emitter<WalletState> emit) async {
    emit(state.copyWith(status: WalletStatus.loading));
    final data =
        await serviceLocator<AccUsecase>().deleteCard(cardId: event.cardId);
    data.fold((error) {
      debugPrint(error.toString());
      showToast(message: error.message.toString());
      emit(state.copyWith(status: WalletStatus.loaded));
    }, (success) {
      List<SavedCardDetails>? savelist = List.of(state.savedCardsList);
      savelist.removeWhere((element) => element.id == event.cardId);
      emit(state.copyWith(
          status: WalletStatus.loaded, savedCardsList: savelist));
    });
  }

  FutureOr showPaymentGateways(
      ShowPaymentGatewayEvent event, Emitter<WalletState> emit) async {
    emit(state.copyWith(status: WalletStatus.showPaymentGateway));
  }

  FutureOr addCardDetails(
      AddCardDetailsEvent event, Emitter<WalletState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      final paymentMethod = await Stripe.instance.createPaymentMethod(
          params: PaymentMethodParams.card(
              paymentMethodData: PaymentMethodData(
                  billingDetails: BillingDetails(
                      name: event.userDetail.username,
                      phone: event.userDetail.mobile))));

      final data = await serviceLocator<AccUsecase>().stripSaveCardDetails(
          paymentMethodId: paymentMethod.id,
          last4Number: paymentMethod.card.last4!,
          cardType: paymentMethod.card.brand!,
          validThrough:
              '${paymentMethod.card.expMonth}/${paymentMethod.card.expYear}');
      data.fold((error) {
        printWrapped(error.toString());
        emit(state.copyWith(isLoading: false));
      }, (success) {
        if (success['success']) {
          emit(state.copyWith(isLoading: false));
          emit(state.copyWith(status: WalletStatus.saveCardSuccess));
        } else {
          emit(state.copyWith(isLoading: false));
          showToast(message: success['message'].toString());
        }
      });
    } on StripeException catch (e) {
      emit(state.copyWith(isLoading: false));
      printWrapped(e.toString());
      showToast(message: e.error.localizedMessage.toString());
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      printWrapped(e.toString());
      showToast(message: 'Please enter the valid data');
    }
  }

  Future<void> addMoneyFromCard(
      AddMoneyFromCardEvent event, Emitter<WalletState> emit) async {
    emit(state.copyWith(status: WalletStatus.loading));
    final data = await serviceLocator<AccUsecase>().addMoneyToWalletFromCard(
        amount: event.amount, cardToken: event.cardToken);
    data.fold((error) {
      printWrapped(error.toString());
      showToast(message: error.message.toString());
      emit(state.copyWith(status: WalletStatus.walletPaymentFailure));
    }, (success) {
      emit(state.copyWith(
          status: success['success']
              ? WalletStatus.walletPaymentSuccess
              : WalletStatus.walletPaymentFailure));
    });
  }

  //wallet
  FutureOr<void> _getWalletHistoryList(
      GetWalletHistoryListEvent event, Emitter<WalletState> emit) async {
    if (state.firstLoad) {
      emit(state.copyWith(status: WalletStatus.loading));
    }
    final data =
        await serviceLocator<AccUsecase>().getWalletDetail(event.pageIndex);
    data.fold(
      (error) {
        emit(state.copyWith(
          status: WalletStatus.loaded,
          isLoading: false,
          loadMore: false,
          firstLoad: false,
        ));
      },
      (success) {
        emit(state.copyWith(
          status: WalletStatus.loaded,
          isLoading: false,
          loadMore: false,
          firstLoad: false,
          walletResponse: success,
          walletPaymentGatways: success.paymentGateways,
        ));

        if (event.pageIndex == 1) {
          emit(state.copyWith(walletHistoryList: success.walletHistory.data));
        } else {
          if (success.walletHistory.data.isNotEmpty) {
            List<WalletHistoryData>? wallet = List.of(state.walletHistoryList);
            wallet.addAll(success.walletHistory.data);
            emit(state.copyWith(walletHistoryList: wallet));
          }
        }
        emit(state.copyWith(walletPaginations: success.walletHistory.meta));
      },
    );
  }

  Future<void> _selectedPaymentIndex(
      PaymentOnTapEvent event, Emitter<WalletState> emit) async {
    emit(state.copyWith(choosenPaymentIndex: event.selectedPaymentIndex));
  }

  // get bank details
  FutureOr<void> getBankDetails(
      GetBankDetails event, Emitter<WalletState> emit) async {
    final data = await serviceLocator<AccUsecase>().getBankDetails();
    data.fold(
      (error) {
        ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
            SnackBar(content: MyText(text: error.message.toString())));
      },
      (success) {
        emit(state.copyWith(bankDetails: success.data));
      },
    );
  }

  //withdraw init
  Future<void> withdrawInitEvent(
      GetWithdrawInitEvent event, Emitter<WalletState> emit) async {
    emit(state.copyWith(
        firstWithdrawLoad: true, isWithdrawLoading: true, addBankInfo: false));
    add(GetWithdrawDataEvent(pageIndex: 1));
    add(GetBankDetails());
    add(WithdrawPageScrollListenerEvent());
  }

  Future<void> withdrawPageScrollListener(
      WithdrawPageScrollListenerEvent event, Emitter<WalletState> emit) async {
    scrollController.addListener(
      () {
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            !state.isLoading &&
            !state.loadMore) {
          if (state.withdrawResponse != null &&
              state.withdrawResponse!.pagination != null) {
            if (state.withdrawResponse!.pagination!.currentPage <
                state.withdrawResponse!.pagination!.totalPages) {
              add(LoadMoreUpdateEvent(loadMore: true));
              add(GetWithdrawDataEvent(
                  pageIndex:
                      state.withdrawResponse!.pagination!.currentPage + 1));
            } else if (state.withdrawResponse!.pagination!.currentPage ==
                state.withdrawResponse!.pagination!.totalPages) {
              add(LoadMoreUpdateEvent(loadMore: false));
            }
          }
        }
      },
    );
  }

  //get witdraw data
  FutureOr<void> getWithdrawData(
      GetWithdrawDataEvent event, Emitter<WalletState> emit) async {
    final data =
        await serviceLocator<AccUsecase>().getWithdrawData(event.pageIndex);

    data.fold(
      (error) {
        showToast(message: error.message.toString());
      },
      (success) {
        List<dynamic> newData = success.data;

        List<dynamic> updatedWithdrawData = event.pageIndex == 1
            ? newData
            : [...state.withdrawData, ...newData];

        final uniqueWithdrawData =
            {for (var e in updatedWithdrawData) e['id']: e}.values.toList();

        emit(state.copyWith(
          withdrawResponse: success,
          isWithdrawLoading: false,
          firstWithdrawLoad: false,
          withdrawData: uniqueWithdrawData,
        ));
      },
    );
  }

  // FutureOr<void> getWithdrawData(
  //     GetWithdrawDataEvent event, Emitter<WalletState> emit) async {
  //   final data =
  //       await serviceLocator<AccUsecase>().getWithdrawData(event.pageIndex);
  //   data.fold(
  //     (error) {
  //       ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(SnackBar(
  //               content:
  //                   MyText(text :error.message.toString())));
  //     },
  //     (success) {
  //       List<dynamic> listData = success.data;
  //       List withDraw = List.of(state.withdrawData);
  //       withDraw.addAll(listData);
  //       withDraw.toSet();
  //       emit(state.copyWith(
  //         withdrawResponse: success,
  //         isWithdrawLoading: false,
  //         firstWithdrawLoad: false,
  //         withdrawData: withDraw));
  //     },
  //   );
  // }

//request withdraw
  FutureOr<void> requestWithdraw(
      RequestWithdrawEvent event, Emitter<WalletState> emit) async {
    emit(state.copyWith(status: WalletStatus.loading));
    final data = await serviceLocator<AccUsecase>()
        .requestWithdraw(amount: event.amount);
    data.fold(
      (error) {
        emit(state.copyWith(status: WalletStatus.loaded));
        ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
            SnackBar(content: MyText(text: error.message.toString())));
      },
      (success) {
        emit(state.copyWith(status: WalletStatus.loaded));
        if (success.success == true) {
          add(GetWithdrawDataEvent(pageIndex: 1));
        }
      },
    );
  }

  //ontap event
  Future<void> addBankFunc(
      AddBankEvent event, Emitter<WalletState> emit) async {
    if (state.addBankInfo) {
      emit(state.copyWith(addBankInfo: false));
    } else {
      if (event.choosen != null) {
        emit(state.copyWith(choosenBankMethod: event.choosen));
      }
      emit(state.copyWith(
          choosenBankList: state.bankDetails[event.choosen!]['fields']
              ['data']));
      bankDetailsTextEditControllers.clear();
      // ignore: unused_local_variable
      for (var e in state.bankDetails[event.choosen!]['fields']['data']) {
        bankDetailsTextEditControllers.add(TextEditingController());
      }
      if (state.bankDetails[event.choosen!]['bank_info']['data'] != null &&
          state.bankDetails[event.choosen!]["bank_info"]['data'].toString() !=
              '[]') {
        // if (bankDetails[choosenBankMethod!]['method_name'] == 'bank account') {
        //   bankAccountName.text = bankDetails[choosenBankMethod!]
        //       ['bank_info']['data']['account_number'];
        //   bankIfsc.text = bankDetails[choosenBankMethod!]['bank_info']
        //       ['data']['branch_identification_code'];
        // } else {
        //   upiText.text = bankDetails[choosenBankMethod!]['bank_info']
        //           ['data']['upi']
        //       .toString();
        // }
      } else {
        emit(state.copyWith(editBank: false));
      }
      emit(state.copyWith(addBankInfo: true));
    }
    add(WalletUpdateEvent());
  }

  //ontap event
  Future<void> editBankFunc(
      EditBankEvent event, Emitter<WalletState> emit) async {
    if (state.editBank) {
      emit(state.copyWith(editBank: false));
    } else {
      if (event.choosen != null) {
        emit(state.copyWith(choosenBankMethod: event.choosen));
      }
      emit(state.copyWith(
          choosenBankList: state.bankDetails[event.choosen!]['fields']
              ['data']));
      bankDetailsTextEditControllers.clear();
      // ignore: unused_local_variable
      for (var e in state.bankDetails[event.choosen!]['fields']['data']) {
        bankDetailsTextEditControllers.add(TextEditingController(
            text: state.bankDetails[event.choosen!]['bank_info']['data'][0]
                ['value']));
      }
      emit(state.copyWith(editBank: true));
    }
    add(WalletUpdateEvent());
  }

  //update bank details
  FutureOr<void> updateBankDetails(
      UpdateBankDetailsEvent event, Emitter<WalletState> emit) async {
    emit(state.copyWith(status: WalletStatus.loading));
    final data =
        await serviceLocator<AccUsecase>().updateBankDetails(body: event.body);
    data.fold(
      (error) {
        emit(state.copyWith(
            status: WalletStatus.loaded, editBank: false, addBankInfo: false));
        ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
            SnackBar(content: MyText(text: error.message.toString())));
      },
      (success) {
        add(GetBankDetails());
        emit(state.copyWith(
            status: WalletStatus.loaded, editBank: false, addBankInfo: false));
        ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
            SnackBar(
                content: MyText(
                    text:
                        AppLocalizations.of(navigatorKey.currentState!.context)!
                            .paymentMethodSuccess)));
      },
    );
  }

  FutureOr addMoneyWebViewUrl(
      AddMoneyWebViewUrlEvent event, Emitter<WalletState> emit) async {
    String paymentUrl = '';
    if (event.from == '1') {
      paymentUrl =
          '${event.url}?amount=${event.money}&payment_for=request&currency=${event.currencySymbol}&user_id=${event.userId.toString()}&request_id=${event.requestId.toString()}';
    } else {
      paymentUrl =
          '${event.url}?amount=${event.money}&payment_for=wallet&currency=${event.currencySymbol}&user_id=${event.userId.toString()}';
    }
    final Uri uri = Uri.parse(paymentUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
      );
    } else {
      showToast(message: "Could not open payment page");
    }
  }
}
