import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _googleSignIn = GoogleSignIn();
FirebaseAuth auth = FirebaseAuth.instance;

// GoogleSignIn googleSignIn = GoogleSignIn(
//   // Optional clientId
//   // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
//   scopes: <String>[
//     'email',
//     'https://www.googleapis.com/auth/contacts.readonly',
//   ],
// );

Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> register(String email, String password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    var name = FirebaseAuth.instance.currentUser!.displayName;
    FirebaseAuth.instance.currentUser!.updateDisplayName(name);

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'User Name': name,
      'Email': email,
    });

    var userName = FirebaseAuth.instance.currentUser!.displayName;
    FirebaseAuth.instance.currentUser!.updateDisplayName(userName);

    await FirebaseFirestore.instance
        .collection('Client Profile')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'User Name': userName,
      'Email': email,
    });
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password is too weak');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for this email');
    }
    return false;
  } catch (e) {
    print(e.toString);
    return false;
  }
}

Future<bool> googleSignIn() async {
  GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

  if (googleSignInAccount != null) {
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result = await auth.signInWithCredential(credential);

    User user = auth.currentUser!;

    var name = user.displayName;
    var email = user.email;
    var profileImage = user.photoURL;
    var uid = user.uid;
    var _registeredOn = Timestamp.now();
    var _isAdmin = 'Client';

    DocumentReference docRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot ds = await transaction.get(docRef);
      if (!ds.exists) {
        docRef.set({
          'User Name': name,
          'Email': email,
          'Profile Image Path': profileImage,
          'Role': _isAdmin,
          'Registered On': _registeredOn,
          'User Id': uid,
        });
      }
    });

    DocumentReference docRef1 = FirebaseFirestore.instance
        .collection('Client Profile')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot ds1 = await transaction.get(docRef1);
      if (!ds1.exists) {
        docRef.set({
          'User Name': name,
          'Email': email,
          'Profile Image Path': profileImage,
          'User Id': uid,
        });
      }
    });
  }
  return Future.value(true);
}

Future<bool> updateProfilePic(String? link) async {
  try {
    String adminId = 'tgUV8diPrJSPMEfahcC9V4zPYEv2';
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Profile Pics').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot ds = await transaction.get(docRef);
      if (!ds.exists) {
        docRef.set({
          'Profile Image Path': link,
          'User Id': uid,
        });
        return true;
      } else {
        docRef.update({
          'Profile Image Path': link,
          'User Id': uid,
        });
        return true;
      }
    });
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({
          'Profile Image Path': link,
        });
        return true;
      } else {
        documentReference.update({
          'Profile Image Path': link,
        });
        return true;
      }
    });
    if (adminId == uid) {
      DocumentReference dReference =
          FirebaseFirestore.instance.collection('Admin Profile').doc(uid);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(dReference);
        if (!snapshot.exists) {
          dReference.set({
            'Profile Image Path': link,
          });
          return true;
        } else {
          dReference.update({
            'Profile Image Path': link,
          });
          return true;
        }
      });
    } else {
      DocumentReference dReference =
          FirebaseFirestore.instance.collection('Client Profile').doc(uid);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(dReference);
        if (!snapshot.exists) {
          dReference.set({
            'Profile Image Path': link,
          });
          return true;
        } else {
          dReference.update({
            'Profile Image Path': link,
          });
          return true;
        }
      });
    }
    return false;
  } catch (e) {
    return false;
  }
}

Future<bool> updateRecommendedProducts(
    String? prodImage, String prodId, String prodName, String prodDesc) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('Recommended Products')
        .doc(uid)
        .collection('Product Id')
        .doc(prodId);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot ds = await transaction.get(docRef);
      if (!ds.exists) {
        docRef.set({
          'Product Image Path': prodImage,
          'Product Id': prodId,
          'Product Name': prodName,
          'Product Description': prodDesc,
          'Doc Id': uid,
        });
        return true;
      } else {
        docRef.update({
          'Product Image Path': prodImage,
          'Product Id': prodId,
          'Product Name': prodName,
          'Doc Id': uid,
        });
        return true;
      }
    });
    return false;
  } catch (e) {
    return false;
  }
}

