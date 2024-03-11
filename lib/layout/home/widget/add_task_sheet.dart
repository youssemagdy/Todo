import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_1/layout/home/provider/home_provider.dart';
import 'package:todo_app_1/shared/reusable_components/custom_form_filed.dart';

class AddTaskSheet extends StatefulWidget {
  void Function() onCancel;
  TextEditingController titleController;
  TextEditingController descController;
  GlobalKey<FormState> formKey;
  AddTaskSheet({
    required this.onCancel,
    required this.titleController,
    required this.descController,
    required this.formKey,
  });
  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}
class _AddTaskSheetState extends State<AddTaskSheet> {
  // const AddTaskSheet({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    HomeProvider provider = Provider.of<HomeProvider>(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          key: widget.formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Add New Task', style: Theme.of(context).textTheme.labelMedium,),
                const SizedBox(height: 20,),
                CustomFormField(
                  label: 'Enter Task Title',
                  keybord: TextInputType.text,
                  controller: widget.titleController,
                  vaildator: (value){
                    if (value == null || value.isEmpty){
                      return 'Title Can\'t Be Empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10,),
                CustomFormField(
                  label: 'Enter Task Description',
                  keybord: TextInputType.multiline,
                  controller: widget.descController,
                  maxLines: 2,
                  vaildator: (value){
                    if (value == null || value.isEmpty){
                      return 'Description Can\'t Be Empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10,),
                InkWell(
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      initialDate: DateTime.now(),
                    );
                    provider.selectNewDate(selectedDate);
                    setState(() {});
                  },
                  child: Text(
                    provider.selectedDate == null? 'Select Date' :
                    '${provider.selectedDate?.day} / ${provider.selectedDate?.month} / ${provider.selectedDate?.year}',
                    style: Theme.of(context).textTheme.labelMedium?.
                    copyWith(
                        fontSize: 18, fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                      widget.onCancel();
                    },
                    child: const Text('Cancel')
                ),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
