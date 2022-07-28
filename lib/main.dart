// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/home_page.dart';
import 'package:the_endodontist_app/provider/gsignin.dart';
import 'package:the_endodontist_app/screens/add_event.dart';
import 'package:the_endodontist_app/screens/add_event_new.dart';
import 'package:the_endodontist_app/screens/admin/admin_profile.dart';
import 'package:the_endodontist_app/screens/admin/doc_chat_screen.dart';
import 'package:the_endodontist_app/screens/admin/finder.dart';
import 'package:the_endodontist_app/screens/admin/information.dart';
import 'package:the_endodontist_app/screens/admin/prod_list.dart';
import 'package:the_endodontist_app/screens/admin/review_list_screen.dart';
import 'package:the_endodontist_app/screens/admin/searcher.dart';
import 'package:the_endodontist_app/screens/admin/unread_notifications.dart';
import 'package:the_endodontist_app/screens/clients/patient_doc.dart';
import 'package:the_endodontist_app/screens/clients/profiler.dart';
import 'package:the_endodontist_app/screens/doctors/add_diagnostics.dart';
import 'package:the_endodontist_app/screens/event_new.dart';
// import 'package:the_endodontist_app/screens/doctors/show_diagnostics.dart';

import 'package:the_endodontist_app/widgets/events.dart';

// import 'package:flutter/services.dart';

import 'package:the_endodontist_app/widgets/asset_player.dart';
import 'package:the_endodontist_app/widgets/build_pat_card.dart';
import 'package:the_endodontist_app/widgets/calander_flutter.dart';
import 'package:the_endodontist_app/widgets/chat_app.dart';
import 'package:the_endodontist_app/widgets/client_chat.dart';
import 'package:the_endodontist_app/widgets/in_chat.dart';
import 'package:the_endodontist_app/widgets/sync_calander.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:the_endodontist_app/user_management.dart';
import 'package:provider/provider.dart';
import './screens/welcome_screen.dart';
import 'screens/admin/client_list.dart';
import 'screens/admin/doc_list.dart';
import 'screens/admin/permission.dart';
import 'screens/admin/recommended_products.dart';
import 'screens/clients/client_profile.dart';
import 'screens/clients/reference.dart';
import 'screens/clients/testimonial.dart';
import 'screens/dashboard.dart';
import 'screens/doctor_home_page.dart';
import 'screens/doctors/doc_profile.dart';
import 'screens/doctors/patient_list.dart';
import 'screens/admin/notification_send.dart';

// import 'package:the_endodontist_app/secrets.dart';
// import 'package:the_endodontist_app/utils/calendar_client.dart';
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:googleapis/calendar/v3.dart' as cal;
// import 'firebase_options.dart';

/// Recieve message when app is in background - Workaround for onMessage function.
// Future<void> backgroundHandler(RemoteMessage message) async {
//   print(message.data.toString());
//   print(message.notification!.title);
// }

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // var _clientID = new ClientId(Secret.getId(), "");
  // const _scopes = const [cal.CalendarApi.calendarScope];
  // await clientViaUserConsent(_clientID, _scopes, prompt)
  //     .then((AuthClient client) async {
  //   CalendarClient.calendar = cal.CalendarApi(client);
  // });

  
  runApp(Dentista());
}
// void prompt(String url) async {
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
// }

class Dentista extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _DentistaState createState() => _DentistaState();
}

class _DentistaState extends State<Dentista> {
  late String docName;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // Future getUserInfo() async {
  //   String uid = _auth.currentUser!.uid;
  //   DocumentReference documentReference =
  //       FirebaseFirestore.instance.collection('Users').doc(uid);
  //   FirebaseFirestore.instance.runTransaction((transaction) async {
  //     DocumentSnapshot snapshot = await transaction.get(documentReference);
  //     if (snapshot.exists) {
  //       setState(() {
  //         docName = snapshot['User Name'];
  //         // print('From getUserInfo');
  //         // print(docName);
  //       });
  //     }
  //   });
  //   return documentReference;
  // }

  @override
  void initState() {
    super.initState();
    // getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    var cDetails;
    var patientName;
    var senderName;
    var patientPic;
    var idChat;
    var uid;
    DocumentSnapshot<Object?>? ds;
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dentista',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          backgroundColor: Colors.blueGrey,
          accentColorBrightness: Brightness.dark,
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.deepPurple,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey)
              .copyWith(secondary: Colors.deepPurple),
        ),
        darkTheme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          backgroundColor: Colors.blueGrey,
          accentColorBrightness: Brightness.dark,
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.deepPurple,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey)
              .copyWith(secondary: Colors.deepPurple),
        ),
        home: UserManagement().handleAuth(),
        // home: WelcomeScreen(),

        routes: {
          WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
          HomePage.routeName: (ctx) => HomePage(),
          ReferencePage.routeName: (ctx) => ReferencePage(),
          Testimonial.routeName: (ctx) => Testimonial(),
          ReviewList.routeName: (ctx) => ReviewList(),
          DashBoardPage.routeName: (ctx) => DashBoardPage(),
          AdminProfile.routeName: (ctx) => AdminProfile(),
          SFCal.routeName: (ctx) => SFCal(),
          AddEvent.routeName: (ctx) => AddEvent(),
          AddEventNew.routeName: (ctx) => AddEventNew(),
          EventPage.routeName: (ctx) => EventPage(),
          EventNew.routeName: (ctx) => EventNew(),
          TabCal.routeName: (ctx) => TabCal(),
          PatientList.routeName: (ctx) => PatientList(),
          ClientList.routeName: (ctx) => ClientList(),
          // ShowDiagnostics.routeName: (ctx) => ShowDiagnostics(uid: uid),
          AddDiagnostics.routeName: (ctx) => AddDiagnostics(),
          DocList.routeName: (ctx) => DocList(),
          ClientProfile.routeName: (ctx) => ClientProfile(),
          Profiler.routeName: (ctx) => Profiler(),
          Permissions.routeName: (ctx) => Permissions(),
          DoctorHome.routeName: (ctx) => DoctorHome(),
          DocProfile.routeName: (ctx) => DocProfile(
                userid: '',
              ),
          RecommendedProducts.routeName: (ctx) => RecommendedProducts(),
          ProdList.routeName: (ctx) => ProdList(),
          InfoPage.routeName: (ctx) => InfoPage(),
          Unreads.routeName: (ctx) => Unreads(),
          NotificationSend.routeName: (ctx) =>
              NotificationSend(payload: 'payload'),
          AssetPlayer.routeName: (ctx) => AssetPlayer(),
          DocChatScreen.routeName: (ctx) => DocChatScreen(),
          ClientChatPage.routeName: (ctx) => ClientChatPage(),
          PatientToDoc.routeName: (ctx) => PatientToDoc(),
          // ToSearchPage.routeName: (ctx) => ToSearchPage(),
          Searcher.routeName: (ctx) => Searcher(),
          Finder.routeName: (ctx) => Finder(),
          BuildPatientCard.routeName: (ctx) =>
              BuildPatientCard(context, ds, docName),
          InChat.routeName: (ctx) => InChat(
              clientName: patientName,
              chatId: idChat,
              senderName: senderName,
              patientPic: patientPic),
          // VideoPlayerWidget.routeName: (ctx) => VideoPlayerWidget(controller: controller),
          // SearchPage.routeName: (ctx) => SearchPage(clientDetails: clientDetails, chatId: 'chatId', senderName: 'senderName',),
          ChatScreen.routeName: (ctx) => ChatScreen(
                clientDetails: cDetails,
                chatId: idChat,
                senderName: docName,
              ),
        },
      ),
    );
  }
}
