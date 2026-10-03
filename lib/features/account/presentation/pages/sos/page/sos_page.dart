import 'package:bus_booking/features/account/domain/models/contact_model.dart';
import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_dialoges.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../home/domain/models/user_details_model.dart';
import '../bloc/sos_bloc.dart';
import '../widget/sos_card_shimmer.dart';
import '../widget/pick_contact.dart';

class SosPage extends StatelessWidget {
  static const String routeName = '/sosPage';
  const SosPage({super.key, });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SosBloc()..add(SosGetUserDetailsEvent()),
      child: BlocListener<SosBloc, SosState>(
        listener: (context, state) {
          final sosBloc = context.read<SosBloc>();
           if (state.status == SosStatus.selectContactDetails) {
            sosBloc.add(SosUpdateEvent());
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              useRootNavigator: true,
              isScrollControlled: true,
              builder: (_) {
                return BlocProvider.value(
                  value: sosBloc,
                  child: const PickContact(),
                );
              },
            );
          }
        },
        child: BlocBuilder<SosBloc, SosState>(builder: (context, state) {
          final sosBloc = context.read<SosBloc>();
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                title: MyText(
                    text: AppLocalizations.of(context)!.sos,
                    textStyle: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).primaryColor)),
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (state.isLoading)
                        ListView.builder(
                          itemCount: 6,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return const SosShimmerLoading();
                          },
                        ),
                      if (!state.isLoading)
                        sosDetails(size, state.sosData, context,sosBloc),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: (state.sosData.length <= 4)
                  ? SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 15),
                        child: CustomButton(
                            buttonName:
                                AppLocalizations.of(context)!.addContact,
                            isLoader: state.isLoading,
                            onTap: () {
                              sosBloc.add(UpdateSelectContactEvent(contact: ContactsModel(name: '', number: '')));
                              sosBloc.add(SelectContactDetailsEvent());
                            }),
                      ),
                    )
                  : null);
        }),
      ),
    );
  }

  Widget sosDetails(Size size, List<SOSDatum> sosdata, BuildContext context,SosBloc sosBloc) {
    return (sosdata.isNotEmpty && sosdata.first.userType != 'admin')
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: sosdata.length,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return (sosdata[index].userType != 'admin')
                  ? Container(
                      width: size.width,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              width: 0.5,
                              color: Theme.of(context).disabledColor)),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Container(
                              height: size.width * 0.13,
                              width: size.width * 0.13,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .disabledColor
                                    .withAlpha((0.2 * 255).toInt()),
                              ),
                              alignment: Alignment.center,
                              child: MyText(
                                text: sosdata[index]
                                    .name
                                    .toString()
                                    .substring(0, 1),
                              ),
                            ),
                            SizedBox(width: size.width * 0.025),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyText(
                                    text: sosdata[index].name,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                    maxLines: 2,
                                  ),
                                  MyText(
                                    text: sosdata[index].number,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .disabledColor
                                                .withAlpha(
                                                    (0.6 * 255).toInt())),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: size.width * 0.025),
                            InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierColor: Theme.of(context).shadowColor,
                                    builder: (BuildContext _) {
                                      return BlocProvider.value(
                                        value:
                                            BlocProvider.of<SosBloc>(context),
                                        child: CustomDoubleButtonDialoge(
                                          title: AppLocalizations.of(context)!
                                              .deleteSos,
                                          content: AppLocalizations.of(context)!
                                              .deleteContactConfirmation,
                                          yesBtnName:
                                              AppLocalizations.of(context)!.yes,
                                          noBtnName:
                                              AppLocalizations.of(context)!.no,
                                          yesBtnFunc: () {
                                            sosBloc.add(
                                                DeleteContactEvent(
                                                    id: sosdata[index].id));
                                            Navigator.pop(context);
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ))
                          ],
                        ),
                      ),
                    )
                  : const SizedBox();
            },
          )
        : const SosNodataWidget();
  }
}

class SosNodataWidget extends StatelessWidget {
  const SosNodataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.empty,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 5),
            MyText(
              text: AppLocalizations.of(context)!.noSosFound,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontSize: 16,
                  ),
            ),
            MyText(
              text: AppLocalizations.of(context)!.addContactText,
              maxLines: 2,
              textAlign: TextAlign.center,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontSize: 16,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
