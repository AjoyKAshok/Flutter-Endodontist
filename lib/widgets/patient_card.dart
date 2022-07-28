import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/models/client.dart';
import 'package:the_endodontist_app/widgets/in_chat.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget buildPatientCard(
  BuildContext context,
  DocumentSnapshot? document,
  String docName,
) {
  final client = Patient.fromSnapshot(document!);
  String clientName = client.userName;
  String displayName = docName;
  String profilePic = client.profilePic;
  int? mCounter;
  

  // int mCount = 0;

  // print('Chat Patient: $clientName');
  // print('Chat Doc: $docName');
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // String? docId = 'tgUV8diPrJSPMEfahcC9V4zPYEv2';
  String chatId(String? user1, String? user2) {
    // print('1st User: $user1');
    // print('2nd User: $user2');
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

 getCount(patientName, cId) {
    FirebaseFirestore.instance
        .collection('Chat Room')
        .doc(cId)
        .collection('Chats')
        .where('sentBy', isEqualTo: patientName)
        .where('Message Read', isEqualTo: false)
        .get()
        .then((docSnap) {
      mCounter = docSnap.docs.length;
      // print('Chats in $cId by $patientName: $mCounter');
      // print('$cId - $patientName: $mCounter');
    return mCounter;
    });
  }

  Container getMessageCount(String docNmae, String patientName) {
    String cId = chatId(docName, patientName);
    int? msgCount = getCount(patientName, cId);
    // print('$cId -- $msgCount');

    return msgCount != null
        ? Container(
            width: 30,
            child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.lime.shade300,
              child: Text('$mCounter'),
              // child: Text($mCount),
            ),
          )
        : Container(
            width: 30,
            child: Text(''),
          );
  }
  // TRIED TO GET THE CHAT COUNT FOR DISPLAYING

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
              getMessageCount(displayName, clientName),
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
