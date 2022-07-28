import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:the_endodontist_app/database/database.dart';
import 'package:the_endodontist_app/screens/welcome_screen.dart';
import 'package:the_endodontist_app/widgets/app_drawer.dart';


class Testimonial extends StatefulWidget {

  static const routeName = '/feedback';
  @override
  _TestimonialState createState() => _TestimonialState();
}

class _TestimonialState extends State<Testimonial> {
  // static final MobileAdTargetingInfo targetInfo = MobileAdTargetingInfo(
  //   testDevices: <String>['ca-app-pub-4263649516907121~8800997714'],
  //   keywords: <String>['Check Up', 'Cleaning', 'Braces', 'Root Canal'],

  //   childDirected: true,

  // );

  // late BannerAd _bannerAd ;
  // bool isLoaded;

  // late InterstitialAd _interstitialAd;

  // final ams = AdMobService();

  Future getTestimonial() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    // var value = double.parse(amount);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Feedback').doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        _feedback.text = snapshot['Testimonial'];
      }
    });
    return documentReference;
  }

  // BannerAd createBannerAd() {
  //   return BannerAd(
  //       adUnitId: BannerAd.testAdUnitId,
  //       size: AdSize.banner,
  //       targetingInfo: targetInfo,
  //       listener: (MobileAdEvent event) {
  //         print("Banner Event : $event");
  //       });
  // }

  // InterstitialAd createInterstitialAd() {
  //   return InterstitialAd(
  //       adUnitId: InterstitialAd.testAdUnitId,
  //       targetingInfo: targetInfo,
  //       listener: (MobileAdEvent event) {
  //         print("Interstitial Event : $event");
  //       });
  // }

  final TextEditingController _feedback = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    // MobileAds.instance.initialize();
    // _ad = BannerAd(
    //   adUnitId: AdHelper.getBannerAdId(),
    //   request: AdRequest(),
    //   size: AdSize.banner,
    //   listener: AdListener(
    //     onAdLoaded: (_) {
    //       setState(() {
    //         isLoaded = true;
    //       });
    //     },
    //     onAdFailedToLoad: (_, error) {
    //       print("Ad Failed to Load with errror: $error");
    //     },
    //   ),
    // );
    // _ad.load();
    // FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-4263649516907121~8800997714');
    // _bannerAd = createBannerAd()..load()..show(anchorType: AnchorType.bottom);
    // getTestimonial();
    // Admob.initialize();
  }

  @override
  void dispose() {
    // _bannerAd.dispose();
    // _interstitialAd?.dispose();
    super.dispose();
  }

  // Widget checkForAd() {
  //   if(isLoaded == true) {
  //     return Container(
  //       child: AdWidget(
  //         ad: _ad,
  //       ),
  //       width: _ad.size.width.toDouble(),
  //       height: _ad.size.height.toDouble(),
  //       alignment: Alignment.center,
  //     );
  //   } else {
  //     return CircularProgressIndicator();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // globalContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Your Feedback'),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Text('AJ'),
            ),
          ],
        ),
      ),
      drawer: AppDrawer(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(9),
                // color: Colors.blueGrey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _feedback,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: 'Your Feedback',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        labelText: 'User Testimonial',
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    // checkForAd(),
                    // AdmobBanner(adUnitId: ams.getBannerAdId(), adSize: AdmobBannerSize.FULL_BANNER,),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.purple,
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          await updateFeedback(_feedback.text);
                          // Navigator.of(context).pop();
                          Navigator.of(context)
                              .pushReplacementNamed(WelcomeScreen.routeName);
                          // SystemNavigator.pop();
                        },
                        child: Text(
                          'Update Testimonial',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}