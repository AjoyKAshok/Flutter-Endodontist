import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_endodontist_app/database/database.dart';
import 'package:the_endodontist_app/provider/gsignin.dart';
import 'package:the_endodontist_app/user_management.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../forgot_password.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    String profileImage,
    bool isLogin,
    String isAdmin,
    Timestamp createdAt,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _isAdmin = 'Client';
  var _profileImage = '';
  String? _userEmail = '';
  String? _userName = '';
  String? _userPassword = '';
  String? _cPassword = '';
  var _registeredOn = Timestamp.now();

  // GoogleSignIn googleAuth = GoogleSignIn(scopes: ['email']);

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
          _userEmail!.trim(),
          _userPassword!.trim(),
          _userName!.trim(),
          _profileImage,
          _isLogin,
          _isAdmin,
          _registeredOn,
          context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 422,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Center(
                                child: Text(
                                  'The Endodontist - DENTAL APP',
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/Ajit1.png'),
                                fit: BoxFit.fitHeight,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text('Dr. Ajit George Mohan'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              'LOGIN FOR...',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Column(
                            children: [
                              Text('PRODUCT RECOMMENDATIONS'),
                              SizedBox(
                                height: 18,
                              ),
                              Text('CONTACT DETAILS'),
                              SizedBox(
                                height: 18,
                              ),
                              Text('CHAT WITH DOC'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  // SizedBox(height: 12),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  SizedBox(height: 12),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText:
                          'Password Should be minimum 7 characters in length.',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  if (_isLogin)
                    TextButton(
                      child: Text('Forgot Password'),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen()),
                      ),
                    ),
                  // FlatButton(
                  //   onPressed: () => Navigator.of(context).push(
                  //     MaterialPageRoute(
                  //         builder: (context) => ForgotPasswordScreen()),
                  //   ),
                  //   child: Text('Forgot Password'),
                  // ),
                  // SizedBox(
                  //   height: 6,
                  // ),
                  // RaisedButton(
                  //   onPressed: () async {
                  //     try {
                  //       await googleAuth.signIn();
                  //     } catch (err) {
                  //       print(err);
                  //     }
                  //   },
                  //   child: Text('Login with Google'),
                  // ),
                  if (!_isLogin)
                    // SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: TextFormField(
                        key: ValueKey('confirm_password'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return 'Password Confirmation Failed, Please try again...';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onSaved: (value) {
                          _cPassword = value;
                        },
                        obscureText: true,
                      ),
                    ),
                  // SizedBox(height: 12),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    Column(
                      children: [
                        ElevatedButton(
                          child: Text(_isLogin ? 'Login' : 'Signup'),
                          onPressed: _trySubmit,
                        ),
                        SizedBox(height: 12),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blueGrey,
                              onPrimary: Colors.white,
                            ),
                            icon: FaIcon(
                              FontAwesomeIcons.google,
                              color: Colors.black,
                            ),
                            label: Text('Sign In with Google'),
                            // onPressed: () {
                            //   final provider = Provider.of<GoogleSignInProvider>(
                            //       context,
                            //       listen: false);
                            //   provider.googleLogin();
                            // },
                            onPressed: () => googleSignIn().whenComplete(
                                () => UserManagement().handleAuth())),
                      ],
                    ),
                  // RaisedButton(
                  //   child: Text(_isLogin ? 'Login' : 'Signup'),
                  //   onPressed: _trySubmit,
                  // ),
                  if (!widget.isLoading)
                    TextButton(
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                  // FlatButton(
                  //   textColor: Theme.of(context).primaryColor,
                  //   child: Text(_isLogin
                  //       ? 'Create new account'
                  //       : 'I already have an account'),
                  //   onPressed: () {
                  //     setState(() {
                  //       _isLogin = !_isLogin;
                  //     });
                  //   },
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
