
// import 'package:docapp/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


import './screens/dentista_auth_screen.dart';
import 'screens/dashboard.dart';
// import 'screens/doctor_home_page.dart';
import 'screens/welcome_screen.dart';



class UserManagement {
  String? role = 'Client';
  // Stream<dynamic>Function() _user = (() async* {FirebaseAuth.instance.authStateChanges();});
  Widget handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      // ignore: missing_return
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          // return WelcomeScreen();
          // The below code is used to display the screen based on user type. Has to make few more modifications to overcome the delay.
          _checkRole(context);

        }
        return DentistaAuthScreen();
      },
    );
  }

  
 Future _checkRole(BuildContext context) async {
    final currUser =  FirebaseAuth.instance.currentUser;
    if (currUser != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currUser.uid)
          .get()
          .then((snapshot) async {
        role = await snapshot.data()!['Role'];
      });
      if (role != 'Admin') {
        Navigator.of(context).pushNamed(WelcomeScreen.routeName);
      } 
      // In case we have multiple Doctors using the app...
      // else if(role == 'Doctor') {
      //   Navigator.of(context).pushReplacementNamed(DoctorHome.routeName);
      // } 
      else {
        Navigator.of(context).pushNamed(DashBoardPage.routeName);
      }
    }
  }

  
  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
