import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/screens/add_event.dart';
import 'package:the_endodontist_app/screens/add_event_new.dart';
import 'package:the_endodontist_app/screens/admin/admin_profile.dart';
// import 'package:the_endodontist_app/screens/admin/finder.dart';
// import 'package:the_endodontist_app/screens/admin/doc_chat_screen.dart';
import 'package:the_endodontist_app/screens/admin/information.dart';
import 'package:the_endodontist_app/screens/admin/prod_list.dart';
// import 'package:the_endodontist_app/screens/admin/search_page.dart';
// import 'package:the_endodontist_app/screens/admin/searcher.dart';
import 'package:the_endodontist_app/screens/admin/unread_notifications.dart';
import 'package:the_endodontist_app/screens/event_new.dart';
import 'package:the_endodontist_app/widgets/calander_flutter.dart';
import 'package:the_endodontist_app/widgets/events.dart';
import 'package:the_endodontist_app/widgets/sync_calander.dart';
// import 'package:docapp/screens/clients/query.dart';
// import 'package:the_endodontist_app/widgets/asset_player.dart';
// import 'package:docapp/widgets/chat_app.dart';
// import 'package:docapp/widgets/chat_app.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_endodontist_app/screens/admin/client_list.dart';
// import 'package:the_endodontist_app/screens/admin/doc_list.dart';
// import 'package:the_endodontist_app/screens/admin/permission.dart';
// import 'package:the_endodontist_app/screens/admin/recommended_products.dart';
import 'package:the_endodontist_app/screens/doctor_home_page.dart';
import 'package:the_endodontist_app/screens/welcome_screen.dart';


import '../screens/dashboard.dart';


// ignore: must_be_immutable
class AdminAppDrawer extends StatelessWidget {
  // var globalContext;
  String? role;
  @override
  Widget build(BuildContext context) {
    // globalContext = context;

    return Drawer(
      child: SingleChildScrollView(
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
                    .pushReplacementNamed(DashBoardPage.routeName);
              },
            ),
            // Divider(),
            // ListTile(
            //   leading: Icon(Icons.calendar_today_outlined),
            //   title: Text('Appointments'),
            //   onTap: () {
            //     // Navigator.of(context).pushReplacementNamed('/');
            //     Navigator.of(context)
            //         .pushReplacementNamed(SFCal.routeName);
            //   },
            // ),
            Divider(),
            ListTile(
              leading: Icon(Icons.calendar_today_outlined),
              title: Text('Add Events'),
              onTap: () {
                // Navigator.of(context).pushReplacementNamed('/');
                Navigator.of(context)
                    .pushReplacementNamed(AddEventNew.routeName);
              },
            ),
            // Divider(),
            // ListTile(
            //   leading: Icon(Icons.calendar_today_outlined),
            //   title: Text('Events Dash'),
            //   onTap: () {
            //     // Navigator.of(context).pushReplacementNamed('/');
            //     Navigator.of(context)
            //         .pushReplacementNamed(EventPage.routeName);
            //   },
            // ),
            // Divider(),
            // ListTile(
            //   leading: Icon(Icons.calendar_view_month_sharp),
            //   title: Text('Table Calendar Appointments'),
            //   onTap: () {
            //     // Navigator.of(context).pushReplacementNamed('/');
            //     Navigator.of(context)
            //         .pushReplacementNamed(TabCal.routeName);
            //   },
            // ),
            Divider(),
            ListTile(
              leading: Icon(Icons.ad_units_sharp),
              title: Text('Recommend Products'),
              onTap: () {
                // Navigator.of(context).pushReplacementNamed('/');
                Navigator.of(context)
                    .pushReplacementNamed(ProdList.routeName);
              },
            ),
             Divider(),
            
            ListTile(
              leading: Icon(Icons.message_rounded),
              title: Text('Chats'),
              onTap: () {
                // Navigator.of(context).pushReplacementNamed('/');
                Navigator.of(context)
                    .pushReplacementNamed(InfoPage.routeName);
                   
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Unread Notifications'),
              onTap: () {
                // Navigator.of(context).pushReplacementNamed('/');
                Navigator.of(context)
                    .pushReplacementNamed(Unreads.routeName);
              },
            ),
            Divider(),
            // ListTile(
            //   leading: Icon(Icons.video_camera_front),
            //   title: Text('Video Player'),
            //   onTap: () {
            //     // Navigator.of(context).pushReplacementNamed('/');
            //     Navigator.of(context)
            //         .pushReplacementNamed(AssetPlayer.routeName);
            //   },
            // ),
            // Divider(),
            ListTile(
              leading: Icon(Icons.person_add_alt_1_sharp),
              title: Text('My Profile Details'),
              onTap: () {
                Navigator.of(context).pushNamed(AdminProfile.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.people_alt_sharp),
              title: Text('Client List'),
              onTap: () {
                Navigator.of(context).pushNamed(ClientList.routeName);
              },
            ),
             Divider(),
            // ListTile(
            //   leading: Icon(Icons.people_alt_sharp),
            //   title: Text('Doctor Profiles'),
            //   onTap: () {
            //     Navigator.of(context).pushNamed(DocList.routeName);
            //   },
            // ),
            // Divider(),
            // ListTile(
            //   leading: Icon(Icons.feedback_sharp),
            //   title: Text('Permission Settings'),
            //   onTap: () {
            //     Navigator.of(context)
            //         .pushReplacementNamed(Permissions.routeName);
            //   },
            // ),
            // Divider(),
            // ListTile(
            //   leading: Icon(Icons.admin_panel_settings_sharp),
            //   title: Text('Ad Postings'),
            //   onTap: () {
            //     _checkRole(context);
            //   },
            // ),
            // Divider(),
            // ListTile(
            //   leading: Icon(Icons.chat_rounded),
            //   title: Text('Client Queries'),
            //   onTap: () {
            //      Navigator.of(context)
            //        .pushReplacementNamed(Searcher.routeName);
            //   },
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
      ),
    );
  }

  _checkRole(BuildContext context) async {
    final currUser = FirebaseAuth.instance.currentUser;
    if (currUser != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currUser.uid)
          .get()
          .then((snapshot) {
        role = snapshot.data()!['Role'];
      });
      if (role == 'Admin') {
        Navigator.of(context).pushReplacementNamed(DashBoardPage.routeName);
      } else if(role == 'Doctor') {
        Navigator.of(context).pushReplacementNamed(DoctorHome.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeName);
      }
    }
  }
}
