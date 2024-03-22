import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_1/layout/home/widget/taxt_filed.dart';
import 'package:todo_app_1/model/task.dart';
import 'package:todo_app_1/shared/provider/auth_provider.dart';
import 'package:todo_app_1/shared/remote/firebase/firestore_helper.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);
  static const String routName = 'EditScreen';

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  bool firest = true;
  late DateTime selectedDate;
  @override
  Widget build(BuildContext context) {
    Authprovider provider = Provider.of<Authprovider>(context);
    Task task = ModalRoute.of(context)?.settings.arguments as Task;
    if(firest){
      titleController.text = task.title ?? '';
      detailsController.text = task.description ?? '';
      selectedDate = DateTime.fromMillisecondsSinceEpoch(task.date!);
      firest = false;
    }
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
          ),
          SafeArea(
            child: ListView(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.keyboard_backspace, color: Colors.white,),
                    ),
                    const Text(
                      'To Do List',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 25,),
                      const Text(
                        'Edit Task',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 95.5,),
                      TextFiledTask(
                        hint: 'This Is Title',
                        controller: titleController,
                      ),
                      const SizedBox(height: 28,),
                      TextFiledTask(
                        hint: 'Task details',
                        controller: detailsController,
                      ),
                      const SizedBox(height: 28,),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: InkWell(
                          onTap: () async {
                            DateTime? _selectedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                              initialDate: selectedDate,
                            );
                            selectedDate = _selectedDate ?? selectedDate;
                            setState(() {});
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              //  TODO UPDATE THIS IS THE TEXT SELECT DATE
                              '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}',
                              style: Theme.of(context).textTheme.labelMedium?.
                              copyWith(
                                fontSize: 18, fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 240,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 90),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                          onPressed: (){
                            Task newTask = Task(
                              title: titleController.text.trim(),
                              description: detailsController.text.trim(),
                              date: selectedDate.millisecondsSinceEpoch,
                              isDone: task.isDone,
                              id: task.id,
                            );
                            FirestoreHelper.editTask(newTask, provider.firebaseUserAuth!.uid);
                          },
                          child: const Text(
                            'Save Change',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
