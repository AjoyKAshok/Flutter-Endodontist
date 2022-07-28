// import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  late String userName;
  late String mobileNumber;
  late String email;
  late String residingCity;
  late String profilePic;
  late String patientId;

  Client(
    this.userName,
    this.mobileNumber,
    this.email,
    this.residingCity,
    this.profilePic,
    this.patientId,
  );
  Client.fromSnapshot(DocumentSnapshot snapshot)
      : userName = snapshot['User Name'],
        mobileNumber = snapshot['Mobile Number'],
        email = snapshot['Email'],
        residingCity = snapshot['Residing City'],
        patientId = snapshot['User Id'],
        profilePic = snapshot['Profile Image Path'];
}

class Patient {
  late String userName;
  // late String mobileNumber;
  // late String email;
  // late String residingCity;
  late String profilePic;
  late String patientId;

  Patient(
    this.userName,
    // this.mobileNumber,
    // this.email,
    // this.residingCity,
    this.profilePic,
    this.patientId,
  );
  Patient.fromSnapshot(DocumentSnapshot snapshot)
      : userName = snapshot['User Name'],
  // mobileNumber = snapshot['Mobile Number'],
  // email = snapshot['Email'],
  // residingCity = snapshot['Residing City'],
  profilePic = snapshot['Profile Image Path'],
  patientId = snapshot['User Id'];
}
