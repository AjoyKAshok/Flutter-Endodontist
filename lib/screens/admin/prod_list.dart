import 'package:the_endodontist_app/screens/admin/prod_detail.dart';
import 'package:the_endodontist_app/screens/admin/recommended_products.dart';
import 'package:the_endodontist_app/widgets/admin_app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProdList extends StatefulWidget {
  static const routeName = '/products_list';
  const ProdList({Key? key}) : super(key: key);

  @override
  _ProdListState createState() => _ProdListState();
}

class _ProdListState extends State<ProdList> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  Future getProducts() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection('Recommended Products')
        .doc(uid)
        .collection('Product Id')
        .get();
    return qn.docs;
  }

  navigateToDetail(DocumentSnapshot? post) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProdDetail(
          post: post,
        ),
      ),
    ).then((context) {
      setState(() {
        
      });
    });
    
  }

  _navigateToRecommend() {
    Navigator.of(context).pushReplacementNamed(RecommendedProducts.routeName);
  }

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text('Recommended Products List')),
            IconButton(onPressed: _navigateToRecommend, icon: Icon(Icons.add)),
          ],
        ),
      ),
      drawer: AdminAppDrawer(),
      body: Container(
        child: FutureBuilder(
          future: getProducts(),
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
                        snapshot.data[index]['Product Image Path'].toString();
                    return ListTile(
                        // title: Text(snapshot.data[index]['User Name']),
                        title: Card(
                          color: Colors.blueGrey[400],
                          shadowColor: Colors.amber,
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${snapshot.data[index]['Product Name']}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
                        onTap: () {
                          navigateToDetail(snapshot.data[index]);
                        });
                  });
            }
          },
        ),
      ),
    );
  }
}
