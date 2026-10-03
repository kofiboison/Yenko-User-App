import 'package:bus_booking/core/utils/custom_appbar.dart';
import 'package:bus_booking/core/utils/custom_snack_bar.dart';
import 'package:bus_booking/core/utils/custom_text.dart';
import 'package:bus_booking/features/account/presentation/pages/bookings_history/widget/view_details_widget.dart';
import 'package:bus_booking/features/account/presentation/pages/ratings/ratings_page.dart';
import 'package:bus_booking/features/home/presentation/pages/home_page.dart';
import 'package:bus_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:bus_booking/features/account/domain/models/booking_history_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_dialoges.dart';
import '../../../../../home/domain/models/user_details_model.dart';
import '../../../../../home/presentation/pages/live_tracking.dart';
import '../../support_ticket/page/support_ticket.dart';
import '../bloc/history_bloc.dart';

class BookingHistoryDetailsPage extends StatefulWidget {
  final BookingHistoryData booking;
  final UserDetail userData;
  final HistoryBloc history;
  const BookingHistoryDetailsPage(
      {super.key, required this.booking, required this.userData,required this.history});

  @override
  State<BookingHistoryDetailsPage> createState() =>
      _BookingHistoryDetailsPageState();
}

class _BookingHistoryDetailsPageState extends State<BookingHistoryDetailsPage> {
  bool _ratingSheetShown = false;
  bool newTicketCreated = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.history,
      child: BlocListener<HistoryBloc, HistoryState>(
        listener: (context, state) {
          if (state.status == HistoryStatus.invoiceDownloadSuccess) {
            showToast(
                message:
                    AppLocalizations.of(context)!.invoiceDownloadedSucessfully);
          } else if (state.status == HistoryStatus.invoiceDownloadError) {
            showToast(message: AppLocalizations.of(context)!.failedToDownload);
          } else if (state.status == HistoryStatus.bookingCancelSuccess) {
            context.read<HistoryBloc>().add(HistoryUpdateEvent());
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomePage()),
              (Route<dynamic> route) => false,
            );
          }
        },
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            final historyBloc = context.read<HistoryBloc>();
            if (!_ratingSheetShown &&
                widget.booking.isCompleted != 0 &&
                widget.booking.userRated == 0) {
              _ratingSheetShown = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      final size = MediaQuery.of(context).size;
                      return BlocProvider.value(
                        value: historyBloc,
                        child: Container(
                          height: size.height * 0.19,
                          width: size.width,
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .rateYourJourney,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 20),
                                    BlocBuilder<HistoryBloc, HistoryState>(
                                      builder: (context, state) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: List.generate(5, (index) {
                                            return InkWell(
                                              onTap: () {
                                                context.read<HistoryBloc>().add(
                                                    RatingsSelectEvent(
                                                        selectedIndex:
                                                            index + 1));
                                                Navigator.of(context).pop();
                                                Navigator.pushNamed(
                                                  context,
                                                  RatingsPage.routeName,
                                                  arguments:
                                                      RatingsPageArguments(
                                                    booking: widget.booking,
                                                    ticketNumber: widget
                                                        .booking.ticketNumber,
                                                    journeryId: widget
                                                        .booking.journeyId,
                                                    selectedRatingsIndex:
                                                        index + 1,
                                                  ),
                                                );
                                              },
                                              child: Icon(
                                                (index + 1 <=
                                                        (state.selectedRatingsIndex ??
                                                            0))
                                                    ? Icons.star
                                                    : Icons
                                                        .star_border_outlined,
                                                color: (index + 1 <=
                                                        (state.selectedRatingsIndex ??
                                                            0))
                                                    ? AppColors.goldenColor
                                                    : Theme.of(context)
                                                        .disabledColor,
                                                size: 30,
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 28,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              });
            }
            return Scaffold(
                backgroundColor: AppColors.white,
                appBar: CustomAppBar(
                  title: widget.booking.ticketNumber,
                  automaticallyImplyLeading: true,
                  onBackTap: () {
                    Navigator.of(context).pop();
                    historyBloc.scrollController.dispose();
                  },
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyText(
                              text: '${widget.booking.company} ',
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                            ),
                            MyText(
                              text: '${widget.booking.vehicleNumber} ',
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(height: size.width * 0.03),
                        // Top Row: Route and Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.booking.fromCity} → ${widget.booking.toCity}",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                (widget.booking.ratings > 0)
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(5, (index) {
                                          return Icon(
                                            index <
                                                    widget.booking.ratings
                                                        .round()
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.amber,
                                            size: 16,
                                          );
                                        }),
                                      )
                                    : const SizedBox()
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: widget.booking.isCancelled == 1
                                    ? Colors.red[100]
                                    : widget.booking.isCompleted == 1
                                        ? Colors.green[100]
                                        : widget.booking.isTripStarted == true
                                            ? Colors.blue[100]
                                            : Colors.orange[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                widget.booking.isCancelled == 1
                                    ? AppLocalizations.of(context)!
                                        .cancelled
                                        .toUpperCase()
                                    : widget.booking.isCompleted == 1
                                        ? AppLocalizations.of(context)!
                                            .completed
                                            .toUpperCase()
                                        : widget.booking.isTripStarted == true
                                            ? AppLocalizations.of(context)!
                                                .ongoing
                                            : AppLocalizations.of(context)!
                                                .upcoming
                                                .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: widget.booking.isCancelled == 1
                                      ? Colors.red
                                      : widget.booking.isCompleted == 1
                                          ? Colors.green
                                          : widget.booking.isTripStarted == true
                                              ? Colors.blue
                                              : Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Time and Duration
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${widget.booking.departureTime}\n${widget.booking.fromCity}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Column(
                              children: [
                                Text(
                                  widget.booking.travelDuration,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const Icon(Icons.arrow_forward),
                              ],
                            ),
                            Text(
                              "${widget.booking.arraivalTime}\n${widget.booking.toCity}",
                              textAlign: TextAlign.right,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Ticket and passenger count
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${AppLocalizations.of(context)!.ticket} ${widget.booking.ticketNumber}"),
                            Text(
                              '${widget.booking.requestedCurrencySymbol} ${widget.booking.journeyBill.data.first.totalAmount}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        const Divider(height: 30),
                        // Boarding and Drop
                        ListTile(
                          leading: const Icon(Icons.location_on_outlined,
                              color: Colors.black87),
                          title: Text(widget.booking.boardingAddress,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              "${AppLocalizations.of(context)!.boaring} ${widget.booking.departureDate} ${widget.booking.departureTime}"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.location_pin,
                              color: Colors.black87),
                          title: Text(widget.booking.dropAddress,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              "${AppLocalizations.of(context)!.arrival} ${widget.booking.arraivalDate} ${widget.booking.arraivalTime}"),
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              builder: (_) {
                                return BlocProvider.value(
                                    value: historyBloc,
                                    child: ViewDetailsWidget(
                                        boardingList:
                                            widget.booking.boarding!.data,
                                        stopList: widget.booking.stop!.data,
                                        boardingAddress:
                                            widget.booking.boardingAddress,
                                        dropAddress:
                                            widget.booking.dropAddress));
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            color: AppColors.transparent,
                            child: MyText(
                              text: AppLocalizations.of(context)!.viewDetails,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.blue,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        if (widget.booking.journeyPassengerDetail.data
                            .isNotEmpty) ...[
                          const Divider(height: 30),
                          Text(AppLocalizations.of(context)!.passengers,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          ListView.builder(
                            itemCount: widget
                                .booking.journeyPassengerDetail.data.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final passenger = widget
                                  .booking.journeyPassengerDetail.data
                                  .elementAt(index);
                              return ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(passenger['name'] ?? ''),
                                subtitle: Text(
                                    "${AppLocalizations.of(context)!.seat} ${passenger['seat_no'] ?? ''}, Age: ${passenger['age'] ?? ''}, Gender: ${passenger['gender'] ?? ''}"),
                              );
                            },
                          ),
                        ],
                        SizedBox(
                          height: size.width * 0.05,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.fareBreakup} ",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: size.width * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.ticketFare,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '${widget.booking.requestedCurrencySymbol} ${widget.booking.ticketFare}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            if (widget.booking.journeyBill.data.first
                                    .promoDiscount !=
                                '0')
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.promo,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '- ${widget.booking.requestedCurrencySymbol} ${widget.booking.journeyBill.data.first.promoDiscount}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: AppColors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.serviceTax,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '${widget.booking.requestedCurrencySymbol} ${widget.booking.journeyBill.data.first.serviceTax}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            if (widget.booking.isCancelled == 1)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .cancellationFee,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '- ${widget.booking.requestedCurrencySymbol} ${widget.booking.journeyBill.data.first.cancellationFee}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: AppColors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            if (widget.booking.isCancelled == 1)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .creditedAmountToWallet,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '${widget.booking.requestedCurrencySymbol} ${widget.booking.refundAmount}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: AppColors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            if (widget.booking.isCancelled != 1) ...[
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.totalPrice,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${widget.booking.requestedCurrencySymbol} ${widget.booking.journeyBill.data.first.totalAmount}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const Divider(),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: (widget.booking.isCancelled != 1 &&
                        widget.booking.isCompleted != 1 &&
                        widget.booking.isTripStarted != true)
                    ? Container(
                        decoration: const BoxDecoration(color: AppColors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomButton(
                                width: size.width * 0.9,
                                buttonName:
                                    AppLocalizations.of(context)!.cancelBooking,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierColor: Theme.of(context).shadowColor,
                                    builder: (BuildContext _) {
                                      return BlocProvider.value(
                                        value: BlocProvider.of<HistoryBloc>(
                                            context),
                                        child: CustomDoubleButtonDialoge(
                                          title: AppLocalizations.of(context)!
                                              .bookingCancellation,
                                          content: AppLocalizations.of(context)!
                                              .bookingCancellationText,
                                          noBtnName:
                                              AppLocalizations.of(context)!.no,
                                          yesBtnName:
                                              AppLocalizations.of(context)!.yes,
                                          yesBtnFunc: () {
                                            historyBloc.add(BookingCancelEvent(
                                              journeyId:
                                                  widget.booking.journeyId,
                                              userId: widget.booking.userId
                                                  .toString(),
                                              ticketNumber:
                                                  widget.booking.ticketNumber,
                                            ));
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  context.read<HistoryBloc>().add(
                                        DownloadInvoiceEvent(
                                            journeyId:
                                                widget.booking.id.toString()),
                                      );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.share_sharp,
                                      color: AppColors.blue,
                                      size: 18,
                                    ),
                                    SizedBox(width: size.width * 0.01),
                                    MyText(
                                      text: AppLocalizations.of(context)!
                                          .shareticket,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.blue,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                            ],
                          ),
                        ),
                      )
                    : (widget.booking.isCompleted != 0)
                        // ? const SizedBox()
                        ? Container(
                            color: AppColors.white,
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomButton(
                                  width: size.width * 0.9,
                                  buttonName:
                                      AppLocalizations.of(context)!.shareticket,
                                  onTap: () {
                                    context.read<HistoryBloc>().add(
                                          DownloadInvoiceEvent(
                                              journeyId:
                                                  widget.booking.id.toString()),
                                        );
                                  },
                                ),
                                const SizedBox(height: 8),
                                if(widget.booking.supportTicketExists && !newTicketCreated)
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5,
                                        top: 10,
                                        right: 5,
                                        bottom: 10),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .disabledColor),
                                        color: Theme.of(context).disabledColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              MyText(
                                                text:
                                                    "${AppLocalizations.of(context)!.ticketCreated} :",
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .scaffoldBackgroundColor),
                                              ),
                                              SizedBox(
                                                  width: size.width * 0.02),
                                              MyText(
                                                text: widget.booking.ticketId,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          MyText(
                                            text:  widget.booking.ticketStatus ==
                                                    1
                                                ? AppLocalizations.of(context)!
                                                    .pending
                                                : widget.booking.ticketStatus ==
                                                        2
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .acknowledged
                                                    : AppLocalizations.of(
                                                            context)!
                                                        .closed,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                    color: widget.booking.ticketStatus ==
                                                            1
                                                        ? AppColors.blue
                                                        : widget.booking.ticketStatus ==
                                                                2
                                                            ? AppColors.orange
                                                            : AppColors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                if(newTicketCreated)
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5,
                                        top: 10,
                                        right: 5,
                                        bottom: 10),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .disabledColor),
                                        color: Theme.of(context).disabledColor,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              MyText(
                                                text: AppLocalizations.of(context)!.supportTicketCreatedSuccessfully,
                                                maxLines: 2,    
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .scaffoldBackgroundColor),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                if(!widget.booking.supportTicketExists && !newTicketCreated)  
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, SupportTicketPage.routeName,
                                        arguments: SupportTicketPageArguments(
                                            isFromRequest: true, requestId: widget.booking.ticketNumber)).then((value) {
                                              if(value !=null && value == true){
                                                setState(() =>newTicketCreated = value as bool);
                                              }
                                            },);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.warning,
                                        color: AppColors.red,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: size.width * 0.01,
                                      ),
                                      MyText(
                                        text: AppLocalizations.of(context)!.reportIssue,
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: AppColors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : (widget.booking.isTripStarted)
                            ? Container(
                                decoration:
                                    const BoxDecoration(color: AppColors.white),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomButton(
                                        width: size.width * 0.9,
                                        buttonName:
                                            AppLocalizations.of(context)!
                                                .trackNow,
                                        buttonColor: AppColors.green
                                            .withAlpha((0.2 * 255).toInt()),
                                        textColor: AppColors.green,
                                        onTap: () {
                                          if (widget.userData
                                                  .upcomingjourneyUser !=
                                              null) {
                                            Navigator.pushNamed(
                                              context,
                                              LiveTracking.routeName,
                                              arguments: LiveTrackingArguments(
                                                arraivalTime: widget
                                                    .userData
                                                    .upcomingjourneyUser
                                                    ?.data
                                                    .arraivalTime,
                                                fromCity: widget
                                                    .userData
                                                    .upcomingjourneyUser
                                                    ?.data
                                                    .fromCity,
                                                toCity: widget
                                                    .userData
                                                    .upcomingjourneyUser
                                                    ?.data
                                                    .toCity,
                                                departureTime: widget
                                                    .userData
                                                    .upcomingjourneyUser
                                                    ?.data
                                                    .departureTime,
                                                arrivalTime: widget
                                                    .userData
                                                    .upcomingjourneyUser
                                                    ?.data
                                                    .arraivalTime,
                                                departureDate: widget
                                                    .userData
                                                    .upcomingjourneyUser
                                                    ?.data
                                                    .departureDate,
                                                arrivalDate: widget
                                                    .userData
                                                    .upcomingjourneyUser
                                                    ?.data
                                                    .arraivalDate,
                                                ticketNumber: widget
                                                    .userData
                                                    .upcomingjourneyUser
                                                    ?.data
                                                    .ticketNumber,
                                                passengerCount: widget
                                                    .userData
                                                    .upcomingjourneyUser
                                                    ?.data
                                                    .passengerCount,
                                                travelDuration: widget
                                                    .userData
                                                    .upcomingjourneyUser
                                                    ?.data
                                                    .travelDuration,
                                                journeyId: widget
                                                    .userData
                                                    .upcomingjourneyUser!
                                                    .data
                                                    .journeyId,
                                                boardingPoints:
                                                    Boardingpoints.fromJson(
                                                            widget.booking
                                                                .boarding!
                                                                .toJson())
                                                        .data,
                                                stopPoints: Stoppoints.fromJson(
                                                        widget.booking.stop!
                                                            .toJson())
                                                    .data,
                                                boardingAddress: widget
                                                    .userData
                                                    .upcomingjourneyUser
                                                    ?.data
                                                    .boardingAddress,
                                                dropAddress: widget
                                                    .userData
                                                    .upcomingjourneyUser
                                                    ?.data
                                                    .dropAddress,
                                                polyline: widget
                                                    .userData
                                                    .upcomingjourneyUser
                                                    ?.data
                                                    .polyLine,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () {
                                          context.read<HistoryBloc>().add(
                                                DownloadInvoiceEvent(
                                                  journeyId: widget.booking.id
                                                      .toString(),
                                                ),
                                              );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.share_sharp,
                                              color: AppColors.blue,
                                              size: 18,
                                            ),
                                            SizedBox(width: size.width * 0.01),
                                            MyText(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .shareticket,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.blue,
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.02),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox());
          },
        ),
      ),
    );
  }
}
