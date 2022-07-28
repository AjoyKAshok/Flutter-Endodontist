import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/models/client.dart';
// import 'package:the_endodontist_app/models/client.dart';
import 'package:the_endodontist_app/widgets/in_chat.dart';
import 'package:flutter/material.dart';

class BuildPatientCard extends StatefulWidget {
  static const routeName = '/patient-card';
  final BuildContext context;
  final DocumentSnapshot? ds;
  final String docName;
  const BuildPatientCard(
    this.context,
    this.ds,
    this.docName,
  );

  @override
  _BuildPatientCardState createState() => _BuildPatientCardState();
}

class _BuildPatientCardState extends State<BuildPatientCard> {
  // final patient = Patient.fromSnapshot(ds!);
  String? patName;
  String? dName;
  late String profilePic;
  String? cId;
  int? mCounter;
  int? mCount;
  String? displayName;
  String? clientName;
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
    int? msgCount;
    cId = chatId(dName, patName);
    var counter = FirebaseFirestore.instance
        .collection('Chat Room')
        .doc(cId)
        .collection('Chats')
        .where('sentBy', isEqualTo: patName)
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

    return mCount != 0
        ? Container(
            width: 60,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.black,
              child: Text(
                '$mCount',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              // child: Text($mCount),
            ),
          )
        : Container(
            width: 60,
          );
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
  }

  @override
  void initState() {
    final patient = Patient.fromSnapshot(widget.ds!);
    patName = patient.userName;
    // widget.ds!['User Name'];
    // print(patName);
    profilePic = widget.ds!['Profile Image Path'];
    dName = widget.docName;
    cId = chatId(dName, patName);
    displayName = dName;
    clientName = patName;
    // setState(() {
    // mCount = getCount(patName, cId)!;
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    patName!,
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
          _markAsRead(cId, clientName);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InChat(
                clientName: clientName!,
                chatId: idChat,
                senderName: displayName!,
                patientPic: profilePic,
              ),
            ),
          );
        });
  }
}
