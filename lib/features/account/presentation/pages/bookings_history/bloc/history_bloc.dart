import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:bus_booking/core/utils/custom_loader.dart';
import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../di/locator.dart';
import '../../../../../home/domain/models/user_details_model.dart';
import '../../../../application/usecase/acc_usecases.dart';
import '../../../../domain/models/booking_history_model.dart';

part 'history_event.dart';

part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  ScrollController scrollController = ScrollController();

  HistoryBloc() : super(HistoryState.initial()) {
    on<HistoryUpdateEvent>((event, emit) =>
        emit(state.copyWith(status: HistoryStatus.update, isLoading: false)));
    on<LoadMoreUpdateEvent>(
        (event, emit) => emit(state.copyWith(loadMore: event.loadMore)));
    //History
    on<HistoryGetDirectionEvent>(historyGetDirection);
    on<BookingTypeChangeEvent>(_bookingTypeChange);
    on<BoookingsGetEvent>(_getBookingHistoryList);
    on<BookingsPageInitEvent>(bookingPageInitEvent);
    on<BookingCancelEvent>(bookingCancel);
    on<RatingsSelectEvent>(ratingsSelectEvent);
    on<DownloadInvoiceEvent>(downloadInvoice);
  }

//Get Direction
  Future<void> historyGetDirection(
      HistoryGetDirectionEvent event, Emitter<HistoryState> emit) async {
    emit(state.copyWith(status: HistoryStatus.loading));
    final languageCode = await AppSharedPreference.getSelectedLanguageCode();
    final textDirection = await AppSharedPreference.getLanguageDirection();
    emit(state.copyWith(
        status: HistoryStatus.loaded,
        languageCode: languageCode,
        textDirection: textDirection));
  }

  // Change History Type
  Future<void> _bookingTypeChange(
      BookingTypeChangeEvent event, Emitter<HistoryState> emit) async {
    emit(state.copyWith(
        selectedHistoryType: event.bookingTypeIndex, historyList: []));
    String filter;
    switch (event.bookingTypeIndex) {
      case 0:
        filter = 'is_completed=1';
        break;
      case 1:
        filter = 'is_cancelled=0&is_completed=0&is_trip_started=false';
        break;
      case 2:
        filter = 'is_cancelled=1';
        break;
      case 3:
        filter = 'ongoing=1';
        break;
      default:
        filter = '';
    }

    add(BoookingsGetEvent(bookingFilter: filter));
  }

  Future<void> ratingsSelectEvent(
      RatingsSelectEvent event, Emitter<HistoryState> emit) async {
    emit(state.copyWith(selectedRatingsIndex: event.selectedIndex));
  }

  FutureOr<void> downloadInvoice(
      DownloadInvoiceEvent event, Emitter<HistoryState> emit) async {
    final context = navigatorKey.currentContext!;
    emit(state.copyWith(status: HistoryStatus.invoiceDownloading));

    final data = await serviceLocator<AccUsecase>()
        .invoiceDownload(journeyId: event.journeyId);

    data.fold(
      (error) {
        debugPrint(error.toString());
        emit(state.copyWith(status: HistoryStatus.invoiceDownloadError));
        showToast(message: error.message ?? "");
      },
      (success) async {
        if (success["success"] && success["invoice_url"] != null) {
          final invoiceUrl = success["invoice_url"];
          try {
            if (Platform.isAndroid) {
              if (!await Permission.manageExternalStorage.isGranted) {
                await Permission.manageExternalStorage.request();
              }
            }

            Directory downloadsDir;
            if (Platform.isAndroid) {
              downloadsDir = Directory("/storage/emulated/0/Download");
            } else {
              downloadsDir = await getApplicationDocumentsDirectory();
            }

            if (!await downloadsDir.exists()) {
              await downloadsDir.create(recursive: true);
            }

            final timestamp = DateTime.now().millisecondsSinceEpoch;
            final filePath =
                "${downloadsDir.path}/invoice_${event.journeyId}_$timestamp.pdf";

            final dio = Dio();
            await dio.download(invoiceUrl, filePath);

            debugPrint("Invoice saved at: $filePath");

            await Share.shareXFiles([XFile(filePath)]);

            emit(state.copyWith(status: HistoryStatus.invoiceDownloadSuccess));
          } catch (e) {
            debugPrint("PDF download error: $e");
            emit(state.copyWith(status: HistoryStatus.invoiceDownloadError));
          }
        } else {
          emit(state.copyWith(status: HistoryStatus.invoiceDownloadError));
          showToast(
              message: AppLocalizations.of(context)!.invoiceUrlNotAvailable);
        }
      },
    );
  }

  // History
  Future<void> _getBookingHistoryList(
      BoookingsGetEvent event, Emitter<HistoryState> emit) async {
    if (event.pageNumber != null) {
      emit(state.copyWith(isLoading: true, loadMore: true));
    } else {
      emit(state.copyWith(isLoading: true, firstLoad: true));
    }
    final data = await serviceLocator<AccUsecase>().bookingHistoryDetails(
        event.bookingFilter,
        pageNo: event.pageNumber.toString());
    data.fold(
      (error) {
        debugPrint('History Error: ${error.toString()}');
        if (error.statusCode == 401 || error.statusCode == 400) {
          emit(state.copyWith(isLoading: false, status: HistoryStatus.logOut));
        } else {
          showToast(message: error.message ?? "");
          emit(state.copyWith(isLoading: false));
        }
      },
      (success) {
        emit(state.copyWith(
            isLoading: false, loadMore: false, firstLoad: false));
        if (event.pageNumber == null || event.pageNumber == 1) {
          emit(state.copyWith(historyList: success.data));
        } else {
          if (success.data.isNotEmpty) {
            List<BookingHistoryData>? lHistory = List.from(state.historyList);
            lHistory.addAll(success.data);
            List<BookingHistoryData> historySetData = lHistory.toSet().toList();
            emit(state.copyWith(historyList: historySetData));
          } else {
            emit(state.copyWith(historyList: success.data));
          }
        }
      },
    );
  }

  Future<void> bookingPageInitEvent(
      BookingsPageInitEvent event, Emitter<HistoryState> emit) async {
    emit(state.copyWith(
        isLoading: true, firstLoad: true, userData: event.arg.userData));
    add(BoookingsGetEvent(
        bookingFilter: 'is_cancelled=0&is_completed=0&is_trip_started=false'));
  }

  Future<void> bookingCancel(
      BookingCancelEvent event, Emitter<HistoryState> emit) async {
    emit(state.copyWith(isLoading: true));
    final data = await serviceLocator<AccUsecase>().cancelBookingApi(
        journeyId: event.journeyId,
        userId: event.userId,
        ticketNumber: event.ticketNumber);
    data.fold((error) {
      showToast(message: error.message.toString());
      emit(state.copyWith(isLoading: false));
    }, (success) {
      showToast(message: success['message'].toString());
      emit(state.copyWith(
          status: HistoryStatus.bookingCancelSuccess, isLoading: false));
    });
  }
}
