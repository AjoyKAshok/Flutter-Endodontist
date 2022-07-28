import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/screens/doctors/show_diagnostics.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:the_endodontist_app/database/database.dart';
import 'package:the_endodontist_app/screens/doctors/diagnostic_detail.dart';

class DetailsPage extends StatefulWidget {
  final DocumentSnapshot? post;
  // final String id;
  DetailsPage({
    this.post,
  });
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  // PickedFile _imageFile;
  File? image;
  PickedFile? pickedImage;

  // final ImagePicker _picker = ImagePicker();
  String? imageLink;
  Future getDetails() async {
    String? uid = widget.post!['User Id'];
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection('Diaganostic Detail')
        .doc(uid)
        .collection('Created On')
        .get();
    return qn.docs;
  }

  Future getUserInfoFromUser() async {
    String? uid = widget.post!['User Id'];
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        setState(() {   
        _userName1.text = snapshot['User Name'];
        });
      }
    });
    return documentReference;
  }

  Future getUserInfo() async {
    String? uid = widget.post!['User Id'];
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Client Profile').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        setState(() {   
        _userName.text = snapshot['User Name'];
        _emailField.text = snapshot['Email'];
        _mobileNumber.text = snapshot['Mobile Number'];
        _userAddress.text = snapshot['Home Address'];
        _residingCity.text = snapshot['Residing City'];
        _userId = snapshot['User Id'];
        });
      }
    });
    return documentReference;
  }

  final TextEditingController _userName1 = TextEditingController();
  // final TextEditingController _userId1 = TextEditingController();

  

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

  navigateToDiaganosticDetail(DocumentSnapshot? post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DiagnosticDetail(
                  post: post,
                )));
  }

  final TextEditingController _userName = TextEditingController();
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();
  final TextEditingController _userAddress = TextEditingController();
  final TextEditingController _residingCity = TextEditingController();
  // final TextEditingController _description = TextEditingController();
  String? isAdmin;

  String? _userId;

  @override
  void initState() {
    super.initState();
    String? uid = widget.post!['User Id'];
    getUserInfoFromUser();
    getUserInfo();
    getUserPic();
    // getUserRole();
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Display Name",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: _userName,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintText: "Update Display Name",
          ),
        )
      ],
    );
  }

  Column buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Email Id",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: _emailField,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintText: "Update Email Id",
          ),
        )
      ],
    );
  }

  Column buildMobileNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Mobile Number",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: _mobileNumber,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintText: "Update Mobile Number",
          ),
        )
      ],
    );
  }

  Column buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Home Address",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: _userAddress,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintText: "Update Home Address",
          ),
        )
      ],
    );
  }

  Column buildCityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Residing City",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: _residingCity,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintText: "Update Residing City",
          ),
        )
      ],
    );
  }

  Widget profileImage() {
    return Stack(
      children: [
        imageLink != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(
                  imageLink!,
                ),
                radius: 60,
              )
            : CircleAvatar(
                child: ClipOval(
                  child: Icon(
                    Icons.person,
                    size: 60,
                  ),
                ),
                radius: 60,
              ),
      ],
    );
  }

  Widget basicProfileInfo() {
    String? uid = widget.post!['User Id'];
    return Container(
      child: Card(
        child: SingleChildScrollView(
          child: Column(
            children: [
              profileImage(),
              buildDisplayNameField(),
              buildMobileNumberField(),
              buildEmailField(),
              buildAddressField(),
              buildCityField(),
              // buildDescriptionField(),
              SizedBox(
                height: 18,
              ),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.purple,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // print(uid);
                          // _listDetailsModalSheet(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowDiagnostics(
                                        uid: uid,
                                      )));
                        },
                        child: Text(
                          'Show Diaganostic Details',
                          style: TextStyle(color: Colors.white),
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
    );
  }

  // void _addDetailsModalSheet(context) {
  //   DateTime date = DateTime.now();
  //   TimeOfDay time = TimeOfDay.now();
  //   String selectedDateTime;
  //   String selectedTimeDate;
  //   String? pickedDateAndTime;
  //   final TextEditingController dateController = TextEditingController();
  //   final TextEditingController timeController = TextEditingController();
  //   final TextEditingController detailController = TextEditingController();
  //   // ignore: unnecessary_statements
  //   Future<Null> selectDatePicker(BuildContext context) async {
  //     final DateTime? pickedDate = await showDatePicker(
  //       context: context,
  //       initialDate: date,
  //       firstDate: DateTime(1900),
  //       lastDate: DateTime(2220),
  //     );
  //     if (pickedDate != null && pickedDate != date) {
  //       setState(() {
  //         date = pickedDate;
  //         selectedDateTime = "${date.year} : ${date.month} : ${date.day}";
  //         dateController.text = selectedDateTime;
  //         // print(selectedDateTime);
  //       });
  //     }
  //   }

  //   Future<Null> selectTime(BuildContext context) async {
  //     final TimeOfDay? pickedTime =
  //         await showTimePicker(context: context, initialTime: time);
  //     if (pickedTime != null) {
  //       setState(() {
  //         time = pickedTime;
  //         selectedTimeDate = "${time.hour} : ${time.minute}";
  //         timeController.text = selectedTimeDate;
  //         // print(selectedTimeDate);
  //         pickedDateAndTime = "${dateController.text} - ${timeController.text}";
  //       });
  //     }
  //   }

  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext ctx) {
  //         return SingleChildScrollView(
  //           child: Container(
  //             height: MediaQuery.of(context).size.height * 0.85,
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     // mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(
  //                         "${widget.post!['User Name']}",
  //                         style: TextStyle(
  //                           fontSize: 25,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       Spacer(),
  //                       IconButton(
  //                           icon: Icon(
  //                             Icons.save_sharp,
  //                             color: Colors.green,
  //                             size: 18,
  //                           ),
  //                           onPressed: () async {
  //                             await updateDetail(
  //                               _userName.text,
  //                               _userId,
  //                               detailController.text,
  //                               pickedDateAndTime,
  //                             );

  //                             Navigator.of(context).pop();
  //                             // print(_userId);
  //                           }),
  //                       Spacer(),
  //                       IconButton(
  //                           icon: Icon(
  //                             Icons.cancel,
  //                             color: Colors.red,
  //                             size: 18,
  //                           ),
  //                           onPressed: () {
  //                             Navigator.of(context).pop();
  //                           }),
  //                     ],
  //                   ),
  //                   Divider(),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       Text('Select Date'),
  //                       IconButton(
  //                         icon: Icon(Icons.calendar_today_sharp),
  //                         onPressed: () {
  //                           selectDatePicker(context);
  //                         },
  //                       ),
  //                       Expanded(
  //                         child: TextField(
  //                           controller: dateController,
  //                           decoration: InputDecoration(
  //                             enabledBorder: OutlineInputBorder(
  //                               borderRadius: BorderRadius.circular(12),
  //                               borderSide: BorderSide(
  //                                 color: Colors.blueGrey,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Divider(),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       Text('Select Time'),
  //                       IconButton(
  //                         icon: Icon(Icons.timer_outlined),
  //                         onPressed: () {
  //                           selectTime(context);
  //                         },
  //                       ),
  //                       Expanded(
  //                         child: TextField(
  //                           controller: timeController,
  //                           decoration: InputDecoration(
  //                             enabledBorder: OutlineInputBorder(
  //                               borderRadius: BorderRadius.circular(12),
  //                               borderSide: BorderSide(
  //                                 color: Colors.blueGrey,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     height: 12,
  //                   ),
  //                   TextFormField(
  //                     controller: detailController,
  //                     maxLines: 15,
  //                     decoration: InputDecoration(
  //                       enabledBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                         borderSide: BorderSide(
  //                           color: Colors.purpleAccent,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

  // void _listDetailsModalSheet(context) {
  //   DateTime date = DateTime.now();
  //   TimeOfDay time = TimeOfDay.now();
  //   final TextEditingController dateController = TextEditingController();
  //   final TextEditingController timeController = TextEditingController();
  //   // final TextEditingController detailController = TextEditingController();
  //   // ignore: unnecessary_statements
  //   Future<Null> selectDatePicker(BuildContext context) async {
  //     final DateTime? pickedDate = await showDatePicker(
  //       context: context,
  //       initialDate: date,
  //       firstDate: DateTime(1900),
  //       lastDate: DateTime(2220),
  //     );
  //     if (pickedDate != null && pickedDate != date) {
  //       setState(() {
  //         date = pickedDate;
  //         dateController.text = date.toString();
  //       });
  //     }
  //   }

  //   Future<Null> selectTime(BuildContext context) async {
  //     final TimeOfDay? pickedTime =
  //         await showTimePicker(context: context, initialTime: time);
  //     if (pickedTime != null && pickedTime != time) {
  //       setState(() {
  //         time = pickedTime;
  //         timeController.text = date.toString();
  //       });
  //     }
  //   }

  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext ctx) {
  //         return Container(
  //           height: MediaQuery.of(context).size.height * 0.90,
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Column(
  //               children: [
  //                 Row(
  //                   // mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Expanded(
  //                       child: Text(
  //                         "${'Diaganostic Details of -'} ${widget.post!['User Name']}",
  //                         style: TextStyle(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: 10,
  //                     ),

  //                     SizedBox(
  //                       width: 10,
  //                     ),
  //                     IconButton(
  //                         icon: Icon(
  //                           Icons.cancel,
  //                           color: Colors.red,
  //                           size: 18,
  //                         ),
  //                         onPressed: () {
  //                           Navigator.of(context).pop();
  //                         }),
  //                   ],
  //                 ),
  //                 Divider(
  //                   thickness: 5,
  //                 ),
  //                 SingleChildScrollView(
  //                   child: Column(
  //                     children: [
  //                       Container(
  //                         height: MediaQuery.of(context).size.height / 3,
  //                         child: FutureBuilder(
  //                           future: getDetails(),
  //                           builder:
  //                               (BuildContext context, AsyncSnapshot snapshot) {
  //                             if (!snapshot.hasData) {
  //                               return Center(
  //                                 child: CircularProgressIndicator(),
  //                               );
  //                             } else {
  //                               return ListView.builder(
  //                                   itemCount: snapshot.data.length,
  //                                   itemBuilder: (_, index) {
  //                                     return ListTile(
  //                                       title:
  //                                           Text(snapshot.data[index]['Date']),
  //                                       onTap: () =>
  //                                           navigateToDiaganosticDetail(
  //                                               snapshot.data[index]),
  //                                     );
  //                                   });
  //                             }
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

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
              
              // "${widget.post!['User Name']}",
              "${_userName1.text}",
            ),
            Spacer(),
            imageLink != null
                ? CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(imageLink!),
                  )
                : CircleAvatar(),
          ],
        ),
      ),
      body: basicProfileInfo(),
    );
  }
}
