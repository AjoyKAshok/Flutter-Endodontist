import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/screens/clients/patient_doc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class ImageCarousel extends StatefulWidget {
  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {

  String? imageLink;
  String? patientName;
  String? docName;
  String? cId;
  int? mCount;
  int? counter;

  Future getCarouselPic() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    // var value = double.parse(amount);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Profile Pics').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        if(mounted) {
        setState(() {
          imageLink = snapshot['Profile Image Path'];
        });
        }
      }
    });
    return documentReference;
  }

  Future getUserInfo() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        setState(() {
          patientName = snapshot['User Name'];
          // print(patientName);
        });
      }
    });
    return documentReference;
  }

  Future getDocInfo() async {
    String uid = 'tgUV8diPrJSPMEfahcC9V4zPYEv2';
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        setState(() {
          docName = snapshot['User Name'];
          // print(docName);
        });
      }
    });
    return documentReference;
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


   void _markAsRead(cId, docName) {
    FirebaseFirestore.instance
        .collection('Chat Room')
        .doc(cId)
        .collection('Chats')
        .where('sentBy', isEqualTo: docName)
        .where('Message Read', isEqualTo: false)
        .get()
        .then((docSnap) {
      if (docSnap.docs.length > 0) {
        for (DocumentSnapshot doc in docSnap.docs) {
          doc.reference.update({'Message Read': true});
        }
      }
    });
  }

  @override
  void initState() { 
    super.initState();
    getCarouselPic();
     getUserInfo();
    getDocInfo();
  }
  openUrl() async {
    if (await canLaunch(
        'https://www.google.com/maps/dir//Dr.Ajit+GEORGE+Mohan/@25.2539089,51.4532141,12z/data=!4m8!4m7!1m0!1m5!1m1!1s0x3e45d99372cda0bb:0x1bde277121397937!2m2!1d51.5232544!2d25.2539254')) {
      await launch(
          'https://www.google.com/maps/dir//Dr.Ajit+GEORGE+Mohan/@25.2539089,51.4532141,12z/data=!4m8!4m7!1m0!1m5!1m1!1s0x3e45d99372cda0bb:0x1bde277121397937!2m2!1d51.5232544!2d25.2539254');
    } else {
      throw 'Oops...Could not open Maps';
    }
  }

  Future<void> sendMail(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print('Could not Launch $command');
    }
  }

  Future<void> _phoneCall() async {
    const url = 'tel:9599011821';
    if (await canLaunch(url)) {
      launch(url);
    } else {
      throw 'Oops...Could not open Dialler...';
    }
  }

  int photoIndex = 0;

  List<String> photos = [
    'assets/images/Ajit1.png',
    'assets/images/Ajit2.jpg',
    'assets/images/Ajit3.jpg',
  ];
  void _previousImage() {
    setState(() {
      photoIndex = photoIndex > 0 ? photoIndex - 1 : 0;
    });
  }

  void _nextImage() {
    setState(() {
      photoIndex = photoIndex < photos.length - 1 ? photoIndex + 1 : photoIndex;
    });
  }

  int? displayCount(docName, cId) {
    int? msgCount;
    //  cId = chatId(dName, patName);
    var mcounter = FirebaseFirestore.instance
        .collection('Chat Room')
        .doc(cId)
        .collection('Chats')
        .where('sentBy', isEqualTo: docName)
        .where('Message Read', isEqualTo: false)
        .get()
        .then((docSnap) {
      if (mounted) {
        setState(() {
          msgCount = docSnap.docs.length;
          mCount = msgCount!;
          // print(mCount);
        });
      }

      // print(mCount);
    });
    return mCount;
  }

  @override
  Widget build(BuildContext context) {
    cId = chatId(docName, patientName);
    counter = displayCount(docName, cId);
    return Column(
      children: [
        Container(
          height: 400,
          width: 300,
          child: ListView(
            // scrollDirection: Axis.vertical,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                        image: AssetImage(photos[photoIndex]),
                        fit: BoxFit.cover),
                  ),
                  height: 300,
                  width: 250,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Dr. Ajit GEORGE Mohan",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      "12 Years of Experience",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left_rounded, color: Colors.green),
                onPressed: _previousImage,
                tooltip: 'Previous',
                iconSize: 60,
                // elevation: 5,
                // color: Colors.blue,
              ),
              SizedBox(width: 2),
              IconButton(
                  icon: Icon(Icons.phone_callback),
                  onPressed:
                      // _phoneCall,
                      () {
                    // Navigator.of(context)
                    //     .pushReplacementNamed(PhoneCall.routeName);
                  }),
              SizedBox(width: 2),
              IconButton(
                icon: Icon(Icons.contact_page_sharp),
                onPressed: () {
                  _contactModalBottomSheet(context);
                },
              ),
              SizedBox(width: 2),
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.chat),
                    onPressed: () {
                       _markAsRead(cId, docName);
                  Navigator.of(context)
                      .pushReplacementNamed(PatientToDoc.routeName);
                    },
                  ),
                  counter != 0
                ? Container(
                    width: 20,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.black,
                      child: Text(
                        '$counter',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: 20,
                  ),
                ],
              ),
              SizedBox(width: 2),
              IconButton(
                icon: Icon(Icons.location_pin),
                onPressed: openUrl,
              ),
              SizedBox(width: 2),
              IconButton(
                icon: Icon(Icons.arrow_right_rounded, color: Colors.green),
                onPressed: _nextImage,
                tooltip: 'Next',
                iconSize: 60,
                // elevation: 5,
                // color: Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _contactModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Contact Page",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 18,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
                  Divider(
                    thickness: 5,
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "My Mobile Number",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "9599011821",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.phone_sharp,
                          color: Colors.green,
                          size: 18,
                        ),
                        onPressed: _phoneCall,
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "My Email Id",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "ajoykashok@gmail.com",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.email,
                          color: Colors.green,
                          size: 18,
                        ),
                        onPressed: () {
                          sendMail(
                              'mailto:ajoykashok@gmail.com?subject=Enter%20Subject&body=Test%20body');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
