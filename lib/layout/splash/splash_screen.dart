import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_1/layout/home/home_screen.dart';
import 'package:todo_app_1/layout/login/login_screen.dart';
import 'package:todo_app_1/shared/provider/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'SplashScreen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), (){
      checkAutoLogin();
    });
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/image/splash.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
      ),
    );
  }
  checkAutoLogin() async {
    Authprovider provider = Provider.of<Authprovider>(context, listen: false);
    if (provider.isFirebaseUserLoginIN()){
      await provider.retrieveDatabaseUserData();
      Navigator.pushReplacementNamed(context, HomeScreen.routName);
    }
    else{
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }
}
