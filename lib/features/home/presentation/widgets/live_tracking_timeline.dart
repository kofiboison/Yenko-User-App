import 'package:bus_booking/core/utils/custom_text.dart';
import 'package:bus_booking/features/home/presentation/widgets/live_tracking_map.dart';
import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../common/common.dart';
import '../../application/home_bloc.dart';

class TrackingTimeline extends StatelessWidget {
  final LiveTrackingArguments arg;

  const TrackingTimeline({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final homeBloc = context.read<HomeBloc>();

        final points = _buildJourneyPoints(
          args: arg,
          firebaseBoardingPoints: homeBloc.firebaseBoardingPoints,
          firebaseStoppingPoints: homeBloc.firebaseStoppingPoints,
          reachedIds: homeBloc.reachedPointIds,
          context: context,
        );
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline_sharp,
                            color: Theme.of(context).hintColor,
                          ),
                          const SizedBox(width: 6),
                          MyText(
                            text: arg.passengerCount,
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.timer,
                            color: Theme.of(context).hintColor,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          MyText(
                            text: arg.travelDuration,
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                BlocProvider.value(
                  value: homeBloc,
                  child: LiveTrackingMap(
                    arg: arg,
                  ),
                ),
                const SizedBox(height: 20),
                BlocProvider.value(
                  value: homeBloc,
                  child: _buildTimeline(context, points, arg),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

List<Map<String, dynamic>> _buildJourneyPoints({
  required BuildContext context,
  required LiveTrackingArguments args,
  required List<Map<String, dynamic>> firebaseBoardingPoints,
  required List<Map<String, dynamic>> firebaseStoppingPoints,
  required Set<String> reachedIds,
}) {
  final List<Map<String, dynamic>> points = [];

  // Boarding points
  for (final bp in args.boardingPoints) {
    final String id = bp.boardingId;
    final fb = firebaseBoardingPoints.firstWhere(
      (m) => (m['boarding_id'] ?? '').toString() == id,
      orElse: () => const {},
    );

    // Firebase scheduled time if available, else fallback
    final String scheduledTime =
        (fb['boarding_date_time'] ?? bp.boardingTime).toString();
    final String reachedTime = (fb['reached_time'] ?? '').toString();

    final DateTime scheduledDt = _parseDateTimeSafe(scheduledTime);
    final DateTime? reachedDt =
        reachedTime.isNotEmpty ? _parseDateTimeSafe(reachedTime) : null;

    bool isReached = reachedDt != null || reachedIds.contains(id);

    points.add({
      'type': 'boarding',
      'id': id,
      'time': scheduledTime,
      'location': bp.boardingPlace,
      'label': AppLocalizations.of(context)!.boardingPoint,
      'is_reached': isReached,
      'scheduled_dt': scheduledDt,
      'reached_dt': reachedDt,
      'date': bp.boardingDate,
      'landmark': bp.boardingLandmark
    });
  }

  // Stop points
  for (final sp in args.stopPoints) {
    final String id = sp.stopId;
    final fb = firebaseStoppingPoints.firstWhere(
      (m) => (m['stop_id'] ?? '').toString() == id,
      orElse: () => const {},
    );

    final String scheduledTime =
        (fb['stop_date_time'] ?? sp.stopTime).toString();
    final String reachedTime = (fb['reached_time'] ?? '').toString();

    final DateTime scheduledDt = _parseDateTimeSafe(scheduledTime);
    final DateTime? reachedDt =
        reachedTime.isNotEmpty ? _parseDateTimeSafe(reachedTime) : null;

    bool isReached = reachedDt != null || reachedIds.contains(id);

    points.add({
      'type': 'stop',
      'id': id,
      'time': scheduledTime,
      'location': sp.stopAddress,
      'label': AppLocalizations.of(context)!.stopPoint,
      'is_reached': isReached,
      'scheduled_dt': scheduledDt,
      'reached_dt': reachedDt,
      'date': sp.stopDate,
      'landmark': sp.stopLandmark
    });
  }

  return points;
}

Widget _buildTimeline(BuildContext context, List<Map<String, dynamic>> points,
    LiveTrackingArguments arg) {
  const double circleRadius = 7;
  const double spacing = 100;

  final lastReachedIndex =
      points.lastIndexWhere((p) => p['is_reached'] == true);

  return SizedBox(
    height: points.length * spacing,
    child: Stack(
      children: [
        // Full grey line
        Positioned(
          left: 80,
          top: circleRadius,
          child: Container(
            width: 3,
            height: (points.length - 1) * spacing,
            color: Theme.of(context).hintColor.withAlpha((0.4 * 255).toInt()),
          ),
        ),
        // Green progress line
        if (lastReachedIndex > 0)
          Positioned(
            left: 80,
            top: circleRadius,
            child: Container(
              width: 3,
              height: lastReachedIndex * spacing,
              color: AppColors.green,
            ),
          ),

        // Dots + labels
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: points.length,
          itemBuilder: (context, index) {
            final p = points[index];
            final bool isReached = p['is_reached'] == true;
            final DateTime scheduledDt = p['scheduled_dt'];
            final DateTime? reachedDt = p['reached_dt'];

            if (isReached && reachedDt != null) {}

            // dot color
            Color dotColor;
            if (!isReached) {
              dotColor = Theme.of(context).hintColor;
            } else {
              dotColor = AppColors.green;
            }

            bool addressMatches(String? a, String? b) {
              final aa = (a ?? '').toLowerCase();
              final bb = (b ?? '').toLowerCase();
              return aa.contains(bb) || bb.contains(aa);
            }

            final bool isFromCity = p['type'] == 'boarding' &&
                addressMatches(p['location'], arg.boardingAddress);

            final bool isToCity = p['type'] == 'stop' &&
                addressMatches(p['location'], arg.dropAddress);

            return SizedBox(
              height: spacing,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time label
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 70,
                        child: MyText(
                            text: formatDateShort(p['date']).toUpperCase(),
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
                            text: (p['time']),
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: 70,
                        child: MyText(
                            text: !isReached
                                ? ''
                                : _buildReachedText(scheduledDt, reachedDt),
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 12,
                                    color: !isReached
                                        ? Theme.of(context).hintColor
                                        : _getReachedColor(
                                            scheduledDt, reachedDt),
                                    fontWeight: FontWeight.w100)),
                      ),
                    ],
                  ),

                  const SizedBox(width: 5),

                  // Dot
                  Container(
                    width: circleRadius * 2,
                    height: circleRadius * 2,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: dotColor, width: 2),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Labels,locations
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isFromCity || isToCity)
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
                              text: isFromCity
                                  ? "Your Boarding Point"
                                  : "Your Drop Point",
                              textStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        if (isFromCity || isToCity) const SizedBox(width: 4),
                        Row(
                          children: [
                            Expanded(
                              child: MyText(
                                text: '${p['landmark']} ',
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            if (p['type'] == 'boarding')
                              const Icon(Icons.arrow_upward,
                                  color: AppColors.green, size: 20),
                            if (p['type'] == 'stop')
                              const Icon(Icons.arrow_downward,
                                  color: AppColors.red, size: 20),
                            if (p['type'] == 'boarding' || p['type'] == 'stop')
                              const SizedBox(width: 4),
                          ],
                        ),
                        if ((p['location'] ?? '').toString().isNotEmpty)
                          MyText(
                            text: p['location']!,
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
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
  );
}

String formatDateShort(String dateStr) {
  try {
    final dt =
        DateTime.parse(DateFormat('MMM dd yyyy').parse(dateStr).toString());
    return DateFormat('MMM dd').format(dt);
  } catch (e) {
    return dateStr;
  }
}

Color _getReachedColor(DateTime scheduled, DateTime? reached) {
  if (reached == null) return AppColors.green; // Reaching time not yet known

  final scheduledMinutes = scheduled.hour * 60 + scheduled.minute;
  final reachedMinutes = reached.hour * 60 + reached.minute;
  final diff = reachedMinutes - scheduledMinutes;

  if (diff > 0) {
    return Colors.red; // Late → red
  } else {
    return AppColors.green; // Early or on-time → green
  }
}

String _buildReachedText(DateTime scheduled, DateTime? reached) {
  if (reached == null) {
    return "Reaching time (${_formatTime(scheduled)})";
  }
  return _formatTime(reached); // you can append status if you want
}

String _formatTime(DateTime dt) {
  try {
    return DateFormat('hh:mm a').format(dt); // always 12h format
  } catch (e) {
    return dt.toString();
  }
}

DateTime _parseDateTimeSafe(String timeStr) {
  final clean = timeStr.trim();
  if (clean.isEmpty) return DateTime(1970);

  try {
    // If time-only like "04:49 pm"
    final timeOnlyMatch =
        RegExp(r'^(\d{1,2}):(\d{2})\s*([ap]m)?$', caseSensitive: false)
            .firstMatch(clean);

    if (timeOnlyMatch != null) {
      int hour = int.parse(timeOnlyMatch.group(1)!);
      final int minute = int.parse(timeOnlyMatch.group(2)!);
      final String? ampm = timeOnlyMatch.group(3);

      if (ampm != null) {
        if (ampm.toLowerCase() == 'pm' && hour != 12) hour += 12;
        if (ampm.toLowerCase() == 'am' && hour == 12) hour = 0;
      }

      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minute);
    }

    return DateTime.parse(clean.replaceFirst(' ', 'T'));
  } catch (e) {
    debugPrint(" Failed to parse '$timeStr' → $e");
    return DateTime(1970);
  }
}
