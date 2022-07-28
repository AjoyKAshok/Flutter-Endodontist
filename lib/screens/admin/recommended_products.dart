import 'dart:io';


import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_endodontist_app/database/database.dart';
import 'package:the_endodontist_app/screens/dashboard.dart';
// import 'package:new2/widgets/ad_helper.dart';
import 'package:the_endodontist_app/widgets/admin_app_drawer.dart';

class RecommendedProducts extends StatefulWidget {
  static const routeName = '/recommended_products';

  @override
  _RecommendedProductsState createState() => _RecommendedProductsState();
}

class _RecommendedProductsState extends State<RecommendedProducts> {
  String? imageLink;
  File? image;
  PickedFile? pickedImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _prodName = TextEditingController();

  final TextEditingController _prodId = TextEditingController();

  final TextEditingController _prodDescription = TextEditingController();

  Widget addProductImage() {
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
            'Select Product Image',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // FlatButton.icon(
              //   onPressed: () {
              //     takePhoto(ImageSource.camera);
              //     Navigator.of(context).pop();
              //   },
              //   icon: Icon(Icons.camera),
              //   label: Text('Camera'),
              // ),
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
                icon: Icon(Icons.image_search),
                label: Text('Gallery'),
              ),
              // FlatButton.icon(
              //   onPressed: () {
              //     takePhoto(ImageSource.gallery);
              //     Navigator.of(context).pop();
              //   },
              //   icon: Icon(
              //     Icons.photo_library_sharp,
              //   ),
              //   label: Text('Gallery'),
              // ),
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
        .child("Recommended Products")
        .child("product" + DateTime.now().toString());

    picFolder.putFile(File(pickedImage!.path)).then(
      (storageTask) async {
        String link = await storageTask.ref.getDownloadURL();
        setState(() {
          imageLink = link;
          // updateRecommendedProducts(imageLink);
        });
      },
    );
  }

  Column buildProductNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Product Name",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: _prodName,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: "Update Product Name",
          ),
        )
      ],
    );
  }

  Column buildProductIdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Product Id",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: _prodId,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: "Update Product Id",
          ),
        )
      ],
    );
  }

  Column buildProductDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Product Description",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: _prodDescription,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: "Update Product Description",
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommended Products'),
      ),
      drawer: AdminAppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              addProductImage(),
              // AdmobBanner(adUnitId: ams.getBannerAdId(), adSize: AdmobBannerSize.FULL_BANNER,),
              buildProductIdField(),
              buildProductNameField(),
              buildProductDescriptionField(),

              // Divider(
              //   thickness: 3,
              //   color: Colors.black,
              // ),
              // AdmobBanner(adUnitId: ams.getBannerAdId(), adSize: AdmobBannerSize.FULL_BANNER,),
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
                child: TextButton(
                  onPressed: () async {
                    await updateRecommendedProducts(
                      imageLink,
                      _prodId.text,
                      _prodName.text,
                      _prodDescription.text,
                    );
                    Navigator.of(context)
                        .pushReplacementNamed(DashBoardPage.routeName);
                    // SystemNavigator.pop();
                  },
                  child: Text(
                    'Update Product Details',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              
              // Container(
              //   width: MediaQuery.of(context).size.width / 2,
              //   height: 45,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(15),
              //     color: Colors.purple,
              //   ),
              //   child: TextButton(
              //     onPressed: () {
                    // SystemNavigator.pop();
              //     },
              //     child: Text(
              //       'View Recommended Products',
              //       style: TextStyle(color: Colors.white),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
