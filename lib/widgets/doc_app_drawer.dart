
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_endodontist_app/screens/doctor_home_page.dart';
import 'package:the_endodontist_app/screens/doctors/doc_profile.dart';
import 'package:the_endodontist_app/screens/doctors/patient_list.dart';


// ignore: must_be_immutable
class DocAppDrawer extends StatelessWidget {
  String? role;
  @override
  Widget build(BuildContext context) {
    // globalContext = context;

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Help Yourself...'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home Page'),
            onTap: () {
              // Navigator.of(context).pushReplacementNamed('/');
              Navigator.of(context)
                  .pushReplacementNamed(DoctorHome.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person_add_alt_1_sharp),
            title: Text('Doctor Profile Details'),
            onTap: () {
              Navigator.of(context).pushNamed(DocProfile.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.people_alt_sharp),
            title: Text('Patient List'),
            onTap: () {
              Navigator.of(context).pushNamed(PatientList.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.chat_rounded),
            title: Text('Check Patient Queries'),
            onTap: () {},
          ),
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

  
}