import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_1/layout/home/home_screen.dart';
import 'package:todo_app_1/layout/register/register.dart';
import 'package:todo_app_1/shared/constants.dart';
import 'package:todo_app_1/shared/dialog_utils.dart';
import 'package:todo_app_1/shared/firebase_auth_error_code.dart';
import 'package:todo_app_1/shared/provider/auth_provider.dart';
import 'package:todo_app_1/shared/remote/firebase/firestore_helper.dart';
import '../../shared/reusable_components/custom_form_filed.dart';
import '../../style/app_colors.dart';
import 'package:todo_app_1/model/user.dart' as MyUser;

class LoginScreen extends StatefulWidget {
  static const String routeName = 'LoginScreen';
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscured = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
          title: const Text('Login', style: TextStyle(color: Colors.white),),
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
                ElevatedButton(
                    onPressed: (){
                      login();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLightColor,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                ),
                const SizedBox(height: 20,),
                TextButton(
                    onPressed: (){
                      Navigator.pushNamed(context, RegisterScreen.routeName);
                    }, 
                    child: const Text(
                      'Don\'t Have An Account? SignUp',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void login()async{
    Authprovider provider = Provider.of<Authprovider>(context, listen: false);
    if (formKey.currentState?.validate()?? false){
      DialogUtils.showLoadingDialog(context);
      try{
        UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
        );
        DialogUtils.hidLoading(context);
        print('User Id: ${credential.user?.uid}');
        MyUser.User? user = await FirestoreHelper.getUser(credential.user!.uid);
        provider.setUsers(credential.user, user);
        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routName, (route) => false);
      }on FirebaseAuthException catch(e){
        DialogUtils.hidLoading(context);
        if(e.code == FirebaseAuthErrorCode.userNotFound){
          print('User Not Found');
          DialogUtils.showMassage(
            context: context,
            message: 'User Not Fund',
            positiveText: 'Ok',
            positivePress: (){
              Navigator.pop(context);
            },
          );
        }
        else if (e.code == FirebaseAuthErrorCode.wrongPassword){
          print('Wrong Password');
          DialogUtils.showMassage(
            context: context,
            message: 'Wrong Password',
            positiveText: 'Ok',
            positivePress: (){
              Navigator.pop(context);
            },
          );
        }
      }
      catch(e){
        print(e.toString());
      }
    }
  }
}