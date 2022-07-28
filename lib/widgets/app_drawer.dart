import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:the_endodontist_app/home_page.dart';
// import 'package:the_endodontist_app/screens/admin/doc_chat_screen.dart';
// import 'package:the_endodontist_app/screens/admin/tosearch.dart';
// import 'package:the_endodontist_app/screens/admin/information.dart';
import 'package:the_endodontist_app/screens/clients/patient_doc.dart';
import 'package:the_endodontist_app/screens/clients/profiler.dart';
import 'package:the_endodontist_app/screens/clients/testimonial.dart';

// import 'package:docapp/widgets/client_chat.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:the_endodontist_app/screens/clients/client_profile.dart';
import 'package:the_endodontist_app/screens/clients/reference.dart';

import 'package:the_endodontist_app/screens/dashboard.dart';
import 'package:the_endodontist_app/screens/doctor_home_page.dart';
import 'package:the_endodontist_app/screens/welcome_screen.dart';

// ignore: must_be_immutable
class AppDrawer extends StatefulWidget {
  // var globalContext;
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String? role;
  String? patientName;
  String? docName;
  String? cId;
  int? mCount;
  int? counter;

  Future getUserInfo() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        setState(() {
          patientName = snapshot['User Name'];
          // print(patientName);
        });
      }
    });
    return documentReference;
  }

  Future getDocInfo() async {
    String uid = 'tgUV8diPrJSPMEfahcC9V4zPYEv2';
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        setState(() {
          docName = snapshot['User Name'];
          // print(docName);
        });
      }
    });
    return documentReference;
  }

  String chatId(String? user1, String? user2) {
    // print('1st User: $user1');
    // print('2nd User: $user2');

    if (user1 != null && user2 != null) {
      if (user1[0].toLowerCase().codeUnits[0] >
          user2.toLowerCase().codeUnits[0]) {
        return '$user1->$user2';
      } else {
        return '$user2->$user1';
      }
    } else {
      return 'Enter User Names';
    }
  }

  int? displayCount(docName, cId) {
    int? msgCount;
    //  cId = chatId(dName, patName);
    var mcounter = FirebaseFirestore.instance
        .collection('Chat Room')
        .doc(cId)
        .collection('Chats')
        .where('sentBy', isEqualTo: docName)
        .where('Message Read', isEqualTo: false)
        .get()
        .then((docSnap) {
      setState(() {
        msgCount = docSnap.docs.length;
        mCount = msgCount!;
        // print(mCount);
      });
      // print(mCount);
    });
    return mCount;
  }

 
  void _markAsRead(cId, docName) {
    FirebaseFirestore.instance
        .collection('Chat Room')
        .doc(cId)
        .collection('Chats')
        .where('sentBy', isEqualTo: docName)
        .where('Message Read', isEqualTo: false)
        .get()
        .then((docSnap) {
      if (docSnap.docs.length > 0) {
        for (DocumentSnapshot doc in docSnap.docs) {
          doc.reference.update({'Message Read': true});
        }
      }
    });
  }

  @override
  void initState() {
    getUserInfo();
    getDocInfo();

    // print(docName);
    // print(patientName);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // globalContext = context;
    cId = chatId(docName, patientName);
    counter = displayCount(docName, cId);
    //  print(cId);
    //  print(counter);
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home Page'),
            onTap: () {
              // Navigator.of(context).pushReplacementNamed('/');
              Navigator.of(context)
                  .pushReplacementNamed(WelcomeScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person_add_alt_1_sharp),
            title: Text('My Profile'),
            onTap: () {
              Navigator.of(context).pushNamed(Profiler.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.people_alt_sharp),
            title: Text('Refer Your Friends'),
            onTap: () {
              Navigator.of(context).pushNamed(ReferencePage.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.feedback_sharp),
            title: Text('Share Your Feddback'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(Testimonial.routeName);
            },
          ),
          /// THE BELOW ITEM IS NOT REQUIRED IN THE APPBAR OF THE PATIENT.
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.admin_panel_settings_sharp),
          //   title: Text('For Admin Only'),
          //   onTap: () {
          //     _checkRole(context);
          //   },
          // ),
          /// THE BELOW CODE TO BE USED TO DISPLAY THE CHAT PAGE AND THE NOTIFICATION COUNTER.
          // Divider(),
          
          // ListTile(
          //   leading: Icon(Icons.chat_rounded),
          //   title: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       Text('Ask Your Queries...'),
          //       counter != 0 ? Container(
          //         width: 60,
          //         child: CircleAvatar(
          //           radius: 15,
          //           backgroundColor: Colors.black,
          //           child: Text(
          //             '$counter',
          //             style: TextStyle(
          //               fontSize: 23,
          //               fontWeight: FontWeight.bold,
          //               color: Colors.green,
          //             ),
          //           ),
          //         ),
          //       )
          //       : Container(
          //         width:60,
          //       ),
          //     ],
          //   ),
          //   onTap: () {
          //     _markAsRead(cId, docName);
          //     Navigator.of(context)
          //         .pushReplacementNamed(PatientToDoc.routeName);
          //   },
          // ),
          /// THE BELOW ITEM TOO COULD BE REMOVED FROM THE APPBAR. NOT A MANDATORY ITEM.
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.medical_services_sharp),
          //   title: Text('Take Me to Dr. George'),
          //   onTap: () {},
          // ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');

              FirebaseAuth.instance.signOut();
              // UserManagement().signOut();
            },
          ),
        ],
      ),
    );
  }

  _checkRole(BuildContext context) async {
    final currUser = FirebaseAuth.instance.currentUser;
    if (currUser != null) {
      await FirebaseFirestore.instance
          .collection('Client Profile')
          .doc(currUser.uid)
          .get()
          .then((snapshot) {
        role = snapshot.data()!['Role'];
      });
      if (role == 'Admin') {
        Navigator.of(context).pushReplacementNamed(DashBoardPage.routeName);
      } else if (role == 'Doctor') {
        Navigator.of(context).pushReplacementNamed(DoctorHome.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeName);
      }
    }
  }
}