Future<bool> deleteRecommendedProducts(
    String? prodImage, String prodId, String prodName, String prodDesc) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('Recommended Products')
        .doc(uid)
        .collection('Product Id')
        .doc(prodId);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.get(docRef);
      docRef.delete();
      return true;

      // if (!ds.exists) {

      // }
    });
    return false;
  } catch (e) {
    return false;
  }
}

Future<bool> updateDoctorPic(String? link, String? userid) async {
  try {
    String? uid = userid;
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Profile Pics').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot ds = await transaction.get(docRef);
      if (!ds.exists) {
        docRef.set({
          'Profile Image Path': link,
          'User Id': uid,
        });
        return true;
      } else {
        docRef.update({
          'Profile Image Path': link,
          'User Id': uid,
        });
        return true;
      }
    });
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({
          'Profile Image Path': link,
        });
        return true;
      } else {
        documentReference.update({
          'Profile Image Path': link,
        });
        return true;
      }
      // double newAmount = snapshot.data()['Amount'] + value;
      // transaction.update(documentReference, {'Amount': newAmount});
      // return true;
    });
    return false;
  } catch (e) {
    return false;
  }
}

Future<bool> updateProfile(String username, String email, String mobile,
    String address, String residingcity, String role) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot ds = await transaction.get(docRef);
      if (!ds.exists) {
        docRef.set({
          'Email': email,
          'Role': role,
          'User Name': username,
          'User Id': uid,
        });
        return true;
      } else {
        docRef.update({
          'Email': email,
          'Role': role,
          'User Name': username,
          'User Id': uid,
        });
        return true;
      }
    });
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Admin Profile').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({
          'User Name': username,
          'Mobile Number': mobile,
          'Email': email,
          'Home Address': address,
          'Residing City': residingcity,
          'Role': role,
          'User Id': uid,
        });
        return true;
      } else {
        documentReference.update({
          'User Name': username,
          'Mobile Number': mobile,
          'Email': email,
          'Home Address': address,
          'Residing City': residingcity,
          'Role': role,
          'User Id': uid,
        });
        return true;
      }
      // double newAmount = snapshot.data()['Amount'] + value;
      // transaction.update(documentReference, {'Amount': newAmount});
      // return true;
    });
    return false;
  } catch (e) {
    return false;
  }
}

Future<bool> updateProfiler(
    String username,
    String email,
    String mobile,
    String address,
    String residingcity,
    String role,
    String allergies,
    String medicalConditions,
    String healthProvider) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot ds = await transaction.get(docRef);
      if (!ds.exists) {
        docRef.set({
          'Email': email,
          'Role': role,
          'User Name': username,
          'User Id': uid,
          'Allergies': allergies,
          'Medical Conditions': medicalConditions,
          'Health Providers': healthProvider,
        });
        return true;
      } else {
        docRef.update({
          'Email': email,
          'Role': role,
          'User Name': username,
          'User Id': uid,
          'Allergies': allergies,
          'Medical Conditions': medicalConditions,
          'Health Providers': healthProvider,
        });
        return true;
      }
    });
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Client Profile').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({
          'User Name': username,
          'Mobile Number': mobile,
          'Email': email,
          'Home Address': address,
          'Residing City': residingcity,
          'Role': role,
          'User Id': uid,
          'Allergies': allergies,
          'Medical Conditions': medicalConditions,
          'Health Providers': healthProvider,
        });
        return true;
      } else {
        documentReference.update({
          'User Name': username,
          'Mobile Number': mobile,
          'Email': email,
          'Home Address': address,
          'Residing City': residingcity,
          'Role': role,
          'User Id': uid,
          'Allergies': allergies,
          'Medical Conditions': medicalConditions,
          'Health Providers': healthProvider,
        });
        return true;
      }
      // double newAmount = snapshot.data()['Amount'] + value;
      // transaction.update(documentReference, {'Amount': newAmount});
      // return true;
    });
    return false;
  } catch (e) {
    return false;
  }
}

