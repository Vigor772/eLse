import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_revamp/cloud_services/update_userdata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class Update extends StatefulWidget {
  var name;
  Update(this.name);

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  late String password = '';
  var user = FirebaseAuth.instance.currentUser;
  TextEditingController birthdateController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController oldpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController rnewpasswordController = TextEditingController();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  late String fileName;
  late File image;

  getUserInfotoEdit() async {
    String useruid = FirebaseAuth.instance.currentUser!.uid;
    var getUserInfo = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: useruid)
        .get();
    setState(() {
      for (var snapshots in getUserInfo.docs) {
        Map<String, dynamic> data = snapshots.data();
        birthdateController.text = data['date_of_birth'];
        addressController.text = data['address'];
        emailController.text = data['email'];
        password = data['password'];
        ageController.text = data['age'] ?? 'Not set';
      }
    });
    return password;
  }

  Future<void> updateProfilePicture(String source) async {
    XFile pickedImage;
    try {
      pickedImage = (await ImagePicker().pickImage(
          source: source == 'camera' ? ImageSource.camera : ImageSource.gallery,
          maxWidth: 150))!;
    } catch (error) {}
  }

  @override
  void initState() {
    getUserInfotoEdit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(250, 246, 236, 236),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(250, 205, 95, 95),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Image.asset('assets/images/icons8-left-96 1.png')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 240,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(250, 205, 95, 95),
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.elliptical(
                              MediaQuery.of(context).size.width, 100.0)),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 160),
                  child: Center(
                    child: Text(
                      widget.name,
                      style: GoogleFonts.fanwoodText(
                          color: const Color.fromARGB(250, 52, 73, 94),
                          fontSize: 30),
                    ),
                  ),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              margin: const EdgeInsets.only(right: 10, left: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Birthdate *', style: GoogleFonts.fanwoodText()),
                        TextFormField(
                          controller: birthdateController,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              //hintText: 'Birthdate',
                              hintStyle: GoogleFonts.fanwoodText()),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Age *', style: GoogleFonts.fanwoodText()),
                        TextFormField(
                          controller: ageController,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              //hintText: 'Age',
                              hintStyle: GoogleFonts.fanwoodText()),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10, left: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Home Address *', style: GoogleFonts.fanwoodText()),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        //hintText: 'Home Address',
                        hintStyle: GoogleFonts.fanwoodText()),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10, left: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email Address *', style: GoogleFonts.fanwoodText()),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        //hintText: 'Email Address',
                        hintStyle: GoogleFonts.fanwoodText()),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10, left: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('New Password', style: GoogleFonts.fanwoodText()),
                  TextFormField(
                    obscureText: true,
                    controller: newpasswordController,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        hintText: '******',
                        hintStyle: GoogleFonts.fanwoodText()),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10, left: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Retype New Password', style: GoogleFonts.fanwoodText()),
                  TextFormField(
                    obscureText: true,
                    controller: rnewpasswordController,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        hintText: '******',
                        hintStyle: GoogleFonts.fanwoodText()),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10, left: 10, top: 10),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(250, 205, 95, 95),
                      minimumSize: const Size(150, 40),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: GoogleFonts.fanwoodText(
                          color: Colors.white, fontSize: 25),
                    ),
                    onPressed: () async {
                      final birthdate = birthdateController.text.trim();
                      final age = ageController.text.trim();
                      final address = addressController.text.trim();
                      final email = emailController.text.trim();
                      final newpass = newpasswordController.text.trim();
                      final rnewpass = rnewpasswordController.text.trim();
                      print('password: $password');
                      //Get.offNamedUntil('/home', (route) => true);
                      if (birthdate.isEmpty ||
                          age.isEmpty ||
                          address.isEmpty ||
                          email.isEmpty &&
                              (newpass.isEmpty || rnewpass.isEmpty)) {
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Failed to Update!",
                                    style: GoogleFonts.fanwoodText()),
                                content: Text('Required Fields not filled out',
                                    style: GoogleFonts.fanwoodText()),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('CLOSE',
                                          style: GoogleFonts.fanwoodText()))
                                ],
                              );
                            });
                      } else if (newpass.isNotEmpty || rnewpass.isNotEmpty) {
                        if (newpass != rnewpass) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Error",
                                      style: GoogleFonts.fanwoodText(
                                          color: Colors.red)),
                                  content: Text('Both Passwords must match',
                                      style: GoogleFonts.fanwoodText()),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('CLOSE',
                                            style: GoogleFonts.fanwoodText()))
                                  ],
                                );
                              });
                        } else if (newpass.length <= 5 &&
                            rnewpass.length <= 5) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Password too weak",
                                      style: GoogleFonts.fanwoodText(
                                          color: Colors.red)),
                                  content: Text(
                                      'Must be atleast 6 or more characters',
                                      style: GoogleFonts.fanwoodText()),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('CLOSE',
                                            style: GoogleFonts.fanwoodText()))
                                  ],
                                );
                              });
                        } else {
                          updateUserInfoWithPassword(
                              address, birthdate, email, age, newpass);
                          user!.updatePassword(newpass).then((_) {
                            print('password changed');
                          }).catchError((onError) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Error",
                                        style: GoogleFonts.fanwoodText(
                                            color: Colors.red)),
                                    content: Text('$onError',
                                        style: GoogleFonts.fanwoodText()),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('CLOSE',
                                              style: GoogleFonts.fanwoodText()))
                                    ],
                                  );
                                });
                          });
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Profile Updated Successfully",
                                      style: GoogleFonts.fanwoodText(
                                          color: Colors.red)),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('CLOSE',
                                            style: GoogleFonts.fanwoodText()))
                                  ],
                                );
                              });
                        }
                      } else {
                        updateUserInfowithoutPassword(
                            address, birthdate, email, age);
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Profile Updated Successfully",
                                    style: GoogleFonts.fanwoodText(
                                        color: Colors.red)),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('CLOSE',
                                          style: GoogleFonts.fanwoodText()))
                                ],
                              );
                            });
                      }
                    },
                  ),
                  //const Padding(padding: EdgeInsets.only(left: 50)),
                  //replaced Padding with expanded to only occupy the available space
                  // in between Save and Cancel button
                  Expanded(child: Container()),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(250, 52, 73, 94),
                      minimumSize: Size(150, 40),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.fanwoodText(
                          color: Colors.white, fontSize: 25),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
