import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_1/model/task.dart';

class TaskWidget extends StatelessWidget {
  Task task;
  TaskWidget({super.key, required this.task});
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    DateTime taskDate = DateTime.fromMicrosecondsSinceEpoch(task.date ?? 0);
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            onPressed: (context){},
            icon: Icons.delete,
            label: 'Delete',
            backgroundColor: Colors.red,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            )
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              height: height * 0.1,
              width: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title ?? '',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      children: [
                        const Icon(Icons.access_time_outlined, size: 20,),
                        const SizedBox(width: 5,),
                        Text(
                          '${DateFormat.jm().format(taskDate)}',
                          style: Theme.of(context).textTheme.titleSmall,
                        )
                      ],
                    ),
                  ],
                )
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
              onPressed: (){},
              child: const Icon(Icons.check)
            ),
          ],
        ),
      ),
    );
  }
}