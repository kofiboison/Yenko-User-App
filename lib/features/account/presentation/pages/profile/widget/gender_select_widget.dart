import 'package:bus_booking/common/app_colors.dart';
import 'package:bus_booking/common/app_constants.dart';
import 'package:bus_booking/core/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile_bloc.dart';

class GenderSelector extends StatelessWidget {
  const GenderSelector({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final profileBloc = context.read<ProfileBloc>();
        String selectedGender = state.selectedGender;
        return Row(
          children: state.genderOptions.map((gender) {
            final isSelected = selectedGender == gender['value'];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      profileBloc
                          .add(GenderSelectedEvent(gender['value'].toString()));
                    },
                    child: Container(
                      height: size.width * 0.1,
                      width: size.width * 0.1,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).shadowColor,
                      ),
                      child: Icon(
                        gender['icon'] as IconData,
                        color: isSelected
                            ? AppColors.white
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: size.width * 0.02),
                  MyText(
                    text: gender['label'].toString(),
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).primaryColor),
                  )
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
