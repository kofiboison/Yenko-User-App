import 'package:flutter/material.dart';

import '../../common/common.dart';

class CustomDivider extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  const CustomDivider({super.key, this.height, this.width, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: width ?? size.width * 0.13,
        height: height ?? size.width * 0.01,
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).dividerColor,
          borderRadius: BorderRadius.circular(size.width * 0.05),
        ),
      ),
    );
  }
}

class VerticalDotDividerWidget extends StatelessWidget {
  final int? length;
  final double? height;
  final double? width;
  final Color? color;
  const VerticalDotDividerWidget(
      {super.key, this.length = 10, this.height, this.width, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length!,
        (index) {
          return Container(
            margin: EdgeInsets.only(
                top: size.width * 0.005, bottom: size.width * 0.005),
            height: height ?? 3,
            width: width ?? 1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color ??
                  Theme.of(context)
                      .primaryColorDark
                      .withAlpha((0.5 * 255).toInt()),
            ),
          );
        },
      ),
    );
  }
}

class HorizontalDotDividerWidget extends StatelessWidget {
  final int? length;
  final Color? color;
  const HorizontalDotDividerWidget({super.key, this.length, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        length ?? 25,
        (index) {
          return Container(
            margin: EdgeInsets.only(right: size.width * 0.01),
            height: size.width * 0.003,
            width: size.width * 0.02,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color ??
                  Theme.of(context)
                      .primaryColorDark
                      .withAlpha((0.3 * 255).toInt()),
            ),
          );
        },
      ),
    );
  }
}
