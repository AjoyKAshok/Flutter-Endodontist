import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/database/database.dart';
import 'package:the_endodontist_app/widgets/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PatientToDoc extends StatefulWidget {
  static const routeName = '/patient-to-doc';
  const PatientToDoc({Key? key}) : super(key: key);

  @override
  _PatientToDocState createState() => _PatientToDocState();
}

class _PatientToDocState extends State<PatientToDoc> {
  String? patientName;
  String? docName;
  String? docId = 'tgUV8diPrJSPMEfahcC9V4zPYEv2';
  String? chatRoomId;
  String? patientPic;
  String? docPic;
  int msgCountValue = 1;
  int? counter = 0;
  bool isRead = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _message = TextEditingController();

  Future getPatientInfo() async {
    String uid = _auth.currentUser!.uid;
    // print(uid);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        setState(() {
          patientName = snapshot['User Name'];
          print('From Patient Screen: $patientName');
          patientPic = snapshot['Profile Image Path'];
        });
      }
    });
    return documentReference;
  }

  onSendMessage() async {
    String uid = _auth.currentUser!.uid;

    setState(() {
      counter = (counter! + 1);
    });
    updateUnreadCount(counter!, isRead, uid, patientName!, patientPic!);
    FocusScope.of(context).unfocus();
    
    //  print(chatRoomId);
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sentBy": patientName,
        "message": _message.text,
        "Time": FieldValue.serverTimestamp(),
        "Message Read": isRead,
      };

      Map<String, dynamic> msgC = {
        "Sent By": patientName,
        "Message": _message.text,
        "Time": FieldValue.serverTimestamp(),
        "Message Read": isRead,
        'Message Count': counter,
      };

      Map<String, dynamic> theCount = {
        "Message Read": isRead,
        'Message Count': counter,
      };
      // print('$uName');
      _message.clear();
      await FirebaseFirestore.instance
          .collection('Chat Room')
          .doc(chatRoomId)
          .collection('Chats')
          .add(messages);

      await FirebaseFirestore.instance
          .collection('Chat Room')
          .doc(chatRoomId)
          .collection('Unread')
          .add(msgC);


      Future<DocumentReference<Map<String, dynamic>>> documentReference =
          FirebaseFirestore.instance.collection('Doc Chat List1').add(messages);

      // Future<DocumentReference<Map<String, dynamic>>> documentReference =
      //     FirebaseFirestore.instance.collection('Doc Chat List1').add(messages);

      
    } else {
      print('Enter Text Message');
    }
  }

  Future getDocInfo() async {
    String uid = 'tgUV8diPrJSPMEfahcC9V4zPYEv2';
    // print(uid);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        setState(() {
          docName = snapshot['User Name'];
          print('From Patient Screen: $docName');
          docPic = snapshot['Profile Image Path'];
        });
      }
    });
    return documentReference;
  }

  String? chatId(String? user1, String? user2) {
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

  @override
  void initState() {
    super.initState();
    getPatientInfo();
    getDocInfo();
    // print('Initial: $patientName');
  }

  @override
  Widget build(BuildContext context) {
    chatRoomId = chatId(docName, patientName);
    print(chatRoomId);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Ask Dr. Ajit'),
      ),
      drawer: AppDrawer(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                                  return messages(
                                      size, map, patientPic!, docPic!);
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

  Widget messages(
      Size size, Map<String, dynamic>? map, String patientPic, String docPic) {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.6,
      // alignment: map!['sentBy'] == rName
      //     ? Alignment.centerRight
      //     : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: map!['sentBy'] == patientName
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          map['sentBy'] == patientName
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
                          color: map['sentBy'] == patientName
                              ? Colors.blue
                              : Colors.lightGreen,
                        ),
                        child: Text(
                          map['message'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        backgroundImage: map['sentBy'] == patientName
                            ? NetworkImage(
                                patientPic,
                              )
                            : NetworkImage(
                                docPic,
                              ),
                        radius: 15,
                      ),
                    ],
                  ),
                )
              : Container(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: map['sentBy'] == patientName
                            ? NetworkImage(
                                patientPic,
                              )
                            : NetworkImage(
                                docPic,
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
                          color: map['sentBy'] == patientName
                              ? Colors.blue
                              : Colors.lightGreen,
                        ),
                        child: Text(
                          map['message'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
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
