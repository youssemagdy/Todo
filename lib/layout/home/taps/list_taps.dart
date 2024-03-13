import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_1/layout/home/widget/task_widget.dart';
import 'package:todo_app_1/model/task.dart';
import 'package:todo_app_1/shared/provider/auth_provider.dart';
import 'package:todo_app_1/shared/remote/firebase/firestore_helper.dart';
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
    Authprovider provider = Provider.of<Authprovider>(context);
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
              selectedDate = DateTime(
                newSelectedDate.year,
                newSelectedDate.month,
                newSelectedDate.day,
              );
              print(selectedDate.toString());
            });
          },
        ),
        const SizedBox(height: 10,),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder(
                stream: FirestoreHelper.listenToTasks(provider.firebaseUserAuth!.uid, selectedDate.millisecondsSinceEpoch),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    // loading
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  if(snapshot.hasError){
                    // error
                    return Column(
                      children: [
                        Text('Something Went Wrong ${snapshot.error}'),
                        ElevatedButton(
                            onPressed: (){},
                            child: const Text('Try Again'),
                        ),
                      ],
                    );
                  }
                  // successfully date return
                  List<Task> tasks = snapshot.data ?? [];
                  return ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(height: 20,),
                    itemBuilder: (context, index) => TaskWidget(
                      task: tasks[index],
                    ),
                    itemCount: tasks.length,
                  );
                }
            ),
          ),
        )
      ],
    );
  }
}
