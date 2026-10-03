import 'dart:io';

import 'package:bus_booking/features/account/domain/models/admin_chat_history_model.dart';
import 'package:bus_booking/features/account/domain/models/admin_chat_model.dart';
import 'package:bus_booking/features/account/domain/models/booking_history_model.dart';
import 'package:bus_booking/features/account/domain/models/make_ticket_model.dart';
import 'package:bus_booking/features/account/domain/models/makecomplaint_model.dart';
import 'package:bus_booking/features/account/domain/models/notifications_model.dart';
import 'package:bus_booking/features/account/domain/models/service_location_model.dart';
import 'package:bus_booking/features/account/domain/models/ticket_list_model.dart';
import 'package:bus_booking/features/account/domain/models/ticket_names_model.dart';
import 'package:bus_booking/features/account/domain/models/view_ticket_model.dart';
import 'package:bus_booking/features/account/domain/repositories/acc_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/network/network.dart';
import '../../domain/models/bank_details_model.dart';
import '../../domain/models/bank_details_update_model.dart';
import '../../domain/models/card_list_model.dart';
import '../../domain/models/delete_account_model.dart';
import '../../domain/models/logout_model.dart';
import '../../domain/models/payment_method_model.dart';
import '../../domain/models/faq_model.dart';
import '../../domain/models/walletpage_model.dart';
import '../../domain/models/withdraw_model.dart';
import '../../domain/models/withdraw_request_model.dart';

class AccUsecase {
  final AccRepository accRepository;

  const AccUsecase(this.accRepository);

  Future<Either<Failure, dynamic>> updateDetailsButton(
      {required String email,
      required String name,
      required String gender,
      required String profileImage,
      String? mapType,
      bool? updateFcmToken}) async {
    return accRepository.updateDetailsButton(
        email: email,
        name: name,
        gender: gender,
        profileImage: profileImage,
        mapType: mapType,
        updateFcmToken: updateFcmToken);
  }

  // logout
  Future<Either<Failure, LogoutResponseModel>> logout() async {
    return accRepository.logout();
  }

  // Delete account
  Future<Either<Failure, DeleteAccountResponseModel>>
      deleteUserAccount() async {
    return accRepository.deleteAccount();
  }

  // Notifications
  Future<Either<Failure, NotificationResponseModel>> notificationDetails(
      {String? pageNo}) async {
    return accRepository.getUserNotificationsDetails(pageNo: pageNo);
  }

  //Delete Notification
  Future<Either<Failure, dynamic>> deleteNotification(String id) async {
    return accRepository.deleteNotification(id);
  }

  //make complaints
  Future<Either<Failure, ComplaintResponseModel>> makeComplaint(
      {String? complaintType}) async {
    return accRepository.makeComplaintList(complaintType: complaintType);
  }

  //make complaints button
  Future<Either<Failure, dynamic>> makeComplaintButton(
      String complaintTitleId, String complaintText, String requestId) async {
    return accRepository.makeComplaintButton(
        complaintTitleId, complaintText, requestId);
  }

  // Booking History
  Future<Either<Failure, BookingHistoryModel>> bookingHistoryDetails(
      String historyFilter,
      {String? pageNo}) async {
    return accRepository.getBookingHistoryDetails(historyFilter,
        pageNo: pageNo);
  }

  //support ticket
  Future<Either<Failure, TicketNamesModel>> supportTicketTitles(
      {required bool isFromRequest}) async {
    return accRepository.supportTicketTitles(isFromRequest: isFromRequest);
  }

  Future<Either<Failure, ServiceLocationModel>> getServiceLocation() async {
    return accRepository.getServiceLocation();
  }

  Future<Either<Failure, MakeTicketModel>> makeTicket({
    required String titleId,
    required String description,
    required String serviceLocationId,
    required String requestId,
    required List<File> attachments,
  }) async {
    return accRepository.makeTicket(
        titleId: titleId,
        description: description,
        serviceLocationId: serviceLocationId,
        attachments: attachments,
        requestId: requestId);
  }

  Future<Either<Failure, TicketListModel>> getTicketList() async {
    return accRepository.getTicketList();
  }

