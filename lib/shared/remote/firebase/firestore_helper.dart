import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app_1/model/task.dart';
import 'package:todo_app_1/model/user.dart';

class FirestoreHelper{
  static CollectionReference <User> getUserCollection(){
    var reference = FirebaseFirestore.instance.collection("User").
    withConverter(
        fromFirestore: (snapshot, options){
          Map<String, dynamic>? data = snapshot.data();
          return User.fromFirestore(data ?? {});
        },
        toFirestore: (user , options){
          return user.toFirestore();
        }
    );
    return reference;
  }

  static Future<void> addUser(String email , String fullName, String userID) async {
    var documnent = getUserCollection().doc(userID);
    await documnent.set(
      User(
          id: userID,
          fullName: fullName,
          email: email
      )
    );
  }

  static Future<User?> getUser(String userId) async {
    var document = getUserCollection().doc(userId);
    var snapshot = await document.get();
    User? user = snapshot.data();
    return user;
  }

  static CollectionReference<Task> getTaskCollection(String userID){
    var tasksCollection = getUserCollection().doc(userID).collection('tasks').
    withConverter(
      fromFirestore: (snapshot, options) => Task.fromFirestore(snapshot.data() ?? {}),
      toFirestore: (task, options) => task.toFirestore()
    );
    return tasksCollection;
  }

  static Future<void> addNewTask(Task task, String userID) async {
    var reference = getTaskCollection(userID);
    var tasksDocument = reference.doc();
    task.id = tasksDocument.id;
    await tasksDocument.set(task);
  }

  static Future<List<Task>> getAllTasks(String uid)async{
    var taskQuery = await getTaskCollection(uid).get();
    List<Task> tasksList = taskQuery.docs.map((snapshot) => snapshot.data()).toList();
    return tasksList;
  }

  static Future<void> deleteTask({required String uid, required String taskId}) async {
    await getTaskCollection(uid).doc(taskId).delete();
  }

  static Stream<List<Task>> listenToTasks(String uid, int date) async*{
    Stream<QuerySnapshot<Task>> taskQueryStream = getTaskCollection(uid).where('date', isEqualTo: date).snapshots();
    Stream<List<Task>> tasksSteam = taskQueryStream.map(
      (querySnapShot) => querySnapShot.docs.map((doucument) => doucument.data()).toList()
    );
    yield* tasksSteam;
  }
}