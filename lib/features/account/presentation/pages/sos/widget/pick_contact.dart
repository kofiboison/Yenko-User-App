import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../bloc/sos_bloc.dart';

class PickContact extends StatelessWidget {
  const PickContact({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SosBloc, SosState>(
      builder: (context, state) {
        final sosBloc = context.read<SosBloc>();
        return Scaffold(
          body: SafeArea(
            child: Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.width * 0.15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(
                              text: AppLocalizations.of(context)!.selectContact,
                              textStyle: Theme.of(context).textTheme.bodyLarge),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: MyText(
                                text: AppLocalizations.of(context)!.cancel,
                                textStyle:
                                    Theme.of(context).textTheme.bodyLarge),
                          ),
                        ],
                      ),
                      SizedBox(height: size.width * 0.03),
                      SizedBox(
                        height: size.height * 0.82,
                        child: RawScrollbar(
                          child: ListView.builder(
                            itemCount:
                                state.contactsList.length,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 16),
                            itemBuilder: (context, index) {
                              final contact = state.contactsList
                                  .elementAt(index);
                              return Theme(
                                data: ThemeData(
                                  unselectedWidgetColor:
                                      Theme.of(context).primaryColorDark,
                                ),
                                child: RadioListTile(
                                  value: contact,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  activeColor:
                                      Theme.of(context).primaryColorDark,
                                  groupValue:
                                      state.selectedContact,
                                  onChanged: (value) {
                                    sosBloc.add(UpdateSelectContactEvent(contact: contact));
                                  },
                                  title: MyText(
                                    text: contact.name,
                                    maxLines: 2,
                                    textStyle:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  subtitle: MyText(
                                    text: contact.number,
                                    maxLines: 1,
                                    textStyle:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: size.width * 0.03),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 0),
                    spreadRadius: 2,
                    blurRadius: 2,
                    color: Theme.of(context).shadowColor,
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                    width: size.width,
                    buttonColor: Theme.of(context).primaryColor,
                    buttonName: AppLocalizations.of(context)!.confirm,
                    onTap: () {
                      sosBloc.add(AddContactEvent(
                            name: state.selectedContact.name,
                            number:
                                state.selectedContact.number,
                          ));
                      Navigator.pop(context);
                    },
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
