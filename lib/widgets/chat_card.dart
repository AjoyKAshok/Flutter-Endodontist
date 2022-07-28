// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:the_endodontist_app/screens/clients/to_doc.dart';
import 'package:the_endodontist_app/widgets/in_chat.dart';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget buildChatCard(BuildContext context, String patientName, String docName) {
  String clientName = patientName;
  String displayName = docName;
  String profilePic = 'https://firebasestorage.googleapis.com/v0/b/dent1-57a36.appspot.com/o/Profile%20Pics%2Fimage2021-05-01%2008:46:58.457693?alt=media&token=b162b662-20c5-4914-9e64-2b8d04148439';
  print('Chat Patient: $patientName');
  print('Chat Doc: $docName');
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // String? docId = 'tgUV8diPrJSPMEfahcC9V4zPYEv2';
  String chatId(String? user1, String? user2) {
    print('1st `user: $user1');
    print('2nd user: $user2');
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

  return ListTile(
      title: Card(
        color: Colors.cyan,
        shadowColor: Colors.amber,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: Text(
                  clientName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        String idChat = chatId(displayName, clientName);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InChat(
              clientName: clientName,
              chatId: idChat,
              senderName: displayName,
              patientPic: profilePic,
            ),
          ),
        );
      });
}
