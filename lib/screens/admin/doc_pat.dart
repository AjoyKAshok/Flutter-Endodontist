import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/widgets/admin_app_drawer.dart';
import 'package:the_endodontist_app/widgets/app_drawer.dart';
import 'package:the_endodontist_app/widgets/chat_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DocToPat extends StatefulWidget {
  static const routeName = '/doc-to-patient';
  const DocToPat({Key? key}) : super(key: key);

  @override
  _DocToPatState createState() => _DocToPatState();
}

class _DocToPatState extends State<DocToPat> {
  String? docName;
  String? docId = 'tgUV8diPrJSPMEfahcC9V4zPYEv2';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future getUserInfo() async {
    String? id = docId;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(id);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        setState(() {
          docName = snapshot['User Name'];
          print(docName);
        });
      }
    });
    return documentReference;
  }

  Future getClientsinChat() async {
    var firestore = FirebaseFirestore.instance;
    String? chatId;
    QuerySnapshot qn = await firestore.collection('Chat Room').doc(chatId).collection('Chats').get();
    return qn.docs;
  }

  @override
  void initState() {
    
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Patients in Chat'),
      ),
      drawer: _auth.currentUser!.uid == docId ? AdminAppDrawer() : AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
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
                        itemBuilder: (context, index) => buildChatCard(
                            context, snapshot.data!.docs[index]['sentBy'], docName!),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