Future<bool> updateAdminProfile(
    String username,
    String email,
    String mobile,
    String address,
    String residingcity,
    String userRole,
    String experience,
    String patientCount,
    String qualifications,
    String titles,
    String awards) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    // var value = double.parse(amount);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Admin Profile').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({
          'User Name': username,
          'Mobile Number': mobile,
          'Email': email,
          'Home Address': address,
          'Residing City': residingcity,
          'Role': userRole,
          'Experience in Years': experience,
          'Patients Treated': patientCount,
          'Academic Qualifications': qualifications,
          'Titles Held': titles,
          'Awards & Recognitions': awards,
          'User Id': uid,
        });
        return true;
      } else {
        documentReference.update({
          'User Name': username,
          'Mobile Number': mobile,
          'Email': email,
          'Home Address': address,
          'Residing City': residingcity,
          'Experience in Years': experience,
          'Patients Treated': patientCount,
          'Academic Qualifications': qualifications,
          'Titles Held': titles,
          'Awards & Recognitions': awards,
          'User Id': uid,
        });
        return true;
      }
      // double newAmount = snapshot.data()['Amount'] + value;
      // transaction.update(documentReference, {'Amount': newAmount});
      // return true;
    });
    return false;
  } catch (e) {
    return false;
  }
}

Future<bool> updateUserRoles(
  String? userrole,
  String? userid,
) async {
  try {
    String? uid = userid;
    // var value = double.parse(amount);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Client Profile').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      // DocumentSnapshot snapshot = await transaction.get(documentReference);
      // if (!snapshot.exists) {
      //   documentReference.set({
      //     'Role': userrole,
      //     'User Id': uid,
      //   });
      //   return true;
      // } else {
      documentReference.update({
        'Role': userrole,
        'User Id': uid,
      });
      return true;
      // }
      // double newAmount = snapshot.data()['Amount'] + value;
      // transaction.update(documentReference, {'Amount': newAmount});
      // return true;
    });
    return false;
  } catch (e) {
    return false;
  }
}

Future<bool> addToDoctorsList(
  String userrole,
  String userid,
) async {
  try {
    String uid = userid;
    // var value = double.parse(amount);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Doctors List').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({
          'Role': userrole,
          'User Id': uid,
        });
        return true;
      } else {
        documentReference.update({
          'Role': userrole,
          'User Id': uid,
        });
        return true;
      }
      // double newAmount = snapshot.data()['Amount'] + value;
      // transaction.update(documentReference, {'Amount': newAmount});
      // return true;
    });
    return false;
  } catch (e) {
    return false;
  }
}

Future<bool> updateDoctorsList(
  String doctorName,
  String doctorContact,
  String doctorEmail,
  String? userid,
) async {
  try {
    String? uid = userid;
    // var value = double.parse(amount);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Doctors List').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({
          'Doctor Name': doctorName,
          'Doctor Mobile': doctorContact,
          'Doctor Email': doctorEmail,
        });
        return true;
      } else {
        documentReference.update({
          'Doctor Name': doctorName,
          'Doctor Mobile': doctorContact,
          'Doctor Email': doctorEmail,
        });
        return true;
      }
      // double newAmount = snapshot.data()['Amount'] + value;
      // transaction.update(documentReference, {'Amount': newAmount});
      // return true;
    });
    return false;
  } catch (e) {
    return false;
  }
}

