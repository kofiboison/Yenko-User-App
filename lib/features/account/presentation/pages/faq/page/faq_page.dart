import 'package:bus_booking/core/utils/custom_text.dart';
import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../bloc/faq_bloc.dart';
import '../widget/faq_list_widget.dart';

class FaqPage extends StatelessWidget {
  static const String routeName = '/faqPage';

  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FaqBloc()
        ..add(FaqGetDirectionEvent())
        ..add(GetFaqListEvent()),
      child: BlocListener<FaqBloc, FaqState>(
        listener: (context, state) {},
        child: BlocBuilder<FaqBloc, FaqState>(builder: (context, state) {
          final faqBloc = context.read<FaqBloc>();
          return Directionality(
            textDirection: state.textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                title: MyText(
                    text: AppLocalizations.of(context)!.faq.toUpperCase(),
                    textStyle: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).primaryColor)),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.width * 0.05),
                    FaqDataListWidget(
                        faq: faqBloc,
                        faqDataList: state.faqDataList),
                    SizedBox(height: size.width * 0.05),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
