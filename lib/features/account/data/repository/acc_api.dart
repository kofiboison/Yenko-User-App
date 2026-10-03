import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../common/common.dart';
import '../../../../core/network/network.dart';

class AccApi {
  //get booking history
  Future getBookingHistoryApi(String historyFilter, {String? pageNo}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        (pageNo != null && pageNo != '' && pageNo.isNotEmpty)
            ? '${ApiEndpoints.bookingHistory}?$historyFilter&page=$pageNo'
            : '${ApiEndpoints.bookingHistory}?$historyFilter',
        headers: {'Authorization': token},
      );
      debugPrint(response.data.toString());
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  //get notifications
  Future getNotificationsApi({String? pageNo}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        (pageNo != null)
            ? '${ApiEndpoints.notification}?page=$pageNo'
            : ApiEndpoints.notification,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  //delete notification
  Future deleteNotification(String id) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        '${ApiEndpoints.deleteNotification}/$id',
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future updateDetailsButton(
      {required String email,
      required String name,
      required String gender,
      // required String age,
      required String profileImage,
      String? mapType,
      bool? updateFcmToken}) async {
    try {
      dynamic fcmToken;
      final token = await AppSharedPreference.getToken();
      if (updateFcmToken != null && updateFcmToken) {
        fcmToken = await FirebaseMessaging.instance.getToken();
      }
      final formData = FormData.fromMap({
        if (name.isNotEmpty) "name": name,
        if (email.isNotEmpty) "email": email,
        if (gender.isNotEmpty)
          'gender': (gender == 'Male' || gender == 'male')
              ? 'male'
              : (gender == 'Female' || gender == 'female')
                  ? 'female'
                  : 'others',
        if (updateFcmToken != null && updateFcmToken) 'fcm_token': fcmToken,
        if (mapType != null && mapType.isNotEmpty) 'map_type': mapType
      });
      if (profileImage.isNotEmpty) {
        formData.files.add(MapEntry(
            'profile_picture', await MultipartFile.fromFile(profileImage)));
      }
      Response response = await DioProviderImpl().post(
        ApiEndpoints.updateUserDetailsButton,
        body: formData,
        headers: {'Authorization': token},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //logout
  Future logoutApi() async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
        ApiEndpoints.logout,
        headers: {'Authorization': token},
      );
      debugPrint(response.data.toString());
      return response;
    } catch (e) {
      printWrapped(e.toString());
      rethrow;
    }
  }

  //delete account
  Future deleteAccountApi() async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
        ApiEndpoints.deleteAccount,
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
      );
      return response;
    } catch (e) {
      printWrapped(e.toString());
      rethrow;
    }
  }