Future<bool> updateProfileRoles(
  String? userrole,
  String? userid,
) async {
  try {
    String? uid = userid;
    // var value = double.parse(amount);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      // DocumentSnapshot snapshot = await transaction.get(documentReference);
      // if (!snapshot.exists) {
      //   documentReference.set({
      //     'Role': userrole,
      //   });
      //   return true;
      // } else {
      documentReference.update({
        'Role': userrole,
      });
      return true;
      // }
      // double newAmount = snapshot.data()['Amount'] + value;
      // transaction.update(documentReference, {'Amount': newAmount});
      // return true;
    });
    return false;
  } catch (e) {
    return false;
  }
}

Future<bool> updateToken(
  String? token,
) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    // var value = double.parse(amount);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Tokens').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({
          'UserToken': token,
        });
        return true;
      } else {
        documentReference.update({
          'UserToken': token,
        });
        return true;
      }
      // double newAmount = snapshot.data()['Amount'] + value;
      // transaction.update(documentReference, {'Amount': newAmount});
      // return true;
    });
    return false;
  } catch (e) {
    return false;
  }
}

Future<bool> updateOffers(
  String notificationTitle,
  String notificationContent,
  DateTime createdOn,
) async {
  try {
    String uid = createdOn.toString();
    // String uid = FirebaseAuth.instance.currentUser.uid;
    // var value = double.parse(amount);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Offers').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({
          'NotificationTitle': notificationTitle,
          'NotificationContent': notificationContent,
          // 'Offer Id': createdOn,
        });
        return true;
      } else {
        documentReference.update({
          'Notification Title': notificationTitle,
          'Notification Content': notificationContent,
          'Offer Id': createdOn,
        });
        return true;
      }
      // double newAmount = snapshot.data()['Amount'] + value;
      // transaction.update(documentReference, {'Amount': newAmount});
      // return true;
    });
    return false;
  } catch (e) {
    return false;
  }
}

Future<bool> updateDetail(
  String username,
  String? userid,
  String description,
  String? date,
) async {
  try {
    String? uid = userid;
    // var value = double.parse(amount);
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Diaganostic Detail')
        .doc(uid)
        .collection('Created On')
        .doc(date);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({
          'User Name': username,
          'User Id': uid,
          'Description': description,
          'Date': date,
        });
        return true;
      } else {
        documentReference.update({
          'User Name': username,
          'User Id': uid,
          'Description': description,
          'Date': date,
        });
        return true;
      }
      // double newAmount = snapshot.data()['Amount'] + value;
      // transaction.update(documentReference, {'Amount': newAmount});
      // return true;
    });
    return false;
  } catch (e) {
    return false;
  }
}

Future<bool> updatePatientProfile(
    String username,
    String email,
    String mobile,
    String address,
    String residingcity,
    String userid,
    String description) async {
  try {
    String uid = userid;
    // var value = double.parse(amount);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Patient Profile').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({
          'User Name': username,
          'Mobile Number': mobile,
          'Email': email,
          'Home Address': address,
          'Residing City': residingcity,
          'User Id': uid,
          'Description': description,
        });
        return true;
      } else {
        documentReference.update({
          'User Name': username,
          'Mobile Number': mobile,
          'Email': email,
          'Home Address': address,
          'Residing City': residingcity,
          'User Id': uid,
          'Description': description,
        });
        return true;
      }
      // double newAmount = snapshot.data()['Amount'] + value;
      // transaction.update(documentReference, {'Amount': newAmount});
      // return true;
    });
    return false;
  } catch (e) {
    return false;
  }
}

Future<bool> updateUnreadCount(
  int unreadCount,
  bool isRead,
  String userid,
  String patName,
  String patPic,
) async {
  try {
    String uid = userid;
    // var value = double.parse(amount);
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Unread User Notifications')
        .doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({
          'Unread User Notification Count': unreadCount,
          'Message Read': isRead,
          'User Id': uid,
          'User Name': patName,
          'Profile Image Path': patPic,
        });
        return true;
      } else {
        documentReference.update({
          'Unread User Notification Count': unreadCount,
          'Message Read': isRead,
          'User Id': uid,
          'User Name': patName,
          'Profile Image Path': patPic,
        });
        return true;
      }
      // double newAmount = snapshot.data()['Amount'] + value;
      // transaction.update(documentReference, {'Amount': newAmount});
      // return true;
    });
    return false;
  } catch (e) {
    return false;
  }
}

