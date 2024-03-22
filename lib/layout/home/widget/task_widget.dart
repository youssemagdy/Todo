import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_1/layout/home/edit_screen.dart';
import 'package:todo_app_1/model/task.dart';
import 'package:todo_app_1/shared/provider/auth_provider.dart';
import 'package:todo_app_1/shared/remote/firebase/firestore_helper.dart';

class TaskWidget extends StatelessWidget {
  Task task;
  TaskWidget({super.key, required this.task});
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    print(task.date);
    DateTime taskDate = DateTime.fromMicrosecondsSinceEpoch(task.date ?? 0);
    print(taskDate.toString());
    Authprovider provider = Provider.of<Authprovider>(context);
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.6,
        children: [
          SlidableAction(
            onPressed: (context){
              FirestoreHelper.deleteTask(uid: provider.firebaseUserAuth!.uid, taskId: task.id ?? '');
            },
            icon: Icons.delete,
            label: 'Delete',
            backgroundColor: Colors.red.shade900,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            )
          ),
          SlidableAction(
              onPressed: (context){
                Navigator.pushNamed(context, EditScreen.routName, arguments: task);
              },
              icon: Icons.edit,
              label: 'Edit',
              backgroundColor: Colors.green.shade900,
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
                color: task.isDone == true ? Colors.green : Theme.of(context).primaryColor,
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: task.isDone == true ? Colors.green : Theme.of(context).primaryColor,
                      ),
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
                backgroundColor: task.isDone == true ? Colors.green : Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
              onPressed: (){
                task.isDone =! (task.isDone ?? false);
                FirestoreHelper.editTask(task, provider.firebaseUserAuth!.uid);
              },
              child: task.isDone == true ? const Text('Done') : const Icon(Icons.check)
            ),
          ],
        ),
      ),
    );
  }
}