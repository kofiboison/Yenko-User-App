import 'package:flutter/material.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_divider.dart';
import '../../../../core/utils/custom_text.dart';

class BoardingDetailWidget extends StatelessWidget {
  final String fromTitle1;
  final String fromTitle2;
  final String toTitle1;
  final String toTitle2;
  final Color? title1Color;
  final Color? title2Color;
  final double? title1FontSize;
  final double? title2FontSize;
  final String? travelHours;
  final int? dividerLength;
  final Color? dividerColor;
  final bool useDottedDivider;
  final double? dividerWidth;

  const BoardingDetailWidget({
    super.key,
    required this.fromTitle1,
    required this.fromTitle2,
    required this.toTitle1,
    required this.toTitle2,
    this.title1Color,
    this.title2Color,
    this.title1FontSize,
    this.title2FontSize,
    this.travelHours,
    this.dividerLength,
    this.dividerColor,
    this.useDottedDivider = false,
    this.dividerWidth = 1.5,
  });

  Widget buildDivider() {
    if (useDottedDivider) {
      int totalDots = dividerLength ?? 8;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(totalDots, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Container(
              width: 2,
              height: 2,
              decoration: BoxDecoration(
                color: dividerColor ?? AppColors.secondaryLight,
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: HorizontalDotDividerWidget(
            color: dividerColor ?? AppColors.secondaryLight,
            length: dividerLength ?? 8),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: size.width * 0.02),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: fromTitle1,
                    textAlign: TextAlign.left,
                    textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: title1Color ?? AppColors.surfaceLight,
                        fontSize: title1FontSize),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  MyText(
                    text: fromTitle2,
                    textAlign: TextAlign.left,
                    textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: title2Color ?? AppColors.white,
                        fontSize: title2FontSize),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Divider
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: buildDivider(),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 8),
            //   child: HorizontalDotDividerWidget(
            //       color: dividerColor ?? AppColors.secondaryLight,
            //       length: dividerLength ?? 8),
            // ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (travelHours != null)
                  MyText(
                    text: travelHours!,
                    textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 12,
                          color: Theme.of(context).hintColor,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                Icon(
                  Icons.directions_bus_rounded,
                  color: Theme.of(context).hintColor,
                  size: 20,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: buildDivider(),
            ),

            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MyText(
                    text: toTitle1,
                    textAlign: TextAlign.right,
                    textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: title1Color ?? AppColors.surfaceLight,
                        fontSize: title1FontSize),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  MyText(
                    text: toTitle2,
                    textAlign: TextAlign.right,
                    textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: title2Color ?? AppColors.white,
                        fontSize: title2FontSize),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
