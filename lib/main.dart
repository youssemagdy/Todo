import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_1/layout/home/home_screen.dart';
import 'package:todo_app_1/layout/home/provider/home_provider.dart';
import 'package:todo_app_1/layout/register/register.dart';
import 'package:todo_app_1/layout/splash/splash_screen.dart';
import 'package:todo_app_1/shared/provider/auth_provider.dart';
import 'package:todo_app_1/style/theme.dart';
import 'firebase_options.dart';
import 'layout/login/login_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Authprovider(),)
      ],
      child: const MyApp()));
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      title: 'TODO App',
      routes: {
        LoginScreen.routeName:(_) => LoginScreen(),
        RegisterScreen.routeName:(_) => RegisterScreen(),
        HomeScreen.routName:(_) => ChangeNotifierProvider(
          create: (_) => HomeProvider(),
          child: HomeScreen()
        ),
        SplashScreen.routeName:(_) => const SplashScreen(),
      },
      initialRoute: SplashScreen.routeName,
    );
  }
}