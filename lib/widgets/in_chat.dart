import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:endodontist/widgets/admin_app_drawer.dart';
// import 'package:endodontist/widgets/app_drawer.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class InChat extends StatefulWidget {
  static const routeName = '/in-chat';
  final String clientName;
  final String chatId;
  final String senderName;
  final String patientPic;

  InChat({
    required this.clientName,
    required this.chatId,
    required this.senderName,
    required this.patientPic,
  });

  @override
  _InChatState createState() => _InChatState();
}

class _InChatState extends State<InChat> {
  String? uName;
  String? rName;
  String? chatRoomId;
  int? mCount;
  String? senderPic;
  String? patientPic;
  bool isRead = false;

  int? dCount() {
    int? msgCount;
    // cId = chatId(dName, pName);

    var counter = FirebaseFirestore.instance
        .collection('Chat Room')
        .doc(chatRoomId)
        .collection('Chats')
        .where('sentBy', isEqualTo: uName)
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
    return mCount;
  }

  Future getSenderPic() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        setState(() {
          senderPic = snapshot['Profile Image Path'];
        });
      }
      
    });
    return documentReference;
  }

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  String? docId = 'tgUV8diPrJSPMEfahcC9V4zPYEv2';
  @override
  void initState() {
    super.initState();
    uName = widget.clientName;
    rName = widget.senderName;
    chatRoomId = widget.chatId;

    getSenderPic();
    dCount();
    patientPic = widget.patientPic;
    // mCount = 0;
    print('Patient Name: $uName');
    print('Doc Name: $rName');
    print(widget.chatId);
    // getChats();
  }

  void onSendMessage() async {
    FocusScope.of(context).unfocus();
    if (_message.text.isNotEmpty) {
      // mCount = mCount! + 1;
      Map<String, dynamic> messages = {
        "sentBy": rName,
        "message": _message.text,
        "Time": FieldValue.serverTimestamp(),
        "Message Read": isRead,
      };
      // print('$uName');

      _message.clear();
      await FirebaseFirestore.instance
          .collection('Chat Room')
          .doc(chatRoomId)
          .collection('Chats')
          .add(messages);
    } else {
      print('Enter Text Message');
    }
  }

  // void saveUnreadCount(String? cId, int? mCount) async {
  //   print(mCount);
  //   Map<String, dynamic> msgCounter = {
  //     "Sent By": rName,
  //     "Message Count": mCount,
  //     "Time": FieldValue.serverTimestamp(),
  //     "Message Read": isRead,
  //   };
  //   await FirebaseFirestore.instance
  //       .collection('Chat Room')
  //       .doc(cId)
  //       .collection('Unread Notifications')
  //       .add(msgCounter);
  // }

  TextEditingController _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("$uName"),
      ),
      // drawer: _auth.currentUser!.uid == docId ? AdminAppDrawer() : AppDrawer(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: size.height / 1.35,
                  width: size.width,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Chat Room')
                        .doc(chatRoomId)
                        .collection('Chats')
                        .orderBy('Time', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                reverse: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (_, index) {
                                  Map<String, dynamic>? map =
                                      snapshot.data!.docs[index].data()
                                          as Map<String, dynamic>?;
                                  return messages(size, map);
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: 5,
                            controller: _message,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: "Enter Message Here",
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        IconButton(
                          onPressed: onSendMessage,
                          // saveUnreadCount(
                          //   chatRoomId, mCount
                          // );

                          icon: Icon(Icons.send),
                          iconSize: 42,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic>? map) {
    final Timestamp time = (map!['Time']);
    var timeNow = DateTime.parse(time.toDate().toString());
    String tNow = timeNow.toString();
    // print(timeNow);
    return Container(
      // width: MediaQuery.of(context).size.width * 0.6,
      // alignment: map!['sentBy'] == rName
      //     ? Alignment.centerRight
      //     : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: map['sentBy'] == rName
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          map['sentBy'] == rName
              ? Container(
                  child: Row(
                    children: [
                      Container(
                        width: size.width * .6,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: map['sentBy'] == rName
                              ? Colors.blue
                              : Colors.lightGreen,
                        ),
                        child: Column(
                          children: [
                            Text(
                              map['message'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 3),
                            // Text(tNow),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: map['sentBy'] == rName
                                ? NetworkImage(
                                    senderPic!,
                                  )
                                : NetworkImage(
                                    patientPic!,
                                  ),
                            radius: 15,
                          ),
                          // Text(tNow),
                        ],
                      ),
                    ],
                  ),
                )
              : Container(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: map['sentBy'] == rName
                            ? NetworkImage(
                                senderPic!,
                              )
                            : NetworkImage(
                                patientPic!,
                              ),
                        radius: 15,
                      ),
                      Container(
                        width: size.width * .6,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: map['sentBy'] == rName
                              ? Colors.blue
                              : Colors.lightGreen,
                        ),
                        child: Column(
                          children: [
                            Text(
                              map['message'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 3),
                            // Text(tNow),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
