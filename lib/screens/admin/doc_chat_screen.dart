import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:the_endodontist_app/screens/clients/to_doc.dart';
import 'package:the_endodontist_app/widgets/admin_app_drawer.dart';
import 'package:the_endodontist_app/widgets/app_drawer.dart';
import 'package:the_endodontist_app/widgets/chat_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DocChatScreen extends StatefulWidget {
  static const routeName = '/doc-chat-screen';
  const DocChatScreen({Key? key}) : super(key: key);

  @override
  _DocChatScreenState createState() => _DocChatScreenState();
}

class _DocChatScreenState extends State<DocChatScreen> {
  String? docName;
  String? idChat;
  String? docId = 'tgUV8diPrJSPMEfahcC9V4zPYEv2';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? clientName;
  String? chatRoomId;
  TextEditingController _message = TextEditingController();

  
  Future getUserInfo() async {
    String? id = docId;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(id);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        setState(() {
          docName = snapshot['User Name'];
          print('Doctor Name: $docName');
        });
      }
    });
    return documentReference;
  }

  Future getPatientInfo() async {
    String uid = _auth.currentUser!.uid;
    // print(uid);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        setState(() {
          clientName = snapshot['User Name'];
          print('Patient Name: $clientName');
        });
      }
    });
    return documentReference;
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    getPatientInfo();

    // chatRoomId = idChat;
    // print(clientName);
    // print(docName);
  }

  String? chatId(String? user1, String? user2) {
    _auth.currentUser!.uid == docId ? user1 = 'Dr. Ajit' : user2 = 'Dr. Ajit';
    if (user1 != null && user2 != null) {
      if (user1[0].toLowerCase().codeUnits[0] >
          user2.toLowerCase().codeUnits[0]) {
        idChat = '$user1->$user2';
        return idChat;
      } else {
        idChat = '$user2->$user1';
        return idChat;
      }
    } else {
      return 'Enter User Names';
    }
  }

 
  Future getClientsinChat() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('Doc Chat List1').get();
    return qn.docs;
  }

  void onSendMessage() async {
    FocusScope.of(context).unfocus();
    chatRoomId = chatId(docName, clientName);
    // FocusScope.of(context).unfocus();
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sentBy": clientName,
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

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    clientName = _auth.currentUser!.displayName;
    return Scaffold(
      appBar: AppBar(
        title: _auth.currentUser!.uid == docId
            ? Text('Client List in Chat')
            : Text('Dr. Ajith'),
      ),
      drawer: _auth.currentUser!.uid == docId ? AdminAppDrawer() : AppDrawer(),
      body: Container(
        child: FutureBuilder(
          future: getClientsinChat(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) =>
                    
                    buildChatCard(
                        context, snapshot.data[index]['sentBy'], docName!),
                  );
            }
          },
        ),
      ),
          );
  }
}
