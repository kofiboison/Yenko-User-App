import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../domain/models/booking_history_model.dart';

class ViewDetailsWidget extends StatelessWidget {
  final List<BoardingDatum> boardingList;
  final List<StopDatum> stopList;
  final String boardingAddress;
  final String dropAddress;
  const ViewDetailsWidget({super.key,required this.boardingList,required this.stopList,required this.boardingAddress,required this.dropAddress});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: size.height* 0.9,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    text: '${AppLocalizations.of(context)!.boardingPoint} & ${AppLocalizations.of(context)!.stopPoint}',
                    textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold
                    ),),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.cancel_outlined))  
                ],
              ),
              SizedBox(height: size.width * 0.02),  
              // Dots + labels
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: boardingList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final boarding = boardingList.elementAt(index);
                  return SizedBox(
                    // height: spacing,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Time label
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 70,
                                child: MyText(
                                    text: boarding.boardingDate,
                                    textAlign: TextAlign.end,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontSize: 10,
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                width: 70,
                                child: MyText(
                                    text: boarding.boardingTime,
                                    textAlign: TextAlign.end,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontSize: 12,
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold)),
                              ),
                              if(boarding.arrivalStatus == 1 && boarding.arriveAt.isNotEmpty)
                              SizedBox(
                                width: 70,
                                child : Text(
                                  DateFormat('hh:mm a')
                                    .format(DateFormat("dd-MM-yyyy hh:mm a").parse(boarding.arriveAt))
                                    .toString(),
                                    textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color:(DateFormat("dd-MM-yyyy hh:mm a").parse(boarding.arriveAt)).isAfter(DateFormat("yyyy-MM-dd hh:mm:ss").parse((boarding.boardingDateTime).toString())) 
                                      ? AppColors.red
                                      : AppColors.green),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: size.width*0.02),
                        // Labels,locations
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (boarding.boardingPlace == boardingAddress)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withAlpha((0.9 * 255).toInt()),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: MyText(
                                    text: "Your Boarding Point",
                                    textStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: MyText(
                                      text: boarding.boardingLandmark,
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                    const Icon(Icons.arrow_upward,
                                        color: AppColors.green, size: 20),
                                ],
                              ),
                              if (boarding.boardingPlace.isNotEmpty)
                                MyText(
                                  text: boarding.boardingPlace,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: size.width * 0.02),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: size.width * 0.02),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stopList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final stops = stopList.elementAt(index);
                  return SizedBox(
                    // height: spacing,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Time label
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 70,
                              child: MyText(
                                text: stops.stopDate,
                                textAlign: TextAlign.end,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 10,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              width: 70,
                              child: MyText(
                                text: stops.stopTime,
                                textAlign: TextAlign.end,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 14,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold)),
                            ),
                            if(stops.arrivalStatus == 1 && stops.arriveAt.isNotEmpty)
                              SizedBox(
                                width: 70,
                                child : Text(
                                  DateFormat('hh:mm a')
                                    .format(DateFormat("dd-MM-yyyy hh:mm a").parse(stops.arriveAt))
                                    .toString(),
                                    textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color:(DateFormat("dd-MM-yyyy hh:mm a").parse(stops.arriveAt)).isAfter(DateFormat("yyyy-MM-dd hh:mm:ss").parse((stops.stopDateTime).toString())) 
                                      ? AppColors.red
                                      : AppColors.green),
                                ),
                            ),
                          ],
                        ),
                        SizedBox(width: size.width*0.02),
                        // Labels,locations
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (stops.stopAddress == dropAddress)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withAlpha((0.9 * 255).toInt()),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: MyText(
                                    text:  "Your Drop Point",
                                    textStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: MyText(
                                      text: stops.stopLandmark,
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                       const Icon(Icons.arrow_downward,
                                        color: AppColors.red, size: 20),
                                    const SizedBox(width: 4),
                                ],
                              ),
                              if (stops.stopAddress.isNotEmpty)
                                MyText(
                                  text: stops.stopAddress,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              SizedBox(height: size.width * 0.02),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
          ),
      ),
    );
  }
}