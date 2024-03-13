 import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_1/layout/home/home_screen.dart';
import 'package:todo_app_1/layout/login/login_screen.dart';
import 'package:todo_app_1/model/user.dart';
import 'package:todo_app_1/shared/constants.dart';
import 'package:todo_app_1/shared/dialog_utils.dart';
import 'package:todo_app_1/shared/firebase_auth_error_code.dart';
import 'package:todo_app_1/shared/provider/auth_provider.dart';
import 'package:todo_app_1/shared/remote/firebase/firestore_helper.dart';
import '../../shared/reusable_components/custom_form_filed.dart';
import '../../style/app_colors.dart';
 import 'package:todo_app_1/model/user.dart' as MyUser;


class RegisterScreen extends StatefulWidget {
  static const String routeName = '_RegisterScreen';
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isObscured = true;
  bool isConfirmObscured = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/image/SIGN IN – 1.jpg',),fit: BoxFit.fill),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text('Create Account', style: TextStyle(color: Colors.white),),
          leading: IconButton(
              onPressed: (){
                Navigator.pop(context, LoginScreen.routeName);
              },
              icon: Icon(Icons.keyboard_backspace, color: Colors.white,)
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomFormField(
                  controller: fullNameController,
                  label: 'Full Name',
                  keybord: TextInputType.name,
                  vaildator: (value){
                    if(value == null || value.isEmpty){
                      return 'This Filed Con\'t Be Empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10,),
                CustomFormField(
                  controller: emailController,
                  label: 'Email',
                  keybord: TextInputType.emailAddress,
                  suffixIcon: const Icon(
                    Icons.email,
                    size: 24,
                    color: AppColors.primaryLightColor,
                  ),
                  vaildator: (value){
                    if(value == null || value.isEmpty){
                      return 'This Filed Con\'t Be Empty';
                    }
                    if(!RegExp(Constants.emailRegex).hasMatch(value)){
                      return 'Enter Valid Email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10,),
                CustomFormField(
                  controller: passwordController,
                  label: 'Password',
                  keybord: TextInputType.visiblePassword,
                  obscureText: isObscured,
                  suffixIcon: IconButton(
                    onPressed: (){
                      setState(() { isObscured = !isObscured; });
                    },
                    icon: Icon(
                      isObscured?Icons.visibility_off:Icons.visibility,
                      size: 24,
                      color: AppColors.primaryLightColor,
                    ),
                  ),
                  vaildator: (value){
                    if(value == null || value.isEmpty){
                      return 'This Filed Con\'t Be Empty';
                    }
                    if (value.length < 8){
                      return 'Password Should Be At Least 8 Char';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                CustomFormField(
                  controller: confirmPasswordController,
                  label: 'Confirm Password',
                  keybord: TextInputType.visiblePassword,
                  obscureText: isConfirmObscured,
                  suffixIcon: IconButton(
                    onPressed: (){
                      setState(() { isConfirmObscured = !isConfirmObscured; });
                    },
                    icon: Icon(
                      isConfirmObscured?Icons.visibility_off:Icons.visibility,
                      size: 24,
                      color: AppColors.primaryLightColor,
                    ),
                  ),
                  vaildator: (value){
                    if (value != passwordController.text){
                      return 'Don\'t Match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: (){
                    createNewUser();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLightColor,
                  ),
                  child: const Text('Register', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  void createNewUser() async {
    Authprovider provider = Provider.of<Authprovider>(context, listen: false);
    if (formKey.currentState?.validate() ?? false){
      DialogUtils.showLoadingDialog(context);
      try{
        UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
        );
        FirestoreHelper.addUser(
            emailController.text,
            fullNameController.text,
            credential.user!.uid
        );
        DialogUtils.hidLoading(context);
        DialogUtils.showMassage(
            context: context,
            message: 'Register Successfully ${credential.user?.uid}',
            positiveText: 'Ok',
            positivePress: (){
              provider.setUsers(credential.user, MyUser.User(
                  id: credential.user!.uid,
                  fullName: fullNameController.text,
                  email: emailController.text
              ));
              DialogUtils.hidLoading(context);
              Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routName, (route) => false);
            });
      }
      on FirebaseAuthException catch (e) {
        DialogUtils.hidLoading(context);
        if (e.code == FirebaseAuthErrorCode.weakPassword) {
          print('The password provided is too weak.');
          DialogUtils.showMassage(
            context: context,
            message: 'The password provided is too weak.',
            positiveText: 'Ok',
            positivePress: (){
              DialogUtils.hidLoading(context);
            });
        } else if (e.code == FirebaseAuthErrorCode.emailAlreadyInUse) {
          print('The account already exists for that email.');
          DialogUtils.hidLoading(context);
          DialogUtils.showMassage(
              context: context,
              message: 'The account already exists for that email.',
              positiveText: 'Ok',
              positivePress: (){
                DialogUtils.hidLoading(context);
              });
        }
      }
      catch(e){
        DialogUtils.hidLoading(context);
        DialogUtils.showMassage(
            context: context,
            message: e.toString(),
            positiveText: 'Ok',
            positivePress: (){
              DialogUtils.hidLoading(context);
            });
      }
    }
  }
}
