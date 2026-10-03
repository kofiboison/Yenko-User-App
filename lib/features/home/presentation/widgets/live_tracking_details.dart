import 'package:flutter/material.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';

class LiveTrackingDetails extends StatelessWidget {
  final LiveTrackingArguments arg;

  const LiveTrackingDetails({
    super.key,
    required this.arg,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 18,
                color: AppColors.green.withAlpha((0.8 * 255).toInt()),
              ),
              SizedBox(width: size.width * 0.01),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: arg.fromCity,
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    MyText(
                      text: arg.boardingAddress,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).hintColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: size.width * 0.04),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 18,
                color: AppColors.red.withAlpha((0.8 * 255).toInt()),
              ),
              SizedBox(width: size.width * 0.01),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: arg.toCity,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    MyText(
                      text: arg.dropAddress,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).hintColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
