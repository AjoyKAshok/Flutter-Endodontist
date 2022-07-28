import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/models/client.dart';

import 'package:the_endodontist_app/widgets/admin_app_drawer.dart';
import 'package:the_endodontist_app/widgets/build_pat_card.dart';
import 'package:the_endodontist_app/widgets/client_card.dart';
import 'package:the_endodontist_app/widgets/unread_clients.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Finder extends StatefulWidget {
  static const routeName = '/finding';
  const Finder({Key? key}) : super(key: key);

  @override
  _FinderState createState() => _FinderState();
}

class _FinderState extends State<Finder> {
  String? currentUserName;

  List allClients = [];
  List searchResultList = [];

  getClientInfo() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('Users').get();
    setState(() {
      allClients = qn.docs;
    });
    searchResults();
    return qn.docs;
  }

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

  late Future clientListLoaded;
  TextEditingController searchController = TextEditingController();
  // TextEditingController nameSearchController = TextEditingController();
  // TextEditingController notificationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // NotificationApi.init();
    // listenNotifications();
    searchController.addListener(onSearch);
    getUserInfo();
  }

  // void listenNotifications() =>
  //     NotificationApi.onNotifications.stream.listen(onClickedNotification);

  // void onClickedNotification(String? payload) =>
  //     // Navigator.push(
  //     //                   context,
  //     //                   MaterialPageRoute(
  //     //                     builder: (context) => NotificationSend(payload: payload),
  //     //                   ),
  //     //                 );
  //     Navigator.of(context).push(MaterialPageRoute(
  //         builder: (context) => NotificationSend(
  //               payload: payload,
  //             )));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    clientListLoaded = getClientInfo();
  }

  @override
  void dispose() {
    searchController.removeListener(onSearch);
    searchController.dispose();
    super.dispose();
  }

  onSearch() {
    searchResults();
  }

  

  searchResults() {
    var showResults = [];
    if (searchController.text != "") {
      for (var clientSnapshot in allClients) {
        var uName = Patient.fromSnapshot(clientSnapshot).userName.toLowerCase();
        if (uName.contains(searchController.text.toLowerCase())) {
          showResults.add(clientSnapshot);
          print(searchController.text);
          print(uName);
        }
      }
    } else {
      showResults = List.from(allClients);
    }
    setState(() {
      searchResultList = showResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Important Notifications'),
      ),
      drawer: AdminAppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      "Search Parameter",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: "Enter Search Parameter",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              SingleChildScrollView(
                child: Container(
                    height: MediaQuery.of(context).size.height * .75,
                    child: currentUserName != null
                        ? ListView.builder(
                            itemCount: searchResultList.length,
                            itemBuilder: (BuildContext ctx, index) =>
                                buildUnreadClientCard(
                                  ctx,
                                  searchResultList[index]['User Name'],
                                  searchResultList[index]['Profile Image Path'],
                                  searchResultList[index]['User Id'],
                                  currentUserName!,
                                ))
                        : Container()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
