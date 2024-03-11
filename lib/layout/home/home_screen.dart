import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_1/layout/home/provider/home_provider.dart';
import 'package:todo_app_1/layout/home/taps/list_taps.dart';
import 'package:todo_app_1/layout/home/taps/settings_taps.dart';
import 'package:todo_app_1/layout/home/widget/add_task_sheet.dart';
import 'package:todo_app_1/layout/login/login_screen.dart';
import 'package:todo_app_1/model/task.dart';
import 'package:todo_app_1/shared/dialog_utils.dart';
import 'package:todo_app_1/shared/provider/auth_provider.dart';
import 'package:todo_app_1/shared/remote/firebase/firestore_helper.dart';
import 'package:todo_app_1/style/app_colors.dart';

class HomeScreen extends StatefulWidget {
  static const String routName = 'HomeScreen';
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> taps = [const ListTaps(), const SettingTaps()];
  TextEditingController titleController = TextEditingController();
  TextEditingController decController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSheetOpened = false;
  @override
  Widget build(BuildContext context) {
    Authprovider provider = Provider.of<Authprovider>(context);
    HomeProvider homeProvider = Provider.of<HomeProvider>(context);
    bool isKeyboardOpened = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
        leading: IconButton(
            onPressed: () async{
              await provider.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
            icon: const Icon(Icons.exit_to_app, size: 20, color: Colors.white,)
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        elevation: 10,
        shape: const CircularNotchedRectangle(),
        notchMargin: 9,
        child: BottomNavigationBar(
          onTap: (index) {
            homeProvider.changeTaps(index);
          },
          backgroundColor: Colors.white,
          currentIndex: homeProvider.currentNavIndex,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icon/Icon awesome-list.svg',
                colorFilter: const ColorFilter.mode(AppColors.unSelectedIconColor, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset('assets/icon/Icon awesome-list.svg'),
              label: ''
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icon/Icon feather-settings.svg'),
              activeIcon: SvgPicture.asset(
                'assets/icon/Icon feather-settings.svg',
                colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
              ),
              label: ''
            ),
          ],
        ),
      ),
      floatingActionButton: isKeyboardOpened ? null : FloatingActionButton(
        onPressed: () async {
          if (!isSheetOpened){
            showAddTaskBottomSheet();
            isSheetOpened = true;
          }
          else{
            if((formKey.currentState?.validate()??false) && homeProvider.selectedDate != null){
              await FirestoreHelper.addNewTask(
                Task(
                  title: titleController.text,
                  description: decController.text,
                  date: homeProvider.selectedDate!.millisecondsSinceEpoch
                ),
                provider.firebaseUserAuth!.uid,
              );
              // ignore: use_build_context_synchronously
              DialogUtils.showMassage(
                context: context,
                message: 'Tasks Added Successfully',
                positiveText: 'Ok',
                positivePress: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              );
              isSheetOpened = false;
            }
          }
          setState(() {});
        },
        shape: const StadiumBorder(
          side: BorderSide(
            width: 4,
            color: Colors.white
          )
        ),
        child: isSheetOpened?
        const Icon(Icons.check, color: Colors.white, size: 18,) :
        const Icon(Icons.add, color: Colors.white, size: 18,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Scaffold(
        key: scaffoldKey,
        body: taps[homeProvider.currentNavIndex],
      ),
    );
  }

  void showAddTaskBottomSheet() {
    scaffoldKey.currentState?.showBottomSheet(
      (context) => AddTaskSheet(
        titleController: titleController,
        descController: decController,
        formKey: formKey,
        onCancel: (){
          isSheetOpened = false;
          setState(() {});
        },
      ),
      enableDrag: false,
    );
  }
}
