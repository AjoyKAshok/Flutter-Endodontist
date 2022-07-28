import 'package:the_endodontist_app/widgets/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClientChatPage extends StatefulWidget {
  static const routeName = '/client-chat-screen';
  const ClientChatPage({Key? key}) : super(key: key);

  @override
  _ClientChatPageState createState() => _ClientChatPageState();
}

class _ClientChatPageState extends State<ClientChatPage> {
  String? receiverName;
  String? senderName;
  String? chatRoomId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? docId = 'tgUV8diPrJSPMEfahcC9V4zPYEv2';
  String? docName;
  TextEditingController _message = TextEditingController();
  Future getDocName() async {
    String? uid = docId;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        setState(() {
          docName = snapshot['User Name'];
          print("Doc Name: $docName");
        });
      }
    });
    return documentReference;
  }

  Future getUserInfo() async {
    getDocName();
    String uid = _auth.currentUser!.uid;
    print('User id: $uid');
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        _auth.currentUser!.uid == docId
            ? setState(() {
                senderName = docName;
                receiverName = snapshot['User Name'];
                print(senderName);

                print('uid == docId');
              })
            : setState(() {
                receiverName = docName;
                senderName = snapshot['User Name'];
                print(receiverName);
                print(senderName);
                print('uid != docId');
              });
      }
    });
    return documentReference;
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    // getDocName();
    // chatId(receiverName, senderName);
  }

  void onSendMessage() async {
    print('Sent by $senderName');
    print('Message to $receiverName');
    chatRoomId = chatId(receiverName, senderName);
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sentBy": senderName,
        "message": _message.text,
        "Time": FieldValue.serverTimestamp(),
      };
      // String? patientName = messages['sentBy'];

      // print(_auth.currentUser!.uid);
      _message.clear();
      await FirebaseFirestore.instance
          .collection('Chat Room')
          .doc(chatRoomId)
          .collection('Chats')
          .add(messages);
      Future<DocumentReference<Map<String, dynamic>>> documentReference =
          FirebaseFirestore.instance.collection('Doc Chat List1').add(messages);

      // await FirebaseFirestore.instance
      //     .collection('Doc Chat List1')
      //     .doc(senderName)
      //     .snapshots();
      //     if(snapshot)
    } else {
      print('Enter Text Message');
    }
  }

  String chatId(String? doc, String? recvdBy) {
    doc = 'Dr. Ajit';
    if (recvdBy != null) {
      if (doc[0].toLowerCase().codeUnits[0] >
          recvdBy.toLowerCase().codeUnits[0]) {
        return '$doc->$recvdBy';
      } else {
        return '$recvdBy->$doc';
      }
    } else {
      return 'Enter User Names';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Dr. Ajit'),
      ),
      drawer: AppDrawer(),
      body: Padding(
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
                      .orderBy('Time', descending: false)
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
                padding: const EdgeInsets.all(12.0),
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
    );
  }

  Widget messages(Size size, Map<String, dynamic>? map) {
    return Container(
      width: size.width,
      alignment: map!['sentBy'] == senderName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.blue,
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
    );
  }
}
