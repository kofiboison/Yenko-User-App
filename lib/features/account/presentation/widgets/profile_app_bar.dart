import 'package:bus_booking/features/home/domain/models/user_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/acc_bloc.dart';
import '../pages/profile/page/profile_edit.dart';

class CustomProfileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final UserDetail userDetail;
  const CustomProfileAppBar({super.key, required this.userDetail});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: size.height * 0.21,
      backgroundColor: Theme.of(context).primaryColor,
      automaticallyImplyLeading: false,
      flexibleSpace: Padding(
        padding: EdgeInsets.only(
          top: size.width * 0.16,
          left: 16,
          right: 16,
        ),
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                SizedBox(width: size.width * 0.06),
                MyText(
                  text: AppLocalizations.of(context)!.profile,
                  textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        fontSize: 20,
                      ),
                ),
              ],
            ),
            SizedBox(height: size.width * 0.04),
            Row(
              children: [
                CircleAvatar(
                  radius: size.width * 0.10,
                  backgroundColor: Theme.of(context).dividerColor,
                  backgroundImage: userDetail.profilePicture.isNotEmpty
                      ? NetworkImage(userDetail.profilePicture)
                      : null,
                ),
                SizedBox(width: size.width * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: userDetail.name,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                    ),
                    MyText(
                      text: userDetail.mobile,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                    ),
                  ],
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, ProfileEditPage.routeName,
                            arguments:
                                ProfileEditPageArguments(userData: userDetail))
                        .then((value) {
                      if (!context.mounted) return;
                      if (value != null) {
                        context.read<AccBloc>().add(AccountPageInitEvent(userDetailData: value as UserDetail));
                      }
                    });
                  },
                  child: Icon(
                    Icons.edit_square,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      foregroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(size.height * 0.21);
}
