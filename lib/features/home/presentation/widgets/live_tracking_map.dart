import 'package:bus_booking/features/home/presentation/widgets/full_view_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../common/common.dart';
import '../../application/home_bloc.dart';

class LiveTrackingMap extends StatelessWidget {
  final LiveTrackingArguments arg;
  const LiveTrackingMap({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    final journeyPoints1 = [
      ...arg.boardingPoints.map((bp) => LatLng(bp.boardingLat, bp.boardingLng)),
    ];
    final journeyPoints2 = [
      ...arg.stopPoints.map((sp) => LatLng(sp.stopLat, sp.stopLng)),
    ];
    final decodedPoints = arg.polyline != null && arg.polyline!.isNotEmpty
        ? homeBloc.decodePolyline(arg.polyline!)
        : <LatLng>[];

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        // if (state is BusLocationUpdatedState) {
        //   if (homeBloc.googleMapController != null) {
        //     // Animate camera to follow the bus
        //     homeBloc.googleMapController!.animateCamera(
        //       CameraUpdate.newLatLng(state.busLocation),
        //     );
        //   }

        //   // Update the marker with new position and rotation
        //   if (state.heading != null) {
        //     homeBloc.busHeading = state.heading;
        //   }
        // }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppColors.greyHintColor.withAlpha((0.2 * 255).toInt()),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                      children: [
                        StreamBuilder<LatLng>(
                          stream: homeBloc.busLocationStream,
                          builder: (context, snapshot) {
                            return FutureBuilder<Set<Marker>>(
                              future:
                                  homeBloc.buildNumberMarkers(bordingPoints: journeyPoints1,dropPoints: journeyPoints2),
                              builder: (context, snapshot) {
                                final numberedMarkers =
                                    snapshot.data ?? <Marker>{};

                                final markers =
                                    Set<Marker>.from(numberedMarkers);
                                if (homeBloc.busLocation != null &&
                                    homeBloc.busIcon != null) {
                                  markers.add(Marker(
                                    markerId: const MarkerId('bus_marker'),
                                    position: homeBloc.busLocation!,
                                    icon: homeBloc.busIcon!,
                                    flat: true,
                                    rotation: 0.0,
                                  ));
                                }

                                final polylines = <Polyline>{};
                                if (decodedPoints.isNotEmpty) {
                                  polylines.add(Polyline(
                                    polylineId:
                                        const PolylineId('journey_polyline'),
                                    points: decodedPoints,
                                    color: Colors.blue,
                                    width: 4,
                                  ));
                                }

                                return GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: homeBloc.busLocation ??
                                        (decodedPoints.isNotEmpty
                                            ? decodedPoints.first
                                            : LatLng(
                                                AppConstants
                                                    .currentLocations.latitude,
                                                AppConstants.currentLocations
                                                    .longitude)),
                                    zoom: 14,
                                  ),
                                  onMapCreated: (controller) {
                                    homeBloc.googleMapController = controller;
                                    if (homeBloc.busLocation != null) {
                                      controller.animateCamera(
                                        CameraUpdate.newLatLng(
                                            homeBloc.busLocation!),
                                      );
                                    }
                                  },
                                  markers: markers,
                                  polylines: polylines,
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: true,
                                  zoomControlsEnabled: false,
                                  mapToolbarEnabled: false,
                                  compassEnabled: false,
                                  zoomGesturesEnabled: true,
                                );
                              },
                            );
                          },
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              if (homeBloc.busLocation != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: homeBloc,
                                      child: FullMapView(arg: arg),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.black
                                    .withAlpha((0.3 * 255).toInt()),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.black
                                        .withAlpha((0.4 * 255).toInt()),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.fullscreen,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
