// import 'package:docapp/widgets/admin_app_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/widgets/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:docapp/widgets/notification_api.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import 'package:docapp/models/client.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search';
  final DocumentSnapshot? clientDetails;
  final String chatId;
  final String senderName;
  SearchPage({
    this.clientDetails,
    required this.chatId,
    required this.senderName,
  });
  // const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? uName;
  String? rName;
  String? chatRoomId;
  @override
  void initState() {
    super.initState();
    uName = widget.clientDetails!['User Name'];
    rName = widget.senderName;
    chatRoomId = widget.chatId;
  }

  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // String? currUser = _auth.currentUser!.uid;
  String? docId = 'tgUV8diPrJSPMEfahcC9V4zPYEv2';

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sentBy": rName,
        "message": _message.text,
        "Time": FieldValue.serverTimestamp(),
      };
      print(_auth.currentUser!.displayName);
      _message.clear();
      if(_auth.currentUser!.uid == docId) {
        await FirebaseFirestore.instance
          .collection('Chat Room')
          .doc(chatRoomId)
          .collection('Chats')
          .add(messages);
      } else {
        await FirebaseFirestore.instance
          .collection('Doc Chat Room')
          .doc(chatRoomId)
          .collection('Chats')
          .add(messages);
      }
      
    } else {
      print('Enter Text Message');
    }
  }

  TextEditingController _message = TextEditingController();
  TextEditingController nameSearchController = TextEditingController();

  Future getChats() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection('Chat Room')
        .doc(chatRoomId)
        .collection('Chats')
        .orderBy('Time', descending: false)
        .get();

    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('$uName: Ask Doctor'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: size.height / 1.25,
                width: size.width,
                child: StreamBuilder(
                   stream: _auth.currentUser!.uid == docId ? FirebaseFirestore.instance
                      .collection('Doc Chat Room')
                      .doc(chatRoomId)
                      .collection('Chats')
                      .orderBy('Time', descending: false)
                      .snapshots()
                      : FirebaseFirestore.instance
                      .collection('Chat Room')
                      .doc(chatRoomId)
                      .collection('Chats')
                      .orderBy('Time', descending: false)
                      .snapshots(),                      
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (_, index) {
                           Map<String, dynamic>? map =
                                  snapshot.data!.docs[index].data() as Map<String, dynamic>?;
                                return messages(size, map);
                        },
                      );
                    } else {
                      return Container();
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
                      Icon(
                        Icons.messenger,
                      ),
                      SizedBox(
                        width: 12,
                      ),
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
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.blueGrey,
                          ),
                          elevation: MaterialStateProperty.all(6),
                        ),
                        onPressed: onSendMessage,
                        //  () {
                        // NotificationApi.showNotification(
                        //   title: 'Dr. Ajit George Mohan',
                        //   body: notificationController.text,
                        //   payload: 'Free Dental Check Up for Kids...',
                        // );

                        // },

                        child: Text(
                          'Send',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
      alignment: map!['sentBy'] == rName
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
