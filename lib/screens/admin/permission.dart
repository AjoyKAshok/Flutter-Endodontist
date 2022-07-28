import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_endodontist_app/database/database.dart';
import 'package:the_endodontist_app/screens/doctors/doc_profile.dart';
import 'package:the_endodontist_app/widgets/admin_app_drawer.dart';

class Permissions extends StatefulWidget {
  static const routeName = '/settings';
  @override
  _PermissionsState createState() => _PermissionsState();
}

class _PermissionsState extends State<Permissions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Settings'),
      ),
      drawer: AdminAppDrawer(),
      body: UserList(),
    );
  }
}

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  String? uid;
  String? imageLink;
  Future getUsers() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('Users').get();
    return qn.docs;
  }

  navigateToUserPermissions(DocumentSnapshot? userRole) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditRolePage(
                  role: userRole,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getUsers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  imageLink =
                      snapshot.data[index]['Profile Image Path'].toString();
                  return ListTile(
                    // leading: CircleAvatar(),
                    title: Card(
                      color: Colors.cyan,
                      shadowColor: Colors.amber,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${snapshot.data[index]['User Name']}: ${snapshot.data[index]['Role']}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            imageLink != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(imageLink!),
                                  )
                                : CircleAvatar(),
                          ],
                        ),
                      ),
                    ),
                    onTap: () =>
                        navigateToUserPermissions(snapshot.data[index]),
                  );
                });
          }
        },
      ),
    );
  }
}

class EditRolePage extends StatefulWidget {
  final DocumentSnapshot? role;
  EditRolePage({this.role});
  @override
  _EditRolePageState createState() => _EditRolePageState();
}

class _EditRolePageState extends State<EditRolePage> {
  // PickedFile? _imageFile;
  File? image;
  PickedFile? pickedImage;
  // final ImagePicker _picker = ImagePicker();
  String? imageLink;

  final List<String> roles = ['Admin', 'Client', 'Doctor'];
  String? _currentRole;
  String? _currentUserId;
  String? _imageLink;
  @override
  void initState() {
    _currentRole = widget.role!['Role'];
    _currentUserId = widget.role!['User Id'];
    _imageLink = widget.role!['Profile Image Path'];
    super.initState();
  }
  // Column buildRoleField() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Padding(
  //           padding: EdgeInsets.all(12),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 "${widget.role.data()['User Name']}",
  //                 style: TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               Container(
  //                 width: MediaQuery.of(context).size.width / 12,
  //                 height: MediaQuery.of(context).size.height / 10,
  //                 child: DropdownButtonFormField(
  //                   items: roles.map((role) {
  //                     return DropdownMenuItem(
  //                       child: Text('$role'),
  //                       value: role,
  //                     );
  //                   }).toList(),
  //                   onChanged: null,
  //                 ),
  //               ),
  //             ],
  //           )),
  //       RaisedButton(
  //         color: Colors.grey,
  //         child: Text(
  //           'Update',
  //           style: TextStyle(color: Colors.black),
  //         ),
  //         onPressed: null,
  //       ),
  //     ],
  //   );
  // }

  Widget addSuggestedProductsImage() {
    return Stack(
      children: [
        _imageLink != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(
                  _imageLink!,
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
        // Positioned(
        //   child: InkWell(
        //     child: Icon(
        //       Icons.camera_alt_sharp,
        //       color: Colors.greenAccent,
        //       size: 25,
        //     ),
        //     onTap: () {
        //       showModalBottomSheet(
        //           context: context, builder: ((builder) => BottomSheet()));
        //     },
        //   ),
        //   bottom: 20,
        //   right: 20,
        // ),
      ],
    );
  }

  // Widget BottomSheet() {
  //   return Container(
  //     height: 100,
  //     width: MediaQuery.of(context).size.width,
  //     margin: EdgeInsets.symmetric(
  //       horizontal: 20,
  //       vertical: 20,
  //     ),
  //     child: Column(
  //       children: [
  //         Text(
  //           'Select Suggested Product Image',
  //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //         ),
  //         SizedBox(
  //           height: 20,
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             TextButton.icon(
  //               onPressed: () {
  //                 takePhoto(ImageSource.camera);
  //                 Navigator.of(context).pop();
  //               },
  //               icon: Icon(Icons.camera),
  //               label: Text('Camera'),
  //             ),
  //             TextButton.icon(
  //               onPressed: () {
  //                 takePhoto(ImageSource.gallery);
  //                 Navigator.of(context).pop();
  //               },
  //               icon: Icon(
  //                 Icons.photo_library_sharp,
  //               ),
  //               label: Text('Gallery'),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void takePhoto(ImageSource source) async {
  //   final pickedImage = await _picker.getImage(
  //     source: source,
  //   );
  //   FirebaseStorage fs = FirebaseStorage.instance;

  //   Reference rootRef = fs.ref();

  //   Reference picFolder = rootRef
  //       .child("Product Pics")
  //       .child("image" + DateTime.now().toString());

  //   picFolder.putFile(File(pickedImage.path)).then(
  //     (storageTask) async {
  //       String link = await storageTask.ref.getDownloadURL();
  //       setState(() {
  //         imageLink = link;
  //         updateProfilePic(imageLink);
  //       });
  //     },
  //   );
  //   // setState(() {
  //   //   _imageFile = pickedFile;
  //   //   // UploadImage(_imageFile);
  //   //   FirebaseStorage fs = FirebaseStorage.instance;

  //   //   Reference rootRef = fs.ref();

  //   //   Reference picFolder = rootRef
  //   //       .child("Profile Pics")
  //   //       .child("image" + DateTime.now().toString());

  //   //   picFolder.putFile(File(_imageFile.path)).then((storageTask) async {
  //   //     String link = await storageTask.ref.getDownloadURL();
  //   //     imageLink = link;
  //   //   });
  //   // });
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
              "${widget.role!['User Name']}",
            ),
          ],
        ),
      ),
      drawer: AdminAppDrawer(),
      body: Card(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "${widget.role!['User Name']}: ${widget.role!['Role']} ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButton(
                      value: _currentRole,
                      items: roles.map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(
                            '$role',
                          ),
                        );
                      }).toList(),
                      onChanged: (dynamic val) => setState(() => _currentRole = val),
                    ),
                  ],
                )),
            SizedBox(
              height: 15,
            ),
            // Text(_currentRole),
            // Text(_currentUserId),
            // Text(_imageLink),
            addSuggestedProductsImage(),
            ElevatedButton(
              // color: Colors.grey,
              child: Text(
                'Update',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                updateUserRoles(_currentRole, _currentUserId);
                updateProfileRoles(_currentRole, _currentUserId);
                // _currentRole == 'Doctor'
                //     ? addToDoctorsList(_currentRole, _currentUserId)
                //     : null;
                if (_currentRole == 'Doctor') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DocProfile(
                                userid: _currentUserId,
                              )));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
