import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_adaptive/Module1_User_Management/Models/User.dart';

class TeacherDashboardService {
  static final TeacherDashboardService _instance =
      TeacherDashboardService._internal();
  TeacherDashboardService._internal();
  factory TeacherDashboardService() {
    return _instance;
  }
  Future<List<User>> getAllStudents() async {
    List<User> users = [];
    try {
      QuerySnapshot<User> querySnapshot = await FirebaseFirestore.instance
          .collection("User")
          .where("type", isEqualTo: "student")
          .withConverter(
              fromFirestore: (snapshot, _) =>
                  User.fromJson(snapshot.data()!, snapshot.id),
              toFirestore: (model, _) => model.toJson())
          .get();
      for (DocumentSnapshot<User> documentSnapshot in querySnapshot.docs) {
        users.add(documentSnapshot.data()!);
      }
    } catch (e) {
      print("Error getting student users: $e");
      rethrow;
    }
    return users;
  }
}