Future<bool> resetUnreadCount(
  String userid,
) async {
  try {
    String uid = userid;
    // var value = double.parse(amount);
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Unread User Notifications')
        .doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({
          'Unread User Notification Count': 0,
          'Message Read': true,
          'User Id': uid,
        });
        return true;
      } else {
        documentReference.update({
          'Unread User Notification Count': 0,
          'Message Read': true,
          'User Id': uid,
        });
        return true;
      }
    });
    return false;
  } catch (e) {
    return false;
  }
}

Future<bool> removeFromUnread(
  String userid,
) async {
  try {
    String uid = userid;
    // var value = double.parse(amount);
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Unread User Notifications')
        .doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.delete();
        return true;
      }
    });
    return false;
  } catch (e) {
    return false;
  }
}

Future<bool> updateFeedback(String feedback) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String? userName;
    DateTime createdAt = DateTime.now();
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Client Profile').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot ds = await transaction.get(docRef);
      userName = ds['User Name'];
    });
    // var value = double.parse(amount);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Feedback').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({
          'Testimonial': feedback,
          'User Name': userName,
          'Testimonial Date': createdAt,
        });
        return true;
      } else {
        documentReference.update({
          'Testimonial': feedback,
          'User Name': userName,
          'Testimonial Date': createdAt,
        });
        return true;
      }
    });
    return false;
  } catch (e) {
    return false;
  }
}

class ClientsOfMonth {
  getClientInfo() {
    DateTime today = DateTime.now();
    DateTime endDay = DateTime.now();
    today = DateTime(today.year, today.month, 1);
    endDay = DateTime(today.year, today.month + 1, 1);
    return FirebaseFirestore.instance
        .collection('Users')
        .where('Registered On', isGreaterThanOrEqualTo: today)
        .where('Registered On', isLessThanOrEqualTo: endDay)
        .get();
  }
}

class RecProds {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  getProdCount() {
    return FirebaseFirestore.instance
        .collection('Recommended Products')
        .doc(uid)
        .collection('Product Id')
        .get();
  }
}

// class MessageCount {
//   getMCount(clientName, cId) {
//     return FirebaseFirestore.instance
//         .collection('Chat Room')
//         .doc(cId)
//         .collection('Chats')
//         .where('sentBy', isEqualTo: clientName)
//         .where('Message Read', isEqualTo: false)
//         .get();
//   }
// }

class RevCount {
  getRevCount() {
    return FirebaseFirestore.instance.collection('Feedback').get();
  }
}

class UnreadCount {
  getUnreadCount() {
    return FirebaseFirestore.instance
        .collection('Unread User Notifications')
        .where('Message Read', isEqualTo: false)
        .get();
  }
}

// Future<bool> totalUnreadCount(
//   String? mCount, String cId,
// ) async {
//   try {
//     String uid = FirebaseAuth.instance.currentUser!.uid;
//     // var value = double.parse(amount);
//     DocumentReference documentReference =
//         FirebaseFirestore.instance.collection('Chat Room').doc(cId).collection('Chats');
//     FirebaseFirestore.instance.runTransaction((transaction) async {
//       DocumentSnapshot snapshot = await transaction.get(documentReference);
//       if (!snapshot.exists) {
//         documentReference.set({
//           'UserToken': token,
//         });
//         return true;
//       } else {
//         documentReference.update({
//           'UserToken': token,
//         });
//         return true;
//       }
//       // double newAmount = snapshot.data()['Amount'] + value;
//       // transaction.update(documentReference, {'Amount': newAmount});
//       // return true;
//     });
//     return false;
//   } catch (e) {
//     return false;
//   }
// }
