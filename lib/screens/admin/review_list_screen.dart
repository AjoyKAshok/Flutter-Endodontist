import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/widgets/admin_app_drawer.dart';
import 'package:flutter/material.dart';

class ReviewList extends StatefulWidget {
  static const routeName = '/review_list';
  const ReviewList({Key? key}) : super(key: key);

  @override
  _ReviewListState createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Reviews'),
      ),
      drawer: AdminAppDrawer(),
      body: Container(
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Feedback')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (_, index) {
                            return ListTile(
                                title: Card(
                                    color: Colors.blueGrey[400],
                                    elevation: 5,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            "${snapshot.data!.docs[index]['User Name']}: ${snapshot.data!.docs[index]['Testimonial']}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      ],
                                    )));
                          });
                    }))),
      ),
    );
  }
}
