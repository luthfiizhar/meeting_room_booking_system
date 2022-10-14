import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDatePicker extends StatelessWidget {
  CustomDatePicker({
    super.key,
    this.changeDate,
    this.setPickerStatus,
    this.currentDate,
  });

  Function? changeDate;
  Function? setPickerStatus;
  DateTime? currentDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: culturedWhite,
            border: Border.all(
              color: eerieBlack,
              width: 0.5,
            )),
        height: 400,
        width: 300,
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: eerieBlack,
              onPrimary: silver,
              onSurface: eerieBlack,
            ),
          ),
          child: CalendarDatePicker(
            initialDate: currentDate!,
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            currentDate: DateTime.now(),
            onDateChanged: (DateTime value) {
              String formattedDate = DateFormat('d MMM yyyy').format(value);
              currentDate = value;
              changeDate!(formattedDate, value);
              setPickerStatus!(false);
            },
          ),
        ),
        // child: SfDateRangePicker(
        //   view: DateRangePickerView.month,
        //   selectionMode: DateRangePickerSelectionMode.single,
        //   selectionColor: eerieBlack,
        //   todayHighlightColor: eerieBlack,
        //   monthCellStyle: const DateRangePickerMonthCellStyle(
        //     todayTextStyle: TextStyle(
        //       fontSize: 12,
        //       color: eerieBlack,
        //     ),
        //   ),
        //   yearCellStyle: const DateRangePickerYearCellStyle(
        //     todayTextStyle: TextStyle(
        //       fontSize: 12,
        //       color: eerieBlack,
        //     ),
        //   ),
        //   // startRangeSelectionColor: orangeAccent,
        //   onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
        //     print(dateRangePickerSelectionChangedArgs.value);
        //     String formattedDate = DateFormat('d MMM yyyy')
        //         .format(dateRangePickerSelectionChangedArgs.value);
        //     changeDate!(formattedDate);
        //     setPickerStatus!(false);
        //   },
        // ),
      ),
    );
  }
}
