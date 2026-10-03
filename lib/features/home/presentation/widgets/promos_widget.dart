import 'package:bus_booking/common/app_constants.dart';
import 'package:bus_booking/features/home/application/home_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';

class PromosWidget extends StatelessWidget {
  final HomeBloc homeBloc;

  const PromosWidget({super.key, required this.homeBloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homeBloc,
      child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9.0),
                    child: MyText(
                      text: AppLocalizations.of(context)!.getAttractivePromos,
                      textStyle:
                          Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.width * 0.04),
              if (context.read<HomeBloc>().userData!.bannerImage != null &&
                  context
                      .read<HomeBloc>()
                      .userData!
                      .bannerImage
                      .data
                      .isNotEmpty)
                CarouselSlider(
                  items: List.generate(
                    context.read<HomeBloc>().userData!.bannerImage.data.length,
                    (index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: CachedNetworkImage(
                          imageUrl: context
                              .read<HomeBloc>()
                              .userData!
                              .bannerImage
                              .data[index]
                              .image,
                          width: size.width,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Text(
                              "",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  options: CarouselOptions(
                    height: size.width * 0.35,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.95,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 300),
                    autoPlayCurve: Curves.easeInOut,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      context.read<HomeBloc>().bannerIndex = index;
                      context.read<HomeBloc>().add(UpdateEvent());
                    },
                  ),
                ),
              SizedBox(height: size.width * 0.025),
              if (context.read<HomeBloc>().userData!.bannerImage != null &&
                  context.read<HomeBloc>().userData!.bannerImage.data.length >
                      1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    context.read<HomeBloc>().userData!.bannerImage.data.length,
                    (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          height: size.width * 0.02,
                          width: size.width * 0.02,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  context.read<HomeBloc>().bannerIndex == index
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).primaryColorLight),
                        ),
                      );
                    },
                  ),
                )
            ],
          ),
        );
      }),
    );
  }
}
