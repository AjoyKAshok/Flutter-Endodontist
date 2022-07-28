import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/screens/doctors/show_details.dart';
import 'package:flutter/material.dart';
import 'package:the_endodontist_app/screens/doctors/details_page.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future getPosts() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('Users').where('Role', isNotEqualTo: 'Admin').get();
    return qn.docs;
  }

  navigateToDetail(DocumentSnapshot? post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ShowDetails(
                  post: post,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getPosts(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                    String imageLink =
                      snapshot.data[index]['Profile Image Path'].toString();
                  return ListTile(
                    // title: Text(snapshot.data[index]['User Name']),
                    title: Card(
                      color: Colors.blueGrey,
                      shadowColor: Colors.amber,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${snapshot.data[index]['User Name']}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            // ignore: unnecessary_null_comparison
                            // imageLink != null ? 
                            CircleAvatar(
                              backgroundImage: NetworkImage(imageLink),
                            )
                            // : CircleAvatar(),
                          ],
                        ),
                      ),
                    ),
                    onTap: () => navigateToDetail(snapshot.data[index]),
                  );
                });
          }
        },
      ),
    );
  }
}
