import 'package:bus_booking/features/home/application/home_bloc.dart';
import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';
import '../../domain/models/popular_routes_model.dart';

class PopularRouteWidget extends StatelessWidget {
  final HomeBloc homeBloc;

  const PopularRouteWidget(
      {super.key, required this.homeBloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homeBloc,
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {},
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (homeBloc.popularRoutesModel != null &&
                      homeBloc.popularRoutesModel!.data.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text:
                              AppLocalizations.of(context)!.popularRecentRoutes,
                          textStyle:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                        ),
                      ],
                    ),
                  SizedBox(height: size.width * 0.04),
                  if (homeBloc.popularRoutesModel != null &&
                      homeBloc.popularRoutesModel!.data.isNotEmpty)
                    SizedBox(
                      height: size.width * 0.20,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: homeBloc.popularRoutesModel!.data.length,
                        itemBuilder: (context, index) {
                          final route = homeBloc.popularRoutesModel!.data
                              .elementAt(index);
                          return Padding(
                            padding: EdgeInsets.only(
                              right: (index ==
                                      homeBloc.popularRoutesModel!.data.length -
                                          1)
                                  ? 0
                                  : 15,
                            ),
                            child: _buildRouteCard(context, route),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRouteCard(BuildContext context, PopularRouteData route) {
    return InkWell(
      onTap: () {
        context.read<HomeBloc>().add(PopularRoutesEvent(route: route));
      },
      child: Container(
        width: size.width * 0.71,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).hintColor.withAlpha((0.1 * 255).toInt()),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          // border: Border.all(
          //   width: 0.5,
          //   color: Theme.of(context).primaryColor,
          // ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: MyText(
                    text: route.fromCityName,
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: size.width * 0.015),
                const Icon(Icons.arrow_forward, size: 18),
                const SizedBox(width: 19),
                Expanded(
                  child: MyText(
                    text: route.toCityName,
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
