import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:the_endodontist_app/database/database.dart';
import 'package:the_endodontist_app/models/client.dart';
import 'package:the_endodontist_app/widgets/in_chat.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget buildPatCard(
  BuildContext context,
  DocumentSnapshot? document,
  String docName,
) {
  final client = Patient.fromSnapshot(document!);
  String clientName = client.userName;
  String displayName = docName;
  String profilePic = client.profilePic;

  return getMsgCount(context, displayName, clientName, profilePic);

}

Widget getMsgCount(BuildContext context, String displayName, String clientName,
    String profilePic) {
  String? cId;
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

  

  Widget displayCount() {
    int? mCount;
    cId = chatId(displayName, clientName);
    var counter = FirebaseFirestore.instance
        .collection('Chat Room')
        .doc(cId)
        .collection('Chats')
        .where('sentBy', isEqualTo: clientName)
        .where('Message Read', isEqualTo: false)
        .get()
        .then((docSnap) {
      mCount = docSnap.docs.length;
      print(mCount);
    });
    
    return Container(
      width: 30,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.white,
        child: Text('$mCount'),
        // child: Text($mCount),
      ),
    );
  }

  return ListTile(
      title: Card(
        color: Colors.brown.shade200,
        shadowColor: Colors.amber,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 60,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      profilePic,
                    ),
                    radius: 25,
                  ),
                ),
              ),

              // SizedBox(
              //   width:9,
              // ),
              Center(
                child: Text(
                  clientName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              displayCount(),
            ],
          ),
        ),
      ),
      onTap: () {
        // getChatCount();
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
