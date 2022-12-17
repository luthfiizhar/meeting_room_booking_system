import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDatePicker extends StatelessWidget {
  CustomDatePicker({
    super.key,
    required this.controller,
    this.changeDate,
    this.setPickerStatus,
    this.currentDate,
    this.isDark = true,
  });

  DateRangePickerController? controller;
  Function? changeDate;
  Function? setPickerStatus;
  DateTime? currentDate;
  bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isDark ? eerieBlack : culturedWhite,
          border: isDark
              ? null
              : Border.all(
                  color: lightGray,
                  width: 1,
                ),
        ),
        height: 300,
        width: 277,
        // child: Theme(
        //   data: Theme.of(context).copyWith(
        //     colorScheme: const ColorScheme.light(
        //       primary: eerieBlack,
        //       onPrimary: silver,
        //       onSurface: eerieBlack,
        //     ),

        //   ),
        //   child: CalendarDatePicker(
        //     initialDate: currentDate!,
        //     firstDate: DateTime.now(),
        //     lastDate: DateTime(3000),
        //     currentDate: DateTime.now(),
        //     onDateChanged: (DateTime value) {
        //       String formattedDate = DateFormat('d MMM yyyy').format(value);
        //       currentDate = value;
        //       changeDate!(formattedDate, value);
        //       setPickerStatus!(false);
        //     },
        //   ),
        // ),
        child: SfDateRangePicker(
          controller: controller,
          initialSelectedDate: currentDate,
          // minDate: DateTime.now(),
          showNavigationArrow: true,
          view: DateRangePickerView.month,
          selectionMode: DateRangePickerSelectionMode.single,
          selectionColor: davysGray,
          todayHighlightColor: culturedWhite,

          headerStyle: DateRangePickerHeaderStyle(
            textStyle: TextStyle(
              fontFamily: 'Helvetica',
              color: isDark ? culturedWhite : eerieBlack,
            ),
          ),
          monthViewSettings: DateRangePickerMonthViewSettings(
            showTrailingAndLeadingDates: true,
            viewHeaderStyle: DateRangePickerViewHeaderStyle(
              textStyle: TextStyle(
                fontFamily: 'Helvetica',
                fontSize: 12,
                color: isDark ? culturedWhite : eerieBlack,
              ),
            ),
          ),
          // cellBuilder: (context, cellDetails) {
          //   return Center(
          //     child: Text(
          //       cellDetails.date.day.toString(),
          //       style: const TextStyle(
          //         color: culturedWhite,
          //       ),
          //     ),
          //   );
          // },
          monthCellStyle: DateRangePickerMonthCellStyle(
            leadingDatesTextStyle: TextStyle(
              fontFamily: 'Helvetica',
              fontSize: 12,
              color: isDark ? davysGray : davysGray,
            ),
            trailingDatesTextStyle: TextStyle(
              fontFamily: 'Helvetica',
              fontSize: 12,
              color: isDark ? davysGray : davysGray,
            ),
            textStyle: TextStyle(
              fontFamily: 'Helvetica',
              fontSize: 12,
              color: isDark ? culturedWhite : eerieBlack,
            ),
            todayTextStyle: TextStyle(
              fontFamily: 'Helvetica',
              fontSize: 12,
              color: isDark ? culturedWhite : eerieBlack,
            ),
          ),
          yearCellStyle: DateRangePickerYearCellStyle(
            textStyle: TextStyle(
              fontFamily: 'Helvetica',
              fontSize: 12,
              color: isDark ? culturedWhite : eerieBlack,
            ),
            todayTextStyle: TextStyle(
              fontSize: 12,
              color: isDark ? culturedWhite : eerieBlack,
            ),
          ),
          selectionShape: DateRangePickerSelectionShape.rectangle,
          selectionTextStyle: TextStyle(
            fontFamily: 'Helvetica',
            fontSize: 12,
            color: isDark ? culturedWhite : eerieBlack,
          ),
          onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
            print(dateRangePickerSelectionChangedArgs.value);
            String formattedDate = DateFormat('d MMM yyyy')
                .format(dateRangePickerSelectionChangedArgs.value);
            changeDate!(
                formattedDate, dateRangePickerSelectionChangedArgs.value);
            setPickerStatus!(false);
            //       String formattedDate = DateFormat('d MMM yyyy').format(value);
            //       currentDate = value;
            //       changeDate!(formattedDate, value);
            //       setPickerStatus!(false);
          },
        ),
      ),
    );
  }
}
