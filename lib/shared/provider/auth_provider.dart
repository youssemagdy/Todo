import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_app_1/model/user.dart' as MyUser;
import 'package:todo_app_1/shared/remote/firebase/firestore_helper.dart';

class Authprovider extends ChangeNotifier{
  User? firebaseUserAuth;
  MyUser.User? databaseUser;
  void setUsers(User? newFirebaseUserAuth, MyUser.User? newDatabaseUser){
    firebaseUserAuth = newFirebaseUserAuth;
    databaseUser = newDatabaseUser;
  }
  bool isFirebaseUserLoginIN(){
    if (FirebaseAuth.instance.currentUser == null) return false;
    firebaseUserAuth = FirebaseAuth.instance.currentUser;
    return true;
  }
  Future<void> retrieveDatabaseUserData() async {
    try{
      databaseUser = await FirestoreHelper.getUser(firebaseUserAuth!.uid);
    }
    catch(e) {
      print(e);
    }
  }
  Future<void> signOut() async {
    firebaseUserAuth = null;
    databaseUser = null;
    return await FirebaseAuth.instance.signOut();
  }
}