import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiagnosticDetail extends StatefulWidget {
  final DocumentSnapshot? post;
  // final String id;
  DiagnosticDetail({
    this.post,
  });
  @override
  _DiagnosticDetailState createState() => _DiagnosticDetailState();
}

class _DiagnosticDetailState extends State<DiagnosticDetail> {
  String? imageLink;
  Future getUserPic() async {
    String? uid = widget.post!['User Id'];
    // var value = double.parse(amount);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Profile Pics').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        setState(() {
          imageLink = snapshot['Profile Image Path'];
        });
      }
    });
    return documentReference;
  }

  final TextEditingController _detailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getUserPic();
    _detailController.text = widget.post!['Description'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text(
            //   "${widget.post.data()['User Name']}: ${widget.post.data()['Role']}",

            // ),
            Text(
              "${widget.post!['User Name']}",
            ),
            Spacer(),
            imageLink != null
                ? CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(imageLink!),
                    // backgroundImage: NetworkImage(
                    //     imageLink,
                    //   ),
                  )
                : CircleAvatar(),
            // IconButton(
            //     icon: Icon(Icons.add),
            //     onPressed: () {
            //       _addDetailsModalSheet(context);
            //     }),
          ],
        ),
      ),
      body: Container(
        child: Card(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "${'Date of Diaganosis: '}${widget.post!['Date']}",
                ),
                SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text('Diaganosis Details:'),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _detailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
