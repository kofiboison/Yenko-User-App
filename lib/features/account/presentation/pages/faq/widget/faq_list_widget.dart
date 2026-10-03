import 'package:bus_booking/common/app_images.dart';
import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../domain/models/faq_model.dart';
import '../bloc/faq_bloc.dart';

class FaqDataListWidget extends StatelessWidget {
  final FaqBloc faq;
  final List<FaqData> faqDataList;
  const FaqDataListWidget(
      {super.key, required this.faq, required this.faqDataList});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: faq,
      child: BlocBuilder<FaqBloc, FaqState>(
        builder: (context, state) {
          final faqBloc = context.read<FaqBloc>();
          return faqDataList.isNotEmpty
              ? SizedBox(
                  height: size.height * 0.725,
                  child: RawScrollbar(
                    radius: const Radius.circular(20),
                    child: ListView.builder(
                      itemCount: faqDataList.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            faqBloc.add(FaqOnTapEvent(selectedFaqIndex: index));
                          },
                          child: Container(
                            width: size.width,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withAlpha((256 * 0.5).toInt()),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              border: Border.all(
                                width: 0.2,
                                color:
                                    Colors.grey.withAlpha((256 * 0.5).toInt()),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(size.width * 0.025),
                              child: Row(
                                children: [
                                  SizedBox(width: size.width * 0.025),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: MyText(
                                                text:
                                                    faqDataList[index].question,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Theme.of(context)
                                                          .primaryColorDark,
                                                    ),
                                                maxLines: 2,
                                              ),
                                            ),
                                            RotatedBox(
                                                quarterTurns: (state.choosenFaqIndex ==
                                                        index)
                                                    ? 2
                                                    : 4,
                                                child: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Theme.of(context)
                                                        .primaryColorDark))
                                          ],
                                        ),
                                        (state.choosenFaqIndex ==
                                                index)
                                            ? Column(
                                                children: [
                                                  SizedBox(
                                                    height: size.width * 0.025,
                                                  ),
                                                  SizedBox(
                                                    width: size.width * 0.8,
                                                    child: MyText(
                                                      text: faqDataList[index]
                                                          .answer,
                                                      textStyle: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor
                                                                  .withAlpha((0.6 *
                                                                          255)
                                                                      .toInt())),
                                                      maxLines: 10,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : const FaqNodataWidget();
        },
      ),
    );
  }
}

class FaqNodataWidget extends StatelessWidget {
  const FaqNodataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.noBookings,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 5),
            MyText(
              text: AppLocalizations.of(context)!.noFaq,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontSize: 16,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
