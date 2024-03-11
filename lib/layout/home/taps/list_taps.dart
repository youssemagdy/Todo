import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_1/style/app_colors.dart';
import 'package:todo_app_1/style/theme.dart';

class ListTaps extends StatefulWidget {
  const ListTaps({Key? key}) : super(key: key);
  @override
  State<ListTaps> createState() => _ListTapsState();
}

class _ListTapsState extends State<ListTaps> {
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EasyInfiniteDateTimeLine(
          firstDate: DateTime.now(),
          focusDate: selectedDate,
          lastDate: DateTime.now().add(const Duration(days: 365)),
          timeLineProps: const EasyTimeLineProps(
            separatorPadding: 20,
          ),
          dayProps: const EasyDayProps(
            activeDayStyle: DayStyle(
                decoration: BoxDecoration(
                  color: AppColors.primaryLightColor,
                )
            ),
            inactiveDayStyle: DayStyle(
                decoration: BoxDecoration(
                  color: Colors.white,
                )
            ),
          ),
          showTimelineHeader: false,
          onDateChange: (newSelectedDate) {
            setState(() {
              selectedDate = newSelectedDate;
            });
          },
        ),
        
      ],
    );
  }
}
