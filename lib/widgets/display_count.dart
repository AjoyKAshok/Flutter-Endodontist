import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayCount extends StatefulWidget {
  static const routeName = '/count';
  final String dName;
  final String pName;
  const DisplayCount(
    this.dName,
    this.pName,
  );

  @override
  _DisplayCountState createState() => _DisplayCountState();
}

class _DisplayCountState extends State<DisplayCount> {
  String? pName;
  String? dName;
  late String profilePic;
  String? cId;
  int? mCounter;
  int? mCount;
  String? displayName;
  String? clientName;
  bool isRead = false;

  @override
  void initState() {
    pName = widget.pName;
    dName = widget.dName;
    super.initState();
  }

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

 

  Widget dCount() {
    int? msgCount;
    cId = chatId(dName, pName);
   
    var counter = FirebaseFirestore.instance
        .collection('Chat Room')
        .doc(cId)
        .collection('Chats')
        .where('sentBy', isEqualTo: pName)
        .where('Message Read', isEqualTo: false)
        .get()
        .then((docSnap) {
      if (mounted) {
        setState(() {
          msgCount = docSnap.docs.length;
          mCount = msgCount!;
        });
        // saveUnreadCount(cId, mCount);
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
    // await FirebaseFirestore.instance
    //     .collection('Chat Room')
    //     .doc(cId)
    //     .collection('Unread Notifications')
    //     .add(msgCounter);
  }

  @override
  Widget build(BuildContext context) {
    return dCount();
  }
}
