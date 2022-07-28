import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/database/database.dart';
// import 'package:the_endodontist_app/models/client.dart';
// import 'package:the_endodontist_app/screens/clients/query.dart';
// import 'package:the_endodontist_app/widgets/chat_app.dart';
import 'package:the_endodontist_app/widgets/display_count.dart';
import 'package:the_endodontist_app/widgets/in_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget buildClientCard(
  BuildContext context,
  String patientName,
  String profilePic,
  String patientId,
  String userName,
) {
  // final patient = Patient.fromSnapshot(document!);
  String displayName = userName;
  String patName = patientName;
  String picLink = profilePic;
  String pId = patientId;
  String? cId;
  int? mCount;

  String dName = userName;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? docId = 'tgUV8diPrJSPMEfahcC9V4zPYEv2';

  // final displayName = document['User Name'];
  // final residingCity = document['Residing City'];
  // final email = document['Email'];
  // final mobileNumber = document['Mobile Number'];

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

  void _markAsRead(cId, clientName) {
    FirebaseFirestore.instance
        .collection('Chat Room')
        .doc(cId)
        .collection('Chats')
        .where('sentBy', isEqualTo: clientName)
        .where('Message Read', isEqualTo: false)
        .get()
        .then((docSnap) {
      if (docSnap.docs.length > 0) {
        for (DocumentSnapshot doc in docSnap.docs) {
          doc.reference.update({'Message Read': true});
        }
      }
    });
    resetUnreadCount(pId);
    // removeFromUnread(pId);
    
  }

  return ListTile(
    onTap: () {
      String idChat = chatId(displayName, patientName);
      _markAsRead(idChat, patientName);
      // _auth.currentUser!.uid == docId
      //     ?
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InChat(
            clientName: patientName,
            chatId: idChat,
            senderName: displayName,
            patientPic: picLink,
          ),
        ),
      );
      // Navigator.of(context).pushReplacementNamed(InChat.routeName);
      // : Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => QueryScreen(
      //         clientDetails: document,
      //         chatId: idChat,
      //         senderName: displayName,
      //       ),
      //     ),
      //   );
    },
    title: Card(
      color: Colors.blueGrey[400],
      shadowColor: Colors.amber,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    picLink,
                  ),
                  radius: 25,
                ),
              ),
            ),
            SizedBox(
              width: 9,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      patName,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    // Text(
                    //   client.residingCity,
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //   ),
                    // ),
                    // Text(
                    //   client.mobileNumber,
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //   ),
                    // ),
                    // Text(
                    //   client.email,
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            DisplayCount(dName, patName),
          ],
        ),
      ),
    ),
  );
}


  