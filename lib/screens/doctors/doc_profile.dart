import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_endodontist_app/database/database.dart';
import 'package:the_endodontist_app/widgets/doc_app_drawer.dart';

class DocProfile extends StatefulWidget {
  final String? userid;
  DocProfile({this.userid});
  static const routeName = '/doctor_profile_page';
  @override
  _DocProfileState createState() => _DocProfileState();
}

class _DocProfileState extends State<DocProfile> {
   String? uid;
  @override
  void initState() {
    
    super.initState();
    getUserPic();
    getUserInfo();
  }

  // PickedFile _imageFile;
  File? image;
  PickedFile? pickedImage;
  final ImagePicker _picker = ImagePicker();
  String? imageLink;

  final TextEditingController _userName = TextEditingController();
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();

  Future getUserInfo() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Doctors List').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        _userName.text = snapshot['Doctor Name'];
        _emailField.text = snapshot['Doctor Email'];
        _mobileNumber.text = snapshot['Doctor Mobile'];
      }
    });
    return documentReference;
  }

  Future getUserPic() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
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
        // The below mentioned code is to enable edit pic feature....
        Positioned(
          child: InkWell(
            child: Icon(
              Icons.camera_alt_sharp,
              color: Colors.greenAccent,
              size: 25,
            ),
            onTap: () {
              showModalBottomSheet(
                  context: context, builder: ((builder) => bottomSheet()));
            },
          ),
          bottom: 20,
          right: 20,
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            'Select Your Profile Image',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.camera),
                label: Text('Camera'),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.photo_library_sharp,
                ),
                label: Text('Gallery'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedImage = await (_picker.getImage(
      source: source,
    ) as Future<PickedFile>);
    FirebaseStorage fs = FirebaseStorage.instance;

    Reference rootRef = fs.ref();

    Reference picFolder = rootRef
        .child("Profile Pics")
        .child("image" + DateTime.now().toString());

    picFolder.putFile(File(pickedImage.path)).then(
      (storageTask) async {
        String link = await storageTask.ref.getDownloadURL();
        setState(() {
          imageLink = link;
          updateDoctorPic(imageLink, uid);
        });
      },
    );
    // setState(() {
    //   _imageFile = pickedFile;
    //   // UploadImage(_imageFile);
    //   FirebaseStorage fs = FirebaseStorage.instance;

    //   Reference rootRef = fs.ref();

    //   Reference picFolder = rootRef
    //       .child("Profile Pics")
    //       .child("image" + DateTime.now().toString());

    //   picFolder.putFile(File(_imageFile.path)).then((storageTask) async {
    //     String link = await storageTask.ref.getDownloadURL();
    //     imageLink = link;
    //   });
    // });
  }

  Widget doctorProfile() {
    return Container(
      child: Card(
        child: SingleChildScrollView(
          child: Column(
            children: [
              profileImage(),
              buildDisplayNameField(),
              buildMobileNumberField(),
              buildEmailField(),
              // Text(imageLink),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.purple,
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    await updateDoctorsList(_userName.text, _mobileNumber.text,
                        _emailField.text, uid);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Update Doctor Details',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
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
        title: Text('Doctor Profile'),
      ),
      drawer: DocAppDrawer(),
      body: doctorProfile(),
    );
  }
}
