import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/database/database.dart';
import 'package:the_endodontist_app/screens/admin/prod_list.dart';
import 'package:the_endodontist_app/screens/dashboard.dart';
import 'package:the_endodontist_app/widgets/admin_app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProdDetail extends StatefulWidget {
  // static const routeName = '/product_detail';
  // const ProdDetail({ Key? key }) : super(key: key);
  final DocumentSnapshot? post;
  // final String id;
  ProdDetail({
    this.post,
  });

  @override
  _ProdDetailState createState() => _ProdDetailState();
}

class _ProdDetailState extends State<ProdDetail> {
  File? image;
  PickedFile? pickedImage;
  String? imageLink;
  String? prodName;
  String? prodDescription;
  String? prodId;

  @override
  void initState() {
    super.initState();

    setState(() {
      imageLink = widget.post!['Product Image Path'];
      prodName = widget.post!['Product Name'];
      prodDescription = widget.post!['Product Description'];
      prodId = widget.post!['Product Id'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(prodName!),
      ),
      drawer: AdminAppDrawer(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              imageLink != null
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 350,
                        width: 400,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageLink!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: 200,
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: prodDescription != null
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(child: Text(prodDescription!)),
                        )
                      : Text('Enter Product Description Here'),
                ),
              ),
              SizedBox(
                height: 8,
              ),

              // OPTION FOR MAKING CHANGES IS NOT REQUIRED HERE IN THIS SCREEN

              // Padding(
              //   padding: const EdgeInsets.all(12.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       ElevatedButton(
              //         onPressed: () {},
              //         child: Text('Save Changes'),
              //       ),
              //       SizedBox(
              //         width: 5,
              //       ),
              //       ElevatedButton(
              //         onPressed: () {},
              //         child: Text('Discard Changes'),
              //       ),
              //     ],
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: () {
                    deleteRecommendedProducts(
                        imageLink, prodId!, prodName!, prodDescription!);
                    //  Navigator.of(context).pushNamed(DashBoardPage.routeName);
                    Navigator.of(context).pop();
                  },
                  child: Text('Remove Product'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
