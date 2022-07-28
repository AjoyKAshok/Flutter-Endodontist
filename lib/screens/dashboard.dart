import 'package:the_endodontist_app/screens/admin/client_list.dart';
import 'package:the_endodontist_app/screens/admin/prod_list.dart';
// import 'package:the_endodontist_app/screens/admin/recommended_products.dart';
import 'package:the_endodontist_app/screens/admin/review_list_screen.dart';
import 'package:the_endodontist_app/screens/admin/unread_notifications.dart';
import 'package:the_endodontist_app/screens/clients/reference.dart';
import 'package:the_endodontist_app/screens/clients/testimonial.dart';
// import 'package:the_endodontist_app/screens/welcome_screen.dart';
import 'package:the_endodontist_app/widgets/admin_app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../database/database.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class DashBoardPage extends StatefulWidget {
  static const routeName = '/adminDashboard';
  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  var clients;
  var products;
  var reviews;
  String? currentUserName;
  String? cId;
  int? msgCount;
  int? mCount;
  String? unreadUsers;
  List allClients = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? docId = 'tgUV8diPrJSPMEfahcC9V4zPYEv2';
  Future getUserInfo() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        setState(() {
          currentUserName = snapshot['User Name'];
        });
      }
    });
    return documentReference;
  }

  getClientInfo() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('Users').get();
    setState(() {
      allClients = qn.docs;
    });

    return qn.docs;
  }

  String chatId(String? user1, String? user2) {
    _auth.currentUser!.uid == docId ? user1 = 'Dr. Ajit' : user2 = 'Dr. Ajit';

    // print(user2);

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

  int? msgCnt(String? currentUserName, String? clientName) {
    cId = chatId(currentUserName, clientName);
    var counter = FirebaseFirestore.instance
        .collection('Chat Room')
        .doc(cId)
        .collection('Chats')
        .where('sentBy', isEqualTo: clientName)
        .where('Message Read', isEqualTo: false)
        .get()
        .then((docSnap) {
      if (mounted) {
        setState(() {
          msgCount = docSnap.docs.length;
          mCount = msgCount!;
        });
      }
    });
    return mCount;
  }

  @override
  void initState() {
    getClientInfo();
    getUserInfo();
    ClientsOfMonth().getClientInfo().then((QuerySnapshot qs) {
      if (qs.docs.isNotEmpty) {
        clients = qs.docs.length.toString();
        setState(() {});
      }
    });
    RecProds().getProdCount().then((QuerySnapshot qsnap) {
      if (qsnap.docs.isNotEmpty) {
        setState(() {
          products = qsnap.docs.length.toString();
        });
      }
    });
    RevCount().getRevCount().then((QuerySnapshot snap) {
      if (snap.docs.isNotEmpty) {
        setState(() {
          reviews = snap.docs.length.toString();
        });
      }
    });
    UnreadCount().getUnreadCount().then((QuerySnapshot snap) {
      if (snap.docs.isNotEmpty) {
        setState(() {
          unreadUsers = snap.docs.length.toString();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? totalClients;
    // String clients = _getClientInfo().toString();

    return Scaffold(
        appBar: AppBar(
          title: Text('Dentista Admin Dashboard'),
          centerTitle: true,
        ),
        drawer: AdminAppDrawer(),
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .where('Role', isNotEqualTo: 'Admin')
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                totalClients =
                    (snapshot.data! as QuerySnapshot).docs.length.toString();
              }
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .3,
                      padding:
                          EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                      child: GridView.count(
                        crossAxisCount: 2,
                        padding: EdgeInsets.all(3.0),
                        children: <Widget>[
                          // if (totalClients.isEmpty ?? true) Text('Zero Users'),
                          makeDashboardItem("Total Clients",
                              totalClients ?? '0', Icons.people_sharp),
                          // makeDashboardItem(
                          //     "Profile", totalClients ?? '0', Icons.details_sharp),
                          makeDashboardItem("New Users for the Month",
                              clients ?? '0', Icons.book),
                          // makeDashboardItem(
                          //     "References in the Month", totalClients ?? '0', Icons.tab),
                          // makeDashboardContainer(),
                        ],
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(12),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .15,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(ProdList.routeName);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                  child: Icon(
                                Icons.device_hub_rounded,
                                size: 30.0,
                                color: Colors.black,
                              )),
                              Center(
                                child: Text(
                                  'Recommended Products',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  products,
                                  style: TextStyle(
                                      fontSize: 42.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    unreadUsers == null
                        ? Card(
                            margin: EdgeInsets.all(12),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * .15,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[400],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                onTap: () {
                                  // Navigator.of(context)
                                  //     .pushNamed(Unreads.routeName);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Center(
                                        child: Icon(
                                      Icons.notification_important_rounded,
                                      size: 30.0,
                                      color: Colors.black,
                                    )),
                                    Center(
                                      child: Text(
                                        'No Queries Today',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        '0',
                                        style: TextStyle(
                                            fontSize: 42.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Card(
                            margin: EdgeInsets.all(12),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * .15,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[400],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(Unreads.routeName);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Center(
                                        child: Icon(
                                      Icons.notification_important_rounded,
                                      size: 30.0,
                                      color: Colors.black,
                                    )),
                                    Center(
                                      child: Text(
                                        'Unread Users',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        unreadUsers!,
                                        style: TextStyle(
                                            fontSize: 42.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    Card(
                      margin: EdgeInsets.all(12),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .15,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(ReviewList.routeName);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                  child: Icon(
                                Icons.feedback_sharp,
                                size: 30.0,
                                color: Colors.black,
                              )),
                              Center(
                                child: Text(
                                  'Customer Reviews',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  reviews,
                                  style: TextStyle(
                                      fontSize: 42.0, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  Card makeDashboardItem(String title, String users, IconData icon) {
    return Card(

        // shadowColor: Colors.orange[300],
        elevation: 1.0,
        margin: EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[400],
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
              var _value = title;
              if (_value == 'Total Clients') {
                Navigator.of(context).pushNamed(ClientList.routeName);
              }
              // else if (_value == 'Profile') {
              //   Navigator.of(context).pushNamed(WelcomeScreen.routeName);
              // }
              else if (_value == "New Users for the Month") {
                Navigator.of(context).pushNamed(Testimonial.routeName);
              } else {
                Navigator.of(context).pushNamed(ReferencePage.routeName);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 10.0),
                Center(
                    child: Icon(
                  icon,
                  size: 30.0,
                  color: Colors.black,
                )),
                SizedBox(height: 20.0),
                Center(
                  child: Text(
                    users,
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                new Center(
                  child: new Text(title,
                      style:
                          new TextStyle(fontSize: 18.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }
}
