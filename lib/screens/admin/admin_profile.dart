import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/database/database.dart';
import 'package:the_endodontist_app/screens/dashboard.dart';
import 'package:the_endodontist_app/widgets/admin_app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminProfile extends StatefulWidget {
  static const routeName = '/admin-profile';
  const AdminProfile({Key? key}) : super(key: key);

  @override
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  String? imageLink;
  File? image;
  PickedFile? pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future getUserPic() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    // print(uid);
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

  Future getUserInfo() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    // print(uid);
    // var value = double.parse(amount);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Admin Profile').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        _userName.text = snapshot['User Name'];
        _mobileNumber.text = snapshot['Mobile Number'];
        _emailField.text = snapshot['Email'];
        _userAddress.text = snapshot['Home Address'];
        _residingCity.text = snapshot['Residing City'];
        _experienceInYears.text = snapshot['Experience in Years'];
        _patientCount.text = snapshot['Patients Treated'];
        _titlesHeld.text = snapshot['Titles Held'];
        _awardsRecognitions.text = snapshot['Awards & Recognitions'];
        _qualifications.text = snapshot['Academic Qualifications'];
        // print(snapshot['User Name']);
        // _allergies.text = snapshot['Allergies'];
        // _medicalConditions.text = snapshot['Medical Conditions'];
        // _healthProviders.text = snapshot['Health Providers'];

      }
    });
    return documentReference;
  }

  @override
  void initState() {
    getUserPic();
    getUserInfo();

    super.initState();
  }

  final TextEditingController _emailField = TextEditingController();

  final TextEditingController _userName = TextEditingController();

  final TextEditingController _mobileNumber = TextEditingController();

  final TextEditingController _userAddress = TextEditingController();

  final TextEditingController _residingCity = TextEditingController();
  final TextEditingController _experienceInYears = TextEditingController();
  final TextEditingController _patientCount = TextEditingController();
  final TextEditingController _titlesHeld = TextEditingController();
  final TextEditingController _awardsRecognitions = TextEditingController();
  final TextEditingController _qualifications = TextEditingController();
  final TextEditingController _notificationTitle = TextEditingController();
  final TextEditingController _notificationContent = TextEditingController();

  // final TextEditingController _allergies = TextEditingController();

  // final TextEditingController _medicalConditions = TextEditingController();

  // final TextEditingController _healthProviders = TextEditingController();
  String _userRole = 'Admin';

  DateTime date = DateTime.now();

  final TextEditingController dateController = TextEditingController();

  final TextEditingController detailController = TextEditingController();

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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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

  Column buildQualificationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Qualifications, Positions Held & Recognitions",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: _qualifications,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintText: "Academic Qualifications",
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Occupation",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: _awardsRecognitions,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintText: "Awards & Recognitions",
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Current Title",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: _titlesHeld,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintText: "Titles Held",
          ),
        )
      ],
    );
  }

  Column buildExperienceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Experience Snapshot",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: _experienceInYears,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintText: "Years of Experience",
          ),
        ),
        // Divider(),
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Patient Count",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: _patientCount,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintText: "Number of Patients Treated:",
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
    ) as Future<PickedFile?>);
    FirebaseStorage fs = FirebaseStorage.instance;

    Reference rootRef = fs.ref();

    Reference picFolder = rootRef
        .child("Profile Pics")
        .child("image" + DateTime.now().toString());

    picFolder.putFile(File(pickedImage!.path)).then(
      (storageTask) async {
        String link = await storageTask.ref.getDownloadURL();
        setState(() {
          imageLink = link;
          // print(imageLink);
          updateProfilePic(imageLink);
        });
      },
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

  // Column buildAlerts() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Text(
  //         'ALERTS',
  //         style: TextStyle(
  //           color: Colors.black,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       Padding(
  //           padding: EdgeInsets.only(top: 12.0),
  //           child: Text(
  //             "Allergies",
  //             style: TextStyle(color: Colors.black),
  //           )),
  //       TextField(
  //         maxLines: 4,
  //         controller: _allergies,
  //         decoration: InputDecoration(
  //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //           hintText: "Enter Allergies",
  //         ),
  //       ),
  //       Padding(
  //           padding: EdgeInsets.only(top: 12.0),
  //           child: Text(
  //             "Medical Conditions",
  //             style: TextStyle(color: Colors.black),
  //           )),
  //       TextField(
  //         maxLines: 4,
  //         controller: _medicalConditions,
  //         decoration: InputDecoration(
  //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //           hintText: "Enter Other Existing Medical Conditions",
  //         ),
  //       ),
  //       Padding(
  //           padding: EdgeInsets.only(top: 12.0),
  //           child: Text(
  //             "Health Providers",
  //             style: TextStyle(color: Colors.black),
  //           )),
  //       TextField(
  //         maxLines: 4,
  //         controller: _healthProviders,
  //         decoration: InputDecoration(
  //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //           hintText: "Enter Details of Other Health Providers",
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('My Profile'),
            // CircleAvatar(
            //   backgroundColor: Colors.white,
            //   child: Text('AJ'),
            // ),
          ],
        ),
      ),
      drawer: AdminAppDrawer(),
      body: Container(
        child: FutureBuilder(
            future: getUserInfo(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        profileImage(),
                        // AdmobBanner(adUnitId: ams.getBannerAdId(), adSize: AdmobBannerSize.FULL_BANNER,),
                        buildDisplayNameField(),
                        buildMobileNumberField(),
                        buildEmailField(),
                        buildAddressField(),
                        buildCityField(),
                        buildQualificationField(),
                        buildExperienceField(),
                        // Divider(
                        //   thickness: 3,
                        //   color: Colors.black,
                        // ),
                        // // AdmobBanner(adUnitId: ams.getBannerAdId(), adSize: AdmobBannerSize.FULL_BANNER,),
                        // buildAlerts(),
                        // Divider(
                        //   thickness: 3,
                        //   color: Colors.black,
                        // ),

                        SizedBox(
                          height: 18,
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
                              await updateAdminProfile(
                                _userName.text,
                                _emailField.text,
                                _mobileNumber.text,
                                _userAddress.text,
                                _residingCity.text,
                                _userRole,
                                _experienceInYears.text,
                                _patientCount.text,
                                _qualifications.text,
                                _titlesHeld.text,
                                _awardsRecognitions.text,
                                // _allergies.text,
                                // _medicalConditions.text,
                                // _healthProviders.text,
                              );
                              Navigator.of(context).pushReplacementNamed(
                                  DashBoardPage.routeName);
                              // SystemNavigator.pop();
                            },
                            child: Text(
                              'Update Profile Details',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
