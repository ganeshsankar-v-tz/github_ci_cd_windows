import 'dart:convert';

import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/trasaction/product_sale/add_product_sales.dart';
import 'package:abtxt/view/trasaction/product_sales_calender_view/product_sales_calender_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ProductSalesCalenderView extends StatefulWidget {
  const ProductSalesCalenderView({super.key});

  static const String routeName = '/product_sales_calender_view';

  @override
  State<ProductSalesCalenderView> createState() =>
      _ProductSalesCalenderViewState();
}

class _ProductSalesCalenderViewState extends State<ProductSalesCalenderView> {
  ProductSalesCalenderController controller = Get.find();
  DateTime? _currentMonth;

  @override
  void initState() {
    super.initState();
    controller.dataSource = MeetingDataSource(controller.calenderList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductSalesCalenderController>(
      builder: (controller) {
        return CoreWidget(
          loadingStatus: controller.status.isLoading,
          appBar: AppBar(
            title: const Text("Calender View"),
            actions: [
              TextButton(
                onPressed: () => controller.productSaleList(),
                child: const Text("Product Order Details"),
              ),
              const SizedBox(width: 25),
              TextButton(
                onPressed: () => controller.productSaleList(),
                child: const Text("Product Sale Details"),
              ),
              const SizedBox(width: 25),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SfCalendar(
              dataSource: controller.dataSource,
              showTodayButton: true,
              view: CalendarView.week,
              allowViewNavigation: false,
              showNavigationArrow: true,
              showDatePickerButton: true,
              viewNavigationMode: ViewNavigationMode.snap,
              todayHighlightColor: Colors.blue,
              allowedViews: const <CalendarView>[
                CalendarView.week,
                CalendarView.month,
                CalendarView.schedule,
              ],
              headerStyle: const CalendarHeaderStyle(
                textAlign: TextAlign.center,
                backgroundColor: Colors.white,
                textStyle: TextStyle(
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              timeSlotViewSettings: const TimeSlotViewSettings(
                timeIntervalHeight: 200,
                timeInterval: Duration(hours: 2),
                startHour: 9,
                endHour: 20,
                dateFormat: 'd',
                dayFormat: 'EEE',
                timeTextStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              scheduleViewSettings: const ScheduleViewSettings(
                appointmentItemHeight: 200,
                hideEmptyScheduleWeek: true,
              ),
              selectionDecoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.lightBlue, width: 2),
              ),
              monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                showAgenda: true,
                agendaItemHeight: 70,
                appointmentDisplayCount: 2,
                dayFormat: 'EEE',
                agendaStyle: AgendaStyle(
                  dateTextStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  dayTextStyle: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              appointmentBuilder: (context, calendarAppointmentDetails) {
                final Appointment appointment =
                    calendarAppointmentDetails.appointments.first;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green.shade400,
                    ),
                    child: Center(
                      child: Text(
                        appointment.subject,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                );
              },
              onTap: (calendarTapDetails) {
                if (calendarTapDetails.targetElement ==
                    CalendarElement.appointment) {
                  final tappedDate = calendarTapDetails.date;

                  var appointmentDetails =
                      calendarTapDetails.appointments?.first?.notes;

                  if (appointmentDetails != null) {
                    appointmentDetails = jsonDecode(appointmentDetails);

                    Get.toNamed(AddProductSales.routeName);
                  }
                }
              },
              onViewChanged: (ViewChangedDetails details) {
                // Get a date from the middle of the visible dates list
                final DateTime midDate =
                    details.visibleDates[details.visibleDates.length ~/ 2];

                // Get current visible month (1st day of the month)
                final DateTime startOfMonth =
                    DateTime(midDate.year, midDate.month, 1);

                // Get last day of the month using DateTime manipulation
                final DateTime endOfMonth =
                    DateTime(midDate.year, midDate.month + 1, 0);

                // Call API only if month has changed
                if (_currentMonth == null ||
                    _currentMonth!.month != startOfMonth.month ||
                    _currentMonth!.year != startOfMonth.year) {
                  _currentMonth = startOfMonth;

                  // Call API

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // Call setState after build
                    var request = {
                      "start_date": startOfMonth,
                      "end_date": endOfMonth
                    };
                    controller.productSaleList(request: request);
                  });
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(RxList<Appointment> source) {
    appointments = source;
  }

}
