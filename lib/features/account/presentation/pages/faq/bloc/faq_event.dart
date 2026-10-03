part of 'faq_bloc.dart';

abstract class FaqEvent {}

class FaqGetDirectionEvent extends FaqEvent {}

class FaqUpdateEvent extends FaqEvent {}

class LoadMoreUpdateEvent extends FaqEvent {
  final bool loadMore;

  LoadMoreUpdateEvent({required this.loadMore});

}

class FaqOnTapEvent extends FaqEvent {
  final int selectedFaqIndex;

  FaqOnTapEvent({required this.selectedFaqIndex});
}

class GetFaqListEvent extends FaqEvent {}

class FaqSearchEvent extends FaqEvent {
  final String searchText;
  FaqSearchEvent({required this.searchText});
}

class FaqSearchClearEvent extends FaqEvent {}
