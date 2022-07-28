import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/widgets/admin_app_drawer.dart';
import 'package:the_endodontist_app/widgets/make_pat_card.dart';

// import 'package:the_endodontist_app/widgets/patient_card.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_endodontist_app/models/client.dart';


class ToSearchPage extends StatefulWidget {
  static const routeName = '/to-search';
  const ToSearchPage({Key? key}) : super(key: key);

  @override
  _ToSearchPageState createState() => _ToSearchPageState();
}

class _ToSearchPageState extends State<ToSearchPage> {
  String? currentUserName;
  late Future clientListLoaded;
  String? pName;
  late String chatRoomId;
  TextEditingController nameSearchController = TextEditingController();
  int? msgCounter;
  List allClients = [];
  List searchResultList = [];
  // List chatIdList = [];

  getClientInfo() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('Users').get();
    setState(() {
      allClients = qn.docs;
    });
    // getMessageInfo();

    // getUserInfo();
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
        // print('In Method: $currentUserName');
        // if (currentUserName != null) {
        //   getClientInfo();
        // }
      }
    });
    return documentReference;
  }

  
  String? chatId(String? user1, String? user2) {
    print('User 1: $user1');
    print('User 2: $user2');
    // _auth.currentUser!.uid == docId ? user1 = 'Dr. Ajit' : user2 = 'Dr. Ajit';
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

  /// GET DETAILS OF CLIENTS FROM THE LIST ALLCLIENTS. GET DETAILS OF DOC FROM GET USER INFO METHOD.
  /// GENERATE CHAT ID FOR EACH USER IN THE ALLCLIENTS LIST.
  /// GET THE DETAILS OF CHAT CORRESPONDING TO EACH CHATID AND THEN CHECK FOR UNREAD MESSAGES AND PASS ON TO
  /// PATIENT CARD
  // List? getChatList(
  //     String? pName, String? cureentUserName, String? chatRoomId) {
  //   chatIdList.add(chatRoomId);
  //   // print(chatIdList);

  //   return chatIdList;
  //   // chatIdList.add(chatRoomId);
  // }

  // int? getMsgCount(pName, chatRoomId) {
  //   String cId = chatRoomId;

  //   // print(cId);
  //   FirebaseFirestore.instance
  //       .collection('Chat Room')
  //       .doc(cId)
  //       .collection('Chats')
  //       .where('sentBy', isEqualTo: pName)
  //       .where('Message Read', isEqualTo: false)
  //       .get()
  //       .then((docSnap) {
  //     setState(() {
  //       msgCounter = docSnap.docs.length;
  //     });
  //     print('Chats in $cId by $pName: $msgCounter');
  //     return msgCounter;
  //   });
  // }

  // void getMessageInfo() async {
  //   for (var patientSnapshot in allClients) {
  //     setState(() {
  //       pName = Patient.fromSnapshot(patientSnapshot).userName;
  //     });
  //     if (currentUserName != null) {
  //       chatRoomId = chatId(currentUserName, pName)!;
  //       // getChatList(pName, currentUserName, chatRoomId);
  //     //  getMsgCount(pName, chatRoomId);
  //       // print('Chats in $chatRoomId by $pName: $count');
  //     }
  //   }
  //   // for (var cId in chatIdList) {
  //   //   getMsgCount(cId);
  //   // }
  // }

  

  @override
  void initState() {
    super.initState();

    nameSearchController.addListener(onSearch);
    getUserInfo();
    
    // print(currentUserName);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    clientListLoaded = getClientInfo();
  }

  @override
  void dispose() {
    nameSearchController.removeListener(onSearch);
    nameSearchController.dispose();
    super.dispose();
  }

  onSearch() {
    searchResults();
  }

  searchResults() {
    var showResults = [];
    if (nameSearchController.text != "") {
      for (var clientSnapshot in allClients) {
        var uName = Client.fromSnapshot(clientSnapshot).userName.toLowerCase();
        // var rCity =
        //     Client.fromSnapshot(clientSnapshot).residingCity.toLowerCase();
        if (uName.contains(nameSearchController.text.toLowerCase())) {
          showResults.add(clientSnapshot);
        }
        // else if (rCity.contains(nameSearchController.text.toLowerCase())) {
        //   showResults.add(clientSnapshot);
        // }
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
    // final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Patients'),
      ),
      drawer: AdminAppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Column(
              children: [
                // Padding(
                //   padding: EdgeInsets.all(12),
                //   child: Text(
                //     "Search By Name",
                //     style: TextStyle(
                //         color: Colors.black, fontWeight: FontWeight.bold),
                //   ),
                // ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nameSearchController,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: "Enter Name of Patient",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            SingleChildScrollView(
              child: Container(
                  height: MediaQuery.of(context).size.height * .7,
                  child: currentUserName != null
                      ? ListView.builder(
                          itemCount: searchResultList.length,
                          itemBuilder: (BuildContext ctx, index) =>
                              buildPatCard(
                                ctx,
                                searchResultList[index],
                                currentUserName!,
                              ))
                      : Container()),
            ),
            // SizedBox(
            //   height: 12,
            // ),
            // Container(
            //   height: 90,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Icon(
            //         Icons.messenger,
            //       ),
            //       SizedBox(
            //         width: 12,
            //       ),
            //       Expanded(
            //         child: TextField(
            //           maxLines: 5,
            //           controller: notificationController,
            //           decoration: InputDecoration(
            //             border: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(12),
            //             ),
            //             hintText: "Enter Notification Here",
            //           ),
            //         ),
            //       ),
            //       SizedBox(
            //         width: 12,
            //       ),
            //       TextButton(
            //         style: ButtonStyle(
            //           backgroundColor: MaterialStateProperty.all(
            //             Colors.blueGrey,
            //           ),
            //           elevation: MaterialStateProperty.all(6),
            //         ),
            //         onPressed: () {
            //           NotificationApi.showNotification(
            //             title: 'Dr. Ajit George Mohan',
            //             body: notificationController.text,
            //             payload: 'payload',
            //           );
            //         },
            //         child: Text(
            //           'Send',
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
