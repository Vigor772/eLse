import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future updateUserInfowithoutPassword(address, birthdate, email, age) async {
  String useruid = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance.collection('users').doc(useruid).set({
    'address': address,
    'date_of_birth': birthdate,
    'email': email,
    'age': age,
  }, SetOptions(merge: true));
}

Future updateUserInfoWithPassword(
    address, birthdate, email, age, newpassword) async {
  String useruid = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance.collection('users').doc(useruid).set({
    'address': address,
    'date_of_birth': birthdate,
    'email': email,
    'age': age,
    'password': newpassword,
  }, SetOptions(merge: true));
}
