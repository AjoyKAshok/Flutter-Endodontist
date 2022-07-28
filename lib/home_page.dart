import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/widgets/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? patientName;
  String? imageLink;
  String? prodImgLink;
  String uid = 'tgUV8diPrJSPMEfahcC9V4zPYEv2';

  Future getUserInfo() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    // var value = double.parse(amount);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(id);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        if (mounted) {
          setState(() {
            // imageLink = snapshot['Profile Image Path'];
            patientName = snapshot['User Name'];
            // print('Profile Pic : $patientName');
          });
        }
      }
    });
    return documentReference;
  }

  Future getUserPic() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    // var value = double.parse(amount);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Profile Pics').doc(id);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        if (mounted) {
          setState(() {
            imageLink = snapshot['Profile Image Path'];
            print('Profile Pic : $imageLink');
          });
        }
      }
    });
    return documentReference;
  }

  Future getProdInfo() async {
    String uid = 'tgUV8diPrJSPMEfahcC9V4zPYEv2';
    // var value = double.parse(amount);
    String? prodId;
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Recommended Products')
        .doc(uid)
        .collection('Product Id')
        .doc(prodId);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        if (mounted) {
          setState(() {
            prodImgLink = snapshot['Produc Image Path'];
          });
        }
      }
    });
    return documentReference;
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    getProdInfo();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Hello $patientName'),
            Spacer(),
            prodImgLink != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(prodImgLink!),
                  )
                : CircleAvatar(),
          ],
        ),
      ),
      drawer: AppDrawer(),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.teal[100],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Recommended Products')
                            .doc(uid)
                            .collection('Product Id')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs.map((document) {
                              return Container(

                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(10),
                                  // ),
                                  width:
                                      MediaQuery.of(context).size.width * .80,
                                  child: Card(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Center(
                                            child: Text(
                                              'Recommended Products',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          prodImgLink != null
                                              ? CircleAvatar(
                                                  backgroundImage: 
                                                      
                                                              NetworkImage(document['Product Image Path']
                                                          .toString()),
                                                )
                                              : CircleAvatar(),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                "Product Name : ${document['Product Name']}"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                "Description : ${document['Product Description']}"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              print('Product: $prodImgLink');
                                              // openUrl();
                                              // www.google.com/maps/dir//Dr.Ajit+GEORGE+Mohan/@25.2539089,51.4532141,12z/data=!3m1!4b1!4m8!4m7!1m0!1m5!1m1!1s0x3e45d99372cda0bb:0x1bde277121397937!2m2!1d51.5232544!2d25.2539254
                                            },
                                            child: Text(
                                              'View Product Details',
                                              style: TextStyle(
                                                color: Colors.deepOrange,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                            }).toList(),
                          );
                        }),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
