import 'package:bus_booking/common/app_images.dart';
import 'package:bus_booking/core/utils/custom_text.dart';
import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SupportEmptyWidget extends StatelessWidget {
  const SupportEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.empty,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 5),
            MyText(
              text: AppLocalizations.of(context)!.noSupportTicketsFound,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontSize: 16,
                  ),
            ),
            MyText(
              text: AppLocalizations.of(context)!.havenotSubmmitedTickets,
              maxLines: 2,
              textAlign: TextAlign.center,
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
