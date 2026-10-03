import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/models/bus_list_model.dart';

class BusDetailsWidget extends StatefulWidget {
  const BusDetailsWidget({
    super.key,
    required this.bus,
  });

  final BusData bus;

  @override
  State<BusDetailsWidget> createState() => _BusDetailsWidgetState();
}

class _BusDetailsWidgetState extends State<BusDetailsWidget> {
  int bannerIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: size.height * 0.75,
          width: size.width,
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.width * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                                text: widget.bus.busCompanyName,
                                maxLines: 2,
                                textStyle:
                                    Theme.of(context).textTheme.bodyLarge),
                            SizedBox(height: size.width * 0.01),
                            MyText(
                                text:
                                    '${(widget.bus.bus.data.isAcAvailable == '1') ? AppLocalizations.of(context)!.ac : AppLocalizations.of(context)!.nonAc} • ${widget.bus.bus.data.seatType}',
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      if (widget.bus.rating != '0')
                        SizedBox(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          size: 20,
                                          color: AppColors.goldenColor),
                                      SizedBox(width: size.width * 0.01),
                                      MyText(
                                          text: widget.bus.rating,
                                          maxLines: 2,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
                                    ],
                                  ),
                                  Container(
                                    color: AppColors.black,
                                    height: 1,
                                  ),
                                  SizedBox(height: size.width * 0.01),
                                  Row(
                                    children: [
                                      const Icon(Icons.group, size: 15),
                                      SizedBox(width: size.width * 0.01),
                                      MyText(
                                          text: widget.bus.noOfratings,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                  SizedBox(height: size.width * 0.06),
                  Container(
                    width: size.width,
                    height: size.width * 0.3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        )),
                    child: CarouselSlider(
                      items: List.generate(
                        widget.bus.bus.data.busImage.length,
                        (index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: CachedNetworkImage(
                              imageUrl: widget.bus.bus.data.busImage[index],
                              width: size.width,
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
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
                        height: size.width * 0.3,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1,
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
                          setState(() => bannerIndex = index);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: size.width * 0.03),
                  if (widget.bus.bus.data.busImage.isNotEmpty &&
                  widget.bus.bus.data.busImage.length > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.bus.bus.data.busImage.length,
                    (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          height: size.width * 0.02,
                          width: size.width * 0.02,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: bannerIndex == index
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).primaryColorLight),
                        ),
                      );
                    },
                  ),
                ),
                  SizedBox(height: size.width * 0.03),
                  MyText(
                    text: AppLocalizations.of(context)!.amenties,
                    maxLines: 2,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: size.width * 0.01),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: List.generate(
                      widget.bus.bus.data.amenities!.data.length,
                      (index) {
                        final amenity =
                            widget.bus.bus.data.amenities!.data.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: size.width * 0.1,
                                width: size.width * 0.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.grey,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Image.network(amenity.icon,
                                      height: size.width * 0.1),
                                ),
                              ),
                              SizedBox(height: size.width * 0.01),
                              SizedBox(
                                width: size.width * 0.13,
                                child: Center(
                                  child: MyText(
                                    text: amenity.name,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 10),
                                  ),
                                ),
                              ),
                              SizedBox(height: size.width * 0.02),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: size.width * 0.02),
                  ExpansionTile(
                    title: MyText(
                        text: AppLocalizations.of(context)!.boardingPoints,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: EdgeInsets.zero,
                    dense: true,
                    children:
                        List.generate(widget.bus.boardingpoints.data.length, (index) {
                      final boarding = widget.bus.boardingpoints.data.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 20),
                            SizedBox(width: size.width * 0.03),
                            MyText(
                              text: boarding.boardingLandmark,
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  ExpansionTile(
                    title: MyText(
                        text: AppLocalizations.of(context)!.dropPoints,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: EdgeInsets.zero,
                    dense: true,
                    children:
                        List.generate(widget.bus.stoppoints.data.length, (index) {
                      final stop = widget.bus.stoppoints.data.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 20),
                            SizedBox(width: size.width * 0.03),
                            MyText(
                              text: stop.stopLandmark,
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: size.width * 0.03),
                  MyText(
                    text: AppLocalizations.of(context)!.bookingCancellation,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: size.width * 0.018),
                  widget.bus.cancellationpolicy.trim().isEmpty
                      ? Center(
                          child: MyText(
                            text: 'No Data Found',
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        )
                      : buildCancellationTable(context, widget.bus.cancellationpolicy),
                  SizedBox(height: size.width * 0.1),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          child: Container(
            width: size.width,
            height: size.width * 0.05,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Container(
                height: size.width * 0.01,
                width: size.width * 0.1,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCancellationTable(BuildContext context, String htmlString) {
    final tableData = parseHtmlTables(htmlString);

    if (tableData.isEmpty) {
      return Center(
        child: MyText(
          text: 'No Data Found',
          textStyle: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      );
    }

    final maxColumns = tableData.fold<int>(
      0,
      (max, row) => row.length > max ? row.length : max,
    );

    return Table(
      border: TableBorder.all(color: Colors.grey),
      columnWidths: {
        for (int i = 0; i < maxColumns; i++) i: const FlexColumnWidth(1),
      },
      children: tableData.map((row) {
        final paddedRow = List<String>.from(row)
          ..addAll(List.filled(maxColumns - row.length, ''));

        return TableRow(
          children: paddedRow.map((cell) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyText(
                text: cell,
                textStyle: Theme.of(context).textTheme.bodySmall,
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  List<List<String>> parseHtmlTables(String htmlString) {
    final tableRegex = RegExp(r'<table.*?>(.*?)</table>', dotAll: true);
    final rowRegex = RegExp(r'<tr>(.*?)</tr>', dotAll: true);
    final cellRegex = RegExp(r'<t[dh]>(.*?)</t[dh]>', dotAll: true);

    final tables = <List<List<String>>>[];

    for (final tableMatch in tableRegex.allMatches(htmlString)) {
      final tableContent = tableMatch.group(1)!;
      final rows = <List<String>>[];

      for (final rowMatch in rowRegex.allMatches(tableContent)) {
        final rowContent = rowMatch.group(1)!;
        final cells = cellRegex
            .allMatches(rowContent)
            .map((e) => e.group(1)!.replaceAll(RegExp(r'\s+'), ' ').trim())
            .toList();
        rows.add(cells);
      }
      tables.add(rows);
    }

    return tables.expand((e) => e).toList();
  }
}