//Faq
  Future getFaqLists() async {
    try {
      final token = await AppSharedPreference.getToken();
      Position? position = await Geolocator.getLastKnownPosition();
      double lat = (position != null) ? position.latitude : 0;
      double long = (position != null) ? position.longitude : 0;
      Response response = await DioProviderImpl().get(
        '${ApiEndpoints.faqData}/$lat/$long',
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

//make complaint confirm button
  Future makeComplaintButton(
      String complaintTitleId, String complaintText, String requestId) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
        ApiEndpoints.makeComplaintButton,
        headers: {'Authorization': token},
        body: (requestId.isEmpty)
            ? jsonEncode({
                'complaint_title_id': complaintTitleId,
                'description': complaintText,
              })
            : jsonEncode({
                'complaint_title_id': complaintTitleId,
                'description': complaintText,
                'request_id': requestId,
              }),
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  //Make Complaints
  Future makeComplaintsApi({String? complaintType}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        (complaintType == 'general')
            ? '${ApiEndpoints.makeComplaint}?complaint_type=general'
            : '${ApiEndpoints.makeComplaint}?complaint_type=request',
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  //support ticket
  Future supportTicketTitles({required bool isFromRequest}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        isFromRequest
            ? "${ApiEndpoints.ticketTitles}?title_type=request"
            : ApiEndpoints.ticketTitles,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<Response> makeTicket({
    required String titleId,
    required String description,
    required String serviceLocationId,
    required List<File> attachments,
    required String requestId,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();

      List<MultipartFile> filesAttachment = [];

      for (var file in attachments) {
        filesAttachment.add(await MultipartFile.fromFile(file.path,
            filename: file.path.split('/').last));
      }
      FormData formData = FormData.fromMap({
        'title_id': titleId,
        'description': description,
        'service_location_id': serviceLocationId,
        'request_id': requestId,
        if (filesAttachment.isNotEmpty) 'files[]': filesAttachment,
      });

      Response response = await DioProviderImpl().post(
        ApiEndpoints.makeTicket,
        headers: {
          'Authorization': token,
          'Content-Type': 'multipart/form-data'
        },
        body: formData,
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future getTicketList() async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        ApiEndpoints.ticketList,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future viewTicket({required String ticketId}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        "${ApiEndpoints.viewTicket}/$ticketId",
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getServiceLocation() async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        ApiEndpoints.getServiceLocation,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future ticketReplyMessage(
      {required String id, required String replyMessage}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          "${ApiEndpoints.replyTicket}/$id",
          headers: {'Content-Type': 'application/json', 'Authorization': token},
          body: FormData.fromMap({
            'message': replyMessage,
          }));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future addSosContacts({
    required String name,
    required String number,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.addSosContact,
          headers: {'Content-Type': 'application/json', 'Authorization': token},
          body: FormData.fromMap({
            'name': name,
            'number': number,
          }));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  //sos delete
  Future deleteSosContacts(String id) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
        '${ApiEndpoints.deleteSosContact}/$id',
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  //admin chat
  Future sendAdminMessage({
    required String newChat,
    required String message,
    required String chatId,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.sendAdminMessage,
          headers: {'Content-Type': 'application/json', 'Authorization': token},
          body: (chatId.isEmpty)
              ? FormData.fromMap({'new_conversation': 1, 'content': message})
              : FormData.fromMap({
                  'new_conversation': 0,
                  'content': message,
                  'conversation_id': chatId
                }));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future getAdminChatHistoryLists() async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        ApiEndpoints.adminChatHistory,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  //wallet
  Future getWalletHistoryLists(int page) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        "${ApiEndpoints.walletHistory}?page=$page",
        headers: {'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future moneytransfers({
    required String transferMobile,
    required String role,
    required String transferAmount,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.transferMoney,
          headers: {'Content-Type': 'application/json', 'Authorization': token},
          body: FormData.fromMap({
            'mobile': transferMobile,
            'role': role,
            'amount': transferAmount
          }));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future adminMessageSeen(String chatId) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        '${ApiEndpoints.adminMessageSeen}?conversation_id=$chatId',
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // stripeIntent
  Future stripeSetupIntent() async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
        ApiEndpoints.stripCreate,
        headers: {'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // stripSaveCard
  Future stripeSaveCardDetails({
    required String paymentMethodId,
    required String last4Number,
    required String cardType,
    required String validThrough,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response =
          await DioProviderImpl().post(ApiEndpoints.stripSavedCardsDetail,
              headers: {'Authorization': token},
              body: FormData.fromMap({
                'payment_method_id': paymentMethodId,
                'last_number': last4Number,
                'card_type': cardType,
                'valid_through': validThrough
              }));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // cardList
  Future cardList() async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        ApiEndpoints.savedCardList,
        headers: {'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // delete card
  Future deleteCard({required String cardId}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
        ApiEndpoints.deleteCardsDetail + cardId,
        headers: {'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future addMoneyToWalletFromCard({
    required String amount,
    required String cardToken,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.stripAddMoneyToWallet,
          headers: {'Content-Type': 'application/json', 'Authorization': token},
          body: FormData.fromMap({
            'amount': amount,
            'card_token': cardToken,
          }));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future cancelBookingApi(
      {required String journeyId,
      required String userId,
      required String ticketNumber}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.cancelBookingTickets,
          headers: {'Content-Type': 'application/json', 'Authorization': token},
          body: FormData.fromMap({
            'journey_id': journeyId,
            'user_id': userId,
            'ticket_number': ticketNumber,
          }));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  //get bank details
  Future getBankDetails() async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        ApiEndpoints.getBankInfo,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

//update bank details
  Future updateBankDetails({required dynamic body}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
        ApiEndpoints.updateBankInfo,
        body: body,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

//Withdraw amount
  Future getWithdrawData(int page) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        '${ApiEndpoints.getWithdrawData}?page=$page',
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

//Request withdraw
  Future requestWithdraw({required String amount}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
        ApiEndpoints.requestWithdraw,
        body: {'requested_amount': amount},
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  //download invoice
  Future invoiceDownloadApi({required String journeyId}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        '${ApiEndpoints.downloadInvoice}$journeyId?invoice_type=user',
        headers: {'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

// User Ratings
  Future<dynamic> userReviewApi(
      {required String ticketNumber,
      required String ratings,
      required String feedBack,
      required String journeyId}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(ApiEndpoints.userReview,
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: FormData.fromMap({
            'ticket_number': ticketNumber,
            'journey_id': journeyId,
            'rating': ratings,
            'comment': feedBack
          }));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
