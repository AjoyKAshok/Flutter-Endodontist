import 'package:the_endodontist_app/screens/welcome_screen.dart';
import 'package:the_endodontist_app/user_management.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/auth_form.dart';

class DentistaAuthScreen extends StatefulWidget {
  @override
  _DentistaAuthScreenState createState() => _DentistaAuthScreenState();
}

class _DentistaAuthScreenState extends State<DentistaAuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    String profileImage,
    bool isLogin,
    String isAdmin,
    Timestamp createdAt,
    BuildContext ctx,
  ) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(authResult.user!.uid)
            .set({
          'User Name': username,
          'Email': email,
          'Role': isAdmin,
          'Profile Image Path': profileImage,
          'Registered On': createdAt,
          'User Id': authResult.user!.uid,
        });
      }
    } on PlatformException catch (err) {
      String? message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message!),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      // body: StreamBuilder(
      //     stream: FirebaseAuth.instance.authStateChanges(),
      //     builder: (context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting)
      //         return Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       else if (snapshot.hasError) {
      //         return Center(
      //           child: Text('Something went wrong'),
      //         );
      //       } else if (snapshot.hasData) {
      //         return UserManagement().handleAuth();
      //       } else {
      //         return AuthForm(
      //           _submitAuthForm,
      //           _isLoading,
      //         );
      //       }
      //     }),
      body: AuthForm(
                _submitAuthForm,
                _isLoading,
              ),
    );
  }
}
