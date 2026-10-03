import 'package:flutter/material.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';

class SeaterWidget extends StatelessWidget {
  final Color? borderColor;
  final Color? fillColor;
  final double? price;
  final String? currencySymbol;
  final String? seatType;

  const SeaterWidget({
    super.key,
    this.borderColor,
    this.fillColor,
    this.price,
    this.currencySymbol,
    this.seatType,
  });

  String _getSeatImage() {
    switch (seatType?.toLowerCase()) {
      case 'seater':
        return AppImages.seater;
      case 'sleeper':
        return AppImages.sleeper;
      case 'semi-sleeper':
        return AppImages.semiSleeper;
      default:
        return AppImages.seater;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: size.width * 0.08,
          width: size.width * 0.08,
          decoration: BoxDecoration(
            color: fillColor ?? AppColors.white,
            borderRadius: BorderRadius.circular(5),
            border:
                Border.all(color: borderColor ?? AppColors.green, width: 1.0),
          ),
          child: Center(
            child: Image.asset(
              _getSeatImage(),
              width: size.width * 0.06,
              height: size.width * 0.06,
              fit: BoxFit.contain,
            ),
          ),
        ),
        if (price != null)
          Padding(
            padding: EdgeInsets.zero,
            child: MyText(
              text: '${currencySymbol ?? '\$'}${price!.toStringAsFixed(0)}',
              textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: borderColor ?? AppColors.green,
                  ),
            ),
          ),
      ],
    );
  }
}

class SleeperWidget extends StatelessWidget {
  final Color? borderColor;
  final Color? fillColor;
  final double? price;
  final String? currencySymbol;
  final String? seatType;

  const SleeperWidget({
    super.key,
    this.borderColor,
    this.fillColor,
    this.price,
    this.currencySymbol,
    this.seatType,
  });

  String _getSeatImage() {
    switch (seatType?.toLowerCase()) {
      case 'seater':
        return AppImages.seater;
      case 'sleeper':
        return AppImages.sleeper;
      case 'semi-sleeper':
        return AppImages.semiSleeper;
      default:
        return AppImages.sleeper; // Default to sleeper
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: size.width * 0.2,
          width: size.width * 0.1,
          decoration: BoxDecoration(
            color: fillColor ?? AppColors.white,
            borderRadius: BorderRadius.circular(5),
            border:
                Border.all(color: borderColor ?? AppColors.green, width: 1.0),
          ),
          child: Center(
            child: Image.asset(
              _getSeatImage(),
              width: size.width * 0.099,
              height: size.width * 0.099,
              fit: BoxFit.contain,
            ),
          ),
        ),
        if (price != null)
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: MyText(
              text: '${currencySymbol ?? '\$'}${price!.toStringAsFixed(0)}',
              textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: borderColor ?? AppColors.green,
                  ),
            ),
          ),
      ],
    );
  }
}
