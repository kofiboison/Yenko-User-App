// ignore_for_file: deprecated_member_use

import 'package:bus_booking/core/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../common/common.dart';
import '../../application/home_bloc.dart';

class FullMapView extends StatefulWidget {
  final LiveTrackingArguments arg;
  const FullMapView({super.key, required this.arg});

  @override
  State<FullMapView> createState() => _FullMapViewState();
}

class _FullMapViewState extends State<FullMapView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final homeBloc = context.read<HomeBloc>();
        if (homeBloc.vsync == null) {
          homeBloc.add(UpdateVsyncEvent(vsync: this));
        }
        if (homeBloc.polylines.isEmpty && homeBloc.markers.isEmpty) {
          if (widget.arg.polyline != null && widget.arg.polyline!.isNotEmpty) {
            homeBloc.add(UpdatePolyLineEvent(polyString: widget.arg.polyline!));
          }
          homeBloc.add(UpdateMarkersEvent(
            boardingLatLng: [
              ...widget.arg.boardingPoints
                  .map((bp) => LatLng(bp.boardingLat, bp.boardingLng)),
            ],
            stopLatLng: [
              ...widget.arg.stopPoints
                  .map((sp) => LatLng(sp.stopLat, sp.stopLng)),
            ],
          ));
        }
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: MyText(
              text: "Map",
              textStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
          body: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                            AppConstants.currentLocations.latitude,
                            AppConstants.currentLocations.longitude),
                        zoom: 14,
                      ),
                      onMapCreated: (controller) {
                        homeBloc.googleMapController = controller;
                        if (homeBloc.busLocation != null) {
                          Future.delayed(const Duration(milliseconds: 100),
                              () {
                            controller.animateCamera(
                              CameraUpdate.newLatLng(homeBloc.busLocation!),
                            );
                          });
                        }
                      },
                      markers: Set<Marker>.from(homeBloc.markers),
                      polylines: homeBloc.polylines,
                      myLocationEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                      compassEnabled: false,
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: FloatingActionButton(
                        backgroundColor: AppColors.white,
                        onPressed: () {
                          final controller = homeBloc.googleMapController;
                          if (controller != null) {
                            _goToMyLocation(controller);
                          }
                        },
                        child: const Icon(Icons.my_location,
                            color: AppColors.black),
                      ),
                    )
                  ],
                ),
        );
      },
    );
  }
}

void _goToMyLocation(GoogleMapController controller) async {
  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  final myLocation = LatLng(position.latitude, position.longitude);
  controller.animateCamera(
    CameraUpdate.newCameraPosition(
      CameraPosition(target: myLocation, zoom: 15),
    ),
  );
}
