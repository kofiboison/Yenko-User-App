import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/common.dart';
import '../../../../../../di/locator.dart';
import '../../../../application/usecase/acc_usecases.dart';
import '../../../../domain/models/faq_model.dart';

part 'faq_event.dart';

part 'faq_state.dart';

class FaqBloc extends Bloc<FaqEvent, FaqState> {
  ScrollController scrollController = ScrollController();

  FaqBloc() : super(FaqState.initial()) {
    on<FaqUpdateEvent>((event, emit) =>
        emit(state.copyWith(status: FaqStatus.update, isLoading: false)));
    //Faq Page
    on<FaqGetDirectionEvent>(chatGetDirection);
    on<GetFaqListEvent>(_getFaqList);
    on<FaqOnTapEvent>(_selectedFaqIndex);
    on<FaqSearchClearEvent>(faqSearchClear);
  }

//Get Direction
  Future<void> chatGetDirection(
      FaqGetDirectionEvent event, Emitter<FaqState> emit) async {
    emit(state.copyWith(status: FaqStatus.loading));
    final languageCode = await AppSharedPreference.getSelectedLanguageCode();
    final textDirection = await AppSharedPreference.getLanguageDirection();
    emit(state.copyWith(
        status: FaqStatus.loaded,
        languageCode: languageCode,
        textDirection: textDirection));
  }


  //Faq
  FutureOr<void> _getFaqList(
      GetFaqListEvent event, Emitter<FaqState> emit) async {
    emit(state.copyWith(status: FaqStatus.loading));
    final data = await serviceLocator<AccUsecase>().getFaqDetail();
    data.fold(
      (error) {
        emit(state.copyWith(status: FaqStatus.error));
      },
      (success) {
        emit(state.copyWith(status: FaqStatus.loaded,faqDataList:success.data));
      },
    );
  }

  Future<void> _selectedFaqIndex(
      FaqOnTapEvent event, Emitter<FaqState> emit) async {
    if (state.choosenFaqIndex == event.selectedFaqIndex) {
      emit(state.copyWith(choosenFaqIndex: -1));
    } else {
      emit(state.copyWith(choosenFaqIndex: event.selectedFaqIndex));
    }
  }

  Future<void> faqSearch(FaqSearchEvent event, Emitter<FaqState> emit) async {
    if (event.searchText.isNotEmpty) {
      final filteredList = state.allFaqDataList
          .where((element) => element.question
              .toLowerCase()
              .contains(event.searchText.toLowerCase()))
          .toList();

      emit(state.copyWith(faqDataList: filteredList,isFaqHasData:true));
    } else {
      emit(state.copyWith(faqDataList: List.from(state.allFaqDataList),isFaqHasData:false));
    }
  }

  Future<void> faqSearchClear(
      FaqSearchClearEvent event, Emitter<FaqState> emit) async {
    emit(state.copyWith(faqDataList: List.from(state.allFaqDataList),isFaqHasData:false));
  }
}
