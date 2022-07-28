import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class DocListPage extends StatefulWidget {

  @override
  _DocListPageState createState() => _DocListPageState();
}

class _DocListPageState extends State<DocListPage> {
  Future getPosts() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('Doctors List').get();
    return qn.docs;
  }

  // navigateToDetail(DocumentSnapshot post) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => DocDetailsPage(
  //                 post: post,
  //               )));
  // }

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
                      color: Colors.cyan,
                      shadowColor: Colors.amber,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${snapshot.data[index]['Doctor Name']}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            // imageLink != null ? 
                            CircleAvatar(
                              backgroundImage: NetworkImage(imageLink),
                            )
                            // : CircleAvatar(),
                          ],
                        ),
                      ),
                    ),
                    // onTap: () => navigateToDetail(snapshot.data[index]),
                  );
                });
          }
        },
      ),
    );
  }
}
