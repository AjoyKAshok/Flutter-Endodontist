import 'package:the_endodontist_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ToDocChat extends StatefulWidget {
  static const routeName = '/query-to-doc';
  final String? clientName;
  final String? chatId;
  final String? senderName;
  ToDocChat({
    required this.clientName,
    required this.chatId,
    required this.senderName,
  });

  @override
  _ToDocChatState createState() => _ToDocChatState();
}

class _ToDocChatState extends State<ToDocChat> {
  String? receiverName;
  String? senderName;
  String? chatRoomId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? docId = 'tgUV8diPrJSPMEfahcC9V4zPYEv2';
  @override
  void initState() {
    super.initState();
    receiverName = widget.clientName;
    senderName = widget.senderName;
    chatRoomId = widget.chatId;
    // print(receiverName);
    print(senderName);
    // print(chatRoomId);
    // getChats();
  }

  void onSendMessage() async {
    //  print(chatRoomId);
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sentBy": senderName,
        "message": _message.text,
        "Time": FieldValue.serverTimestamp(),
      };
      // print('$uName');

      _message.clear();
      await FirebaseFirestore.instance
          .collection('Chat Room')
          .doc(chatRoomId)
          .collection('Chats')
          .add(messages);

      Future<DocumentReference<Map<String, dynamic>>> documentReference =
          FirebaseFirestore.instance.collection('Doc Chat List1').add(messages);

      // Future<DocumentReference<Map<String, dynamic>>> documentReference =
      //     FirebaseFirestore.instance.collection('Doc Chat List1').add(messages);
    } else {
      print('Enter Text Message');
    }
  }

  TextEditingController _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title:  _auth.currentUser!.uid == docId
            ? Text("$receiverName")
            : Text('Dr. Ajith'),
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
                              // reverse: true,
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
