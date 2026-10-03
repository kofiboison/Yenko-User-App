import 'package:bus_booking/core/utils/custom_dialoges.dart';
import 'package:bus_booking/features/home/application/home_bloc.dart';
import 'package:bus_booking/features/home/presentation/pages/home_page.dart';
import 'package:bus_booking/features/home/presentation/widgets/live_tracking_details.dart';
import 'package:bus_booking/features/home/presentation/widgets/live_tracking_timeline.dart';
import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';

class LiveTracking extends StatefulWidget {
  static const String routeName = '/liveTracking';
  final LiveTrackingArguments arg;

  const LiveTracking({super.key, required this.arg});

  @override
  State<LiveTracking> createState() => _LiveTrackingState();
}

class _LiveTrackingState extends State<LiveTracking> {
  GoogleMapController? googleMapController;

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) {
        final bloc = HomeBloc();
        if (widget.arg.journeyId.isNotEmpty) {
          bloc.add(StartLiveTrackingEvent(widget.arg.journeyId));
        }
        return bloc;
      },
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeLoadingStartState) {
            CustomLoader.loader(context);
          } else if (state is HomeLoadingStopState) {
            CustomLoader.dismiss(context);
          } else if (state is LiveTrackingUpdatedState &&
              state.shouldEndTracking) {
            showDialog(
              context: context,
              builder: (BuildContext _) {
                return BlocProvider.value(
                    value: BlocProvider.of<HomeBloc>(context),
                    child: CustomSingleButtonDialoge(
                      title: AppLocalizations.of(context)!.tripCompleted,
                      content: AppLocalizations.of(context)!.tripCompletedtext,
                      btnName: AppLocalizations.of(context)!.ok,
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const HomePage()),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ));
              },
            );
          }
        },
        builder: (context, state) {
          final homeBloc = context.read<HomeBloc>();
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Theme.of(context).primaryColor,
                surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                iconTheme: IconThemeData(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                title: MyText(
                  text: AppLocalizations.of(context)!.liveTracking,
                  textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: AppLocalizations.of(context)!.trackingDetails,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        BlocProvider.value(
                          value: homeBloc,
                          child: LiveTrackingDetails(
                            arg: widget.arg,
                          ),
                        ),
                        SizedBox(height: size.width * 0.04),
                        BlocProvider.value(
                          value: homeBloc,
                          child: TrackingTimeline(
                            arg: widget.arg,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