  Future<Either<Failure, ViewTicketModel>> viewTicket(
      {required String ticketId}) async {
    return accRepository.viewTicket(ticketId: ticketId);
  }

  Future<Either<Failure, ReplyMessage>> ticketReplyMessage(
      {required String id, required String replyMessage}) async {
    return accRepository.ticketReplyMessage(id: id, replyMessage: replyMessage);
  }

  //Faq
  Future<Either<Failure, FaqResponseModel>> getFaqDetail() async {
    return accRepository.getFaqDetails();
  }

  //sos
  Future<Either<Failure, dynamic>> deleteSosContact(String id) async {
    return accRepository.deleteSos(id);
  }

  Future<Either<Failure, dynamic>> addSosContact({
    required String name,
    required String number,
  }) async {
    return accRepository.addSos(
      name: name,
      number: number,
    );
  }

  //admin chat
  Future<Either<Failure, AdminChatModel>> sendAdminMessages({
    required String newChat,
    required String message,
    required String chatId,
  }) async {
    return accRepository.sendAdminMessage(
      newChat: newChat,
      message: message,
      chatId: chatId,
    );
  }

  Future<Either<Failure, AdminChatHistoryModel>>
      getAdminChatHistoryDetail() async {
    return accRepository.getAdminChatHistoryDetails();
  }

  Future<Either<Failure, dynamic>> adminMessageSeenDetail(String chatId) async {
    return accRepository.adminMessageSeenDetails(chatId);
  }

  //wallet
  Future<Either<Failure, CardListModel>> cardList() async {
    return accRepository.cardList();
  }

  Future<Either<Failure, PaymentAuthModel>> stripeSetupIntent() async {
    return accRepository.stripeSetupIntent();
  }

  Future<Either<Failure, dynamic>> stripSaveCardDetails({
    required String paymentMethodId,
    required String last4Number,
    required String cardType,
    required String validThrough,
  }) async {
    return accRepository.stripeSaveCardDetails(
        paymentMethodId: paymentMethodId,
        last4Number: last4Number,
        cardType: cardType,
        validThrough: validThrough);
  }

  Future<Either<Failure, dynamic>> deleteCard({required String cardId}) async {
    return accRepository.deleteCard(cardId: cardId);
  }

  Future<Either<Failure, WalletResponseModel>> getWalletDetail(int page) async {
    return accRepository.getWalletHistoryDetails(page);
  }

  Future addMoneyToWalletFromCard({
    required String amount,
    required String cardToken,
  }) async {
    return accRepository.addMoneyToWalletFromCard(
        amount: amount, cardToken: cardToken);
  }

  Future<Either<Failure, dynamic>> moneyTransfer(
      {required String transferMobile,
      required String role,
      required String transferAmount}) async {
    return accRepository.moneyTransfer(
        transferMobile: transferMobile,
        role: role,
        transferAmount: transferAmount);
  }

  Future<Either<Failure, dynamic>> cancelBookingApi(
      {required String journeyId,
      required String userId,
      required String ticketNumber}) async {
    return accRepository.cancelBookingApi(
        journeyId: journeyId, userId: userId, ticketNumber: ticketNumber);
  }

  Future<Either<Failure, BankDetailsModel>> getBankDetails() async {
    return accRepository.getBankDetails();
  }

  Future<Either<Failure, BankDetailsUpdateModel>> updateBankDetails(
      {required dynamic body}) async {
    return accRepository.updateBankDetails(body: body);
  }

  Future<Either<Failure, WithdrawModel>> getWithdrawData(page) async {
    return accRepository.getWithdrawData(page);
  }

  Future<Either<Failure, WithdrawRequestModel>> requestWithdraw(
      {required String amount}) async {
    return accRepository.requestWithdraw(amount: amount);
  }

//invoice download
  Future<Either<Failure, dynamic>> invoiceDownload(
      {required String journeyId}) async {
    return accRepository.invoiceDownload(journeyId: journeyId);
  }

  // User Reviews
  Future<Either<Failure, dynamic>> userReview(
      {required String ticketNumber,
      required String ratings,
      required String feedBack,
      required String journeyId}) async {
    return accRepository.userReview(
        ticketNumber: ticketNumber,
        ratings: ratings,
        feedBack: feedBack,
        journeyId: journeyId);
  }
}
