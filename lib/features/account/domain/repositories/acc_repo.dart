import 'dart:io';

import 'package:bus_booking/features/account/domain/models/admin_chat_history_model.dart';
import 'package:bus_booking/features/account/domain/models/admin_chat_model.dart';
import 'package:bus_booking/features/account/domain/models/booking_history_model.dart';
import 'package:bus_booking/features/account/domain/models/card_list_model.dart';
import 'package:bus_booking/features/account/domain/models/make_ticket_model.dart';
import 'package:bus_booking/features/account/domain/models/makecomplaint_model.dart';
import 'package:bus_booking/features/account/domain/models/notifications_model.dart';
import 'package:bus_booking/features/account/domain/models/payment_method_model.dart';
import 'package:bus_booking/features/account/domain/models/service_location_model.dart';
import 'package:bus_booking/features/account/domain/models/ticket_list_model.dart';
import 'package:bus_booking/features/account/domain/models/ticket_names_model.dart';
import 'package:bus_booking/features/account/domain/models/view_ticket_model.dart';
import 'package:bus_booking/features/account/domain/models/walletpage_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/network/network.dart';
import '../models/bank_details_model.dart';
import '../models/bank_details_update_model.dart';
import '../models/delete_account_model.dart';
import '../models/logout_model.dart';
import '../models/faq_model.dart';
import '../models/withdraw_model.dart';
import '../models/withdraw_request_model.dart';

abstract class AccRepository {
  // Future<Either<Failure, dynamic>> updateDetails(
  //     {required String email,
  //     required String name,
  //     required String gender,
  //     required String age,
  //     required String profileImage});

  Future<Either<Failure, dynamic>> updateDetailsButton(
      {required String email,
      required String name,
      required String gender,
      required String profileImage,
      // required String age,
      String? mapType,
      bool? updateFcmToken});

  Future<Either<Failure, LogoutResponseModel>> logout();
  Future<Either<Failure, DeleteAccountResponseModel>> deleteAccount();

  Future<Either<Failure, NotificationResponseModel>>
      getUserNotificationsDetails({String? pageNo});

  Future<Either<Failure, dynamic>> deleteNotification(String id);

  Future<Either<Failure, ComplaintResponseModel>> makeComplaintList(
      {String? complaintType});

  Future<Either<Failure, dynamic>> makeComplaintButton(
      String complaintTitleId, String complaintText, String requestId);
  Future<Either<Failure, BookingHistoryModel>> getBookingHistoryDetails(
      String historyFilter,
      {String? pageNo});

  //support ticket
  Future<Either<Failure, TicketNamesModel>> supportTicketTitles(
      {required bool isFromRequest});

  Future<Either<Failure, ServiceLocationModel>> getServiceLocation();

  Future<Either<Failure, MakeTicketModel>> makeTicket({
    required String titleId,
    required String description,
    required String serviceLocationId,
    required List<File> attachments,
    required String requestId,
  });
  Future<Either<Failure, TicketListModel>> getTicketList();

  Future<Either<Failure, ViewTicketModel>> viewTicket(
      {required String ticketId});
  // Future<Either<Failure, dynamic>> invoiceDownload({required String requestId});

  Future<Either<Failure, ReplyMessage>> ticketReplyMessage(
      {required String id, required String replyMessage});
  Future<Either<Failure, FaqResponseModel>> getFaqDetails();

  //sos

  Future<Either<Failure, dynamic>> addSos({
    required String name,
    required String number,
  });

  Future<Either<Failure, dynamic>> deleteSos(String id);

  //chat admin
  Future<Either<Failure, AdminChatModel>> sendAdminMessage({
    required String newChat,
    required String message,
    required String chatId,
  });

  Future<Either<Failure, AdminChatHistoryModel>> getAdminChatHistoryDetails();

  Future<Either<Failure, dynamic>> adminMessageSeenDetails(String chatId);

  //wallet
  Future<Either<Failure, WalletResponseModel>> getWalletHistoryDetails(
      int page);

  Future<Either<Failure, dynamic>> moneyTransfer({
    required String transferMobile,
    required String role,
    required String transferAmount,
  });
  Future<Either<Failure, PaymentAuthModel>> stripeSetupIntent();

  Future<Either<Failure, dynamic>> stripeSaveCardDetails({
    required String paymentMethodId,
    required String last4Number,
    required String cardType,
    required String validThrough,
  });

  Future<Either<Failure, CardListModel>> cardList();

  Future<Either<Failure, dynamic>> deleteCard({required String cardId});

  Future<Either<Failure, dynamic>> addMoneyToWalletFromCard({
    required String amount,
    required String cardToken,
  });

  Future<Either<Failure, dynamic>> cancelBookingApi(
      {required String journeyId,
      required String userId,
      required String ticketNumber});

  Future<Either<Failure, BankDetailsModel>> getBankDetails();
  Future<Either<Failure, BankDetailsUpdateModel>> updateBankDetails(
      {required dynamic body});
  Future<Either<Failure, WithdrawModel>> getWithdrawData(int page);
  Future<Either<Failure, WithdrawRequestModel>> requestWithdraw(
      {required String amount});

//invoice download
  Future<Either<Failure, dynamic>> invoiceDownload({required String journeyId});

  // User Reviews
  Future<Either<Failure, dynamic>> userReview(
      {required String ticketNumber,
      required String ratings,
      required String feedBack,
      required String journeyId});
}
