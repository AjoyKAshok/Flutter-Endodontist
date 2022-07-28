import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/screens/doctors/show_diagnostics.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ShowDetails extends StatefulWidget {
  final DocumentSnapshot? post;

  ShowDetails({
    this.post,
  });
  @override
  _ShowDetailsState createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowDetails> {
  File? image;
  PickedFile? pickedImage;
  String? imageLink;

  final TextEditingController _userName = TextEditingController();
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();
  final TextEditingController _userAddress = TextEditingController();
  final TextEditingController _residingCity = TextEditingController();

  Future getUserPic() async {
    String? uid = widget.post!['User Id'];
    // var value = double.parse(amount);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
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

  Future getUserInfoFromUser() async {
    String? uid = widget.post!['User Id'];
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        _userName.text = snapshot['User Name'];
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
        // _userName.text = snapshot['User Name'];
        _emailField.text = snapshot['Email'];
        _mobileNumber.text = snapshot['Mobile Number'];
        _userAddress.text = snapshot['Home Address'];
        _residingCity.text = snapshot['Residing City'];
        // _userId = snapshot['User Id'];
      }
    });
    return documentReference;
  }

  @override
  void initState() {
    super.initState();
    getUserInfoFromUser();
    getUserInfo();
    getUserPic();
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
                          
                          // _listDetailsModalSheet(context);
                         
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowDiagnostics(
                                uid: uid,
                              ),
                            ),
                          );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${_userName.text}",
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
