import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/screens/clients/patient_doc.dart';
import 'package:the_endodontist_app/screens/clients/prodview_client.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:new2/widgets/ad_helper.dart';
import 'package:the_endodontist_app/widgets/image_carousel.dart';

// import '../database/database.dart';
import '../widgets/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/welcome';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // late BannerAd _ad;
  // bool isLoaded = false;

  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? docImage;
  String? imageLink;
  String? prodImgLink;
  File? image;
  String? patientName;
  String uid = 'tgUV8diPrJSPMEfahcC9V4zPYEv2';
  PickedFile? pickedImage;
  int? mCount;
  int? counter;
  String? docName;
  String? adminImage;
  String? cId;
  // final ImagePicker _picker = ImagePicker();
  Future getUserPic() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    // var value = double.parse(amount);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(id);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        if (mounted) {
          setState(() {
            imageLink = snapshot['Profile Image Path'];
            patientName = snapshot['User Name'];
            // print('Profile Pic : $imageLink');
          });
        }
      }
    });
    return documentReference;
  }

  // Future getProdInfo() async {
  //   String uid = 'tgUV8diPrJSPMEfahcC9V4zPYEv2';
  //   // var value = double.parse(amount);
  //   String? prodId;
  //   DocumentReference documentReference = FirebaseFirestore.instance
  //       .collection('Recommended Products')
  //       .doc(uid)
  //       .collection('Product Id')
  //       .doc(prodId);
  //   FirebaseFirestore.instance.runTransaction((transaction) async {
  //     DocumentSnapshot snapshot = await transaction.get(documentReference);
  //     if (snapshot.exists) {
  //       if (mounted) {
  //         setState(() {
  //           prodImgLink = snapshot['Produc Image Path'];
  //         });
  //       }
  //     }
  //   });
  //   return documentReference;
  // }

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

  Future getPosts() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('Doctors List').get();
    return qn.docs;
  }

  Future getFeedbacks() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('Feedback').get();
    return qn.docs;
  }

  // Future getUserInfo() async {
  //   String uid = FirebaseAuth.instance.currentUser!.uid;
  //   DocumentReference documentReference =
  //       FirebaseFirestore.instance.collection('Users').doc(uid);
  //   FirebaseFirestore.instance.runTransaction((transaction) async {
  //     DocumentSnapshot snapshot = await transaction.get(documentReference);
  //     if (snapshot.exists) {
  //       setState(() {
  //         patientName = snapshot['User Name'];
  //         // print(patientName);
  //       });
  //     }
  //   });
  //   return documentReference;
  // }

  Future getDocInfo() async {
    String uid = 'tgUV8diPrJSPMEfahcC9V4zPYEv2';
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        setState(() {
          docName = snapshot['User Name'];
          adminImage = snapshot['Profile Image Path'];
          // print(docName);
        });
      }
    });
    return documentReference;
  }

  // String chatId(String? user1, String? user2) {
  //   // print('1st User: $user1');
  //   // print('2nd User: $user2');

  //   if (user1 != null && user2 != null) {
  //     if (user1[0].toLowerCase().codeUnits[0] >
  //         user2.toLowerCase().codeUnits[0]) {
  //       return '$user1->$user2';
  //     } else {
  //       return '$user2->$user1';
  //     }
  //   } else {
  //     return 'Enter User Names';
  //   }
  // }

  // void _markAsRead(cId, docName) {
  //   FirebaseFirestore.instance
  //       .collection('Chat Room')
  //       .doc(cId)
  //       .collection('Chats')
  //       .where('sentBy', isEqualTo: docName)
  //       .where('Message Read', isEqualTo: false)
  //       .get()
  //       .then((docSnap) {
  //     if (docSnap.docs.length > 0) {
  //       for (DocumentSnapshot doc in docSnap.docs) {
  //         doc.reference.update({'Message Read': true});
  //       }
  //     }
  //   });
  // }

  // int? displayCount(docName, cId) {
  //   int? msgCount;
  //   //  cId = chatId(dName, patName);
  //   var mcounter = FirebaseFirestore.instance
  //       .collection('Chat Room')
  //       .doc(cId)
  //       .collection('Chats')
  //       .where('sentBy', isEqualTo: docName)
  //       .where('Message Read', isEqualTo: false)
  //       .get()
  //       .then((docSnap) {
  //     if (mounted) {
  //       setState(() {
  //         msgCount = docSnap.docs.length;
  //         mCount = msgCount!;
  //         // print(mCount);
  //       });
  //     }
  //   });
  //   return mCount;
  // }

  @override
  void initState() {
    super.initState();
    getUserPic();
    getDocInfo();
    // getProdInfo();
  }
  //  _ad = BannerAd(
  //   adUnitId: AdHelper.bannerAdUnitId,
  //   request: AdRequest(),
  //   size: AdSize.banner,
  //   listener: BannerAdListener(
  //     // Called when an ad is successfully received.
  //     onAdLoaded: (_) {
  //       setState(() {
  //         isLoaded = true;
  //       });
  //     },
  //     // Called when an ad request failed.
  //     onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //       // Dispose the ad here to free resources.
  //       // ad.dispose();
  //       print('Ad failed to load: $error');
  //     },
  //     // Called when an ad opens an overlay that covers the screen.
  //     onAdOpened: (Ad ad) => print('Ad opened.'),
  //     // Called when an ad removes an overlay that covers the screen.
  //     onAdClosed: (Ad ad) => print('Ad closed.'),
  //     // Called when an impression occurs on the ad.
  //     onAdImpression: (Ad ad) => print('Ad impression.'),
  //   ),
  // );
  // _ad.load();
  // _firebaseMessaging.getToken().then((token) {
  //   print(token);
  //   updateToken(token);
  // });

  /// Gives message when app is closed and opens app on tapping the message
  // FirebaseMessaging.instance.getInitialMessage().then((message) {
  //   if (message != null) {
  //     final routeFromMessage = message.data['route'];
  //     Navigator.of(context).pushNamed(routeFromMessage);
  //   }
  // });

  // This function works only when the App is in foreground
  // FirebaseMessaging.onMessage.listen((message) {
  //   if (message.notification != null) {
  //     print(message.notification!.body);
  //     print(message.notification!.title);
  //   }
  // });

  // // This function works when app is in background but opened - on tapping the messge Navigates to the routeName given in message
  // FirebaseMessaging.onMessageOpenedApp.listen((message) {
  //   final routeFromMessage = message.data['route'];

  //   // print(routeFromMessage);
  //   Navigator.of(context).pushNamed(routeFromMessage);
  // });

  // OLD FIREASE MESSAGING CODE --- NOT IN USE IN NEW2
  // _firebaseMessaging.configure(
  //   onResume: (message) async {
  //     print('onResume: $message');

  //     final snackBar = SnackBar(
  //       content: Text(message['notification']['title']),
  //       action: SnackBarAction(
  //         label: 'Go',
  //         onPressed: () {},
  //       ),
  //     );
  //     Scaffold.of(context).showSnackBar(snackBar);
  //   },
  //   onMessage: (message) async {
  //     print('onMessage: $message');
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         content: ListTile(
  //           title: Text(message['notification']['title']),
  //           subtitle: Text(message['notification']['body']),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );
  //     final snackBar = SnackBar(
  //       content: Text(message['notification']['title']),
  //       action: SnackBarAction(
  //         label: 'Go',
  //         onPressed: () {},
  //       ),
  //     );
  //     Scaffold.of(context).showSnackBar(snackBar);
  //   },
  //   onLaunch: (message) async {
  //     print('onLaunch: $message');

  //     final snackBar = SnackBar(
  //       backgroundColor: Colors.blueGrey,
  //       content: Text(message['notification']['title']),
  //       action: SnackBarAction(
  //         label: 'Go',
  //         onPressed: () {},
  //       ),
  //     );
  //     Scaffold.of(context).showSnackBar(snackBar);
  //   },
  // );

  // _firebaseMessaging.configure();

  // _firebaseMessaging.configure();

  // @override
  // void dispose() {
  //   _ad.dispose();
  //   super.dispose();
  // }

  // Widget checkForAd() {
  //   if (isLoaded == true) {
  //     return Container(
  //       child: AdWidget(ad: _ad),
  //       width: _ad.size.width.toDouble(),
  //       alignment: Alignment.center,
  //     );
  //   } else {
  //     return CircularProgressIndicator();
  //   }
  // }

  openUrl() async {
    if (await canLaunch(
        'https://www.google.com/maps/dir//Dr.Ajit+GEORGE+Mohan/@25.2539089,51.4532141,12z/data=!4m8!4m7!1m0!1m5!1m1!1s0x3e45d99372cda0bb:0x1bde277121397937!2m2!1d51.5232544!2d25.2539254')) {
      await launch(
          'https://www.google.com/maps/dir//Dr.Ajit+GEORGE+Mohan/@25.2539089,51.4532141,12z/data=!4m8!4m7!1m0!1m5!1m1!1s0x3e45d99372cda0bb:0x1bde277121397937!2m2!1d51.5232544!2d25.2539254');
    } else {
      throw 'Oops...';
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

  navigateToDetail(DocumentSnapshot? post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProdViewClient(
                  post: post,
                )));
  }

  @override
  Widget build(BuildContext context) {
    cId = chatId(docName, patientName);
    counter = displayCount(docName, cId);
    // final const url = https://www.google.com/maps/dir//Dr.Ajit+GEORGE+Mohan/@25.2539089,51.4532141,12z/data=!3m1!4b1!4m8!4m7!1m0!1m5!1m1!1s0x3e45d99372cda0bb:0x1bde277121397937!2m2!1d51.5232544!2d25.2539254;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
               child: Text('Welcome $patientName...'),
            ),
            SizedBox(
              width: 8,
            ),
            imageLink != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(imageLink!),
                  )
                : CircleAvatar(),
            // counter != 0
            //     ? Container(
            //         width: 60,
            //         child: CircleAvatar(
            //           radius: 15,
            //           backgroundColor: Colors.black,
            //           child: Text(
            //             '$counter',
            //             style: TextStyle(
            //               fontSize: 23,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.green,
            //             ),
            //           ),
            //         ),
            //       )
            //     : Container(
            //         width: 60,
            //       ),
          ],
        ),
        // title: Text(
        //   'Dentista',
        // ),
      ),
      drawer: AppDrawer(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3.5,
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
                              prodImgLink =
                                  document['Product Image Path'].toString();
                              return Container(
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(10),
                                  // ),
                                  width:
                                      MediaQuery.of(context).size.width * .80,
                                  height: MediaQuery.of(context).size.height,
                                  child: Card(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                'Recommended Products',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          prodImgLink != null
                                              ? CircleAvatar(
                                                  radius: 39,
                                                  backgroundImage: NetworkImage(
                                                      prodImgLink!),
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
                                          // Padding(
                                          //   padding: const EdgeInsets.all(8.0),
                                          //   child: Text(
                                          //       "Total Patients Treated : ${document['Patients Treated']}"),
                                          // ),
                                          TextButton(
                                            onPressed: () {
                                              navigateToDetail(document);
                                              // print('Image Link: $prodImgLink');
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
            SizedBox(
              height: 29,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image: DecorationImage(
                    image: NetworkImage(adminImage!),
                    // AssetImage('assets/images/Ajit1.png'),
                    fit: BoxFit.cover),
              ),
              height: 300,
              width: 300,
            ),

            SizedBox(
              height: 25,
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
                  height: 25,
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
            SizedBox(
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      tooltip: 'Call',
                      icon: Icon(Icons.phone_callback),
                      onPressed:
                          _phoneCall,
                      //     () {
                      //   // Navigator.of(context)
                      //   //     .pushReplacementNamed(PhoneCall.routeName);
                      // }
                      ),
                  SizedBox(width: 2),
                  IconButton(
                    tooltip: 'Contact Details',
                    icon: Icon(Icons.contact_page_sharp),
                    onPressed: () {
                      _contactModalBottomSheet(context);
                    },
                  ),
                  SizedBox(width: 2),
                  Stack(
                    children: [
                      IconButton(
                        tooltip: 'Notifications',
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
                    tooltip: 'Take Me to Dr. George',
                    hoverColor: Colors.red,
                    icon: Icon(
                      Icons.location_pin,
                      semanticLabel: 'Take Me to Dr. George',
                    ),
                    onPressed: openUrl,
                  ),
                ],
              ),
            ),
            // ImageCarousel(),
            // Padding(
            //   padding: const EdgeInsets.all(18.0),
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     height: MediaQuery.of(context).size.height / 4,
            //     decoration: BoxDecoration(
            //       border: Border.all(
            //         color: Colors.black,
            //         style: BorderStyle.solid,
            //         width: 1.0,
            //       ),
            //       borderRadius: BorderRadius.circular(12),
            //       color: Colors.teal[100],
            //     ),
            //     child: Padding(
            //         padding: const EdgeInsets.all(12.0),
            //         child: Center(
            //             child: StreamBuilder(
            //                 stream: FirebaseFirestore.instance
            //                     .collection('Feedback')
            //                     .snapshots(),
            //                 builder: (BuildContext context,
            //                     AsyncSnapshot<QuerySnapshot> snapshot) {
            //                   if (!snapshot.hasData) {
            //                     return Center(
            //                       child: CircularProgressIndicator(),
            //                     );
            //                   }
            //                   return ListView.builder(
            //                       itemCount: snapshot.data!.docs.length,
            //                       itemBuilder: (_, index) {
            //                         return ListTile(
            //                             title: Card(
            //                                 color: Colors.white,
            //                                 elevation: 5,
            //                                 child: Column(
            //                                   children: [
            //                                     Padding(
            //                                       padding:
            //                                           const EdgeInsets.all(8),
            //                                       child: Text(
            //                                           "${snapshot.data!.docs[index]['User Name']}: ${snapshot.data!.docs[index]['Testimonial']}"),
            //                                     )
            //                                   ],
            //                                 )));
            //                       });
            //                 }))),
            //   ),
            // ),
          ]),
        ),
      ),
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
