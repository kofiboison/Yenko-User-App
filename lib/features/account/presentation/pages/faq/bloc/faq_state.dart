part of 'faq_bloc.dart';

enum FaqStatus {
  initial,
  loading,
  loaded,
  error,
  logOut,
  update,
}

class FaqState extends Equatable {
  final FaqStatus status;
  final String textDirection;
  final String languageCode;
  final bool isLoading;
  final int choosenFaqIndex;
  final bool isFaqHasData;
  final List<FaqData> faqDataList;
  final List<FaqData> allFaqDataList;

  const FaqState({
    required this.status,
    required this.textDirection,
    required this.languageCode,
    required this.isLoading,
    required this.choosenFaqIndex,
    required this.isFaqHasData,
    required this.faqDataList,
    required this.allFaqDataList,
  });

  static FaqState initial() => const FaqState(
        status: FaqStatus.initial,
        textDirection: 'ltr',
        languageCode: '',
        isLoading: false,
        choosenFaqIndex: 0,
        isFaqHasData: false,
        faqDataList: [],
        allFaqDataList:[],
      );

  FaqState copyWith({
    FaqStatus? status,
    String? textDirection,
    String? languageCode,
    bool? isLoading,
    int? choosenFaqIndex,
    bool? isFaqHasData,
    List<FaqData>? faqDataList,
    List<FaqData>? allFaqDataList,

  }) =>
      FaqState(
        status: status ?? this.status,
        textDirection: textDirection ?? this.textDirection,
        languageCode: languageCode ?? this.languageCode,
        isLoading: isLoading ?? this.isLoading,
        choosenFaqIndex: choosenFaqIndex ?? this.choosenFaqIndex,
        isFaqHasData: isFaqHasData ?? this.isFaqHasData,
        faqDataList: faqDataList ?? this.faqDataList,
        allFaqDataList:allFaqDataList ?? this.allFaqDataList,
      );

  @override
  List get props => [
        status,
        textDirection,
        languageCode,
        isLoading,
        choosenFaqIndex,
        isFaqHasData,
        faqDataList.map((e) =>e).hashCode,
        allFaqDataList.map((e) =>e).hashCode,
      ];
}
