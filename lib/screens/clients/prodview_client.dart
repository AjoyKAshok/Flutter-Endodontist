import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProdViewClient extends StatefulWidget {
  final DocumentSnapshot? post;
  // final String id;
  ProdViewClient({
    this.post,
  });
  @override
  _ProdViewClientState createState() => _ProdViewClientState();
}

class _ProdViewClientState extends State<ProdViewClient> {
 File? image;
  PickedFile? pickedImage;
  String? imageLink;
  String? prodName;
  String? prodDescription;

  @override
  void initState() {
    super.initState();

    setState(() {
      imageLink = widget.post!['Product Image Path'];
      prodName = widget.post!['Product Name'];
      prodDescription = widget.post!['Product Description'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(prodName!),
      ),
      drawer: AppDrawer(),
      body: Container(
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
              height: 15,
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
            // SizedBox(
            //   height: 15,
            // ),
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
          ],
        ),
      ),
    );
  }
}