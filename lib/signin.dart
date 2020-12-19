import 'package:drivers_ticket/home.dart';
import 'package:drivers_ticket/top_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String email, password;
  var _useTouchId = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();

  void _signIn() {
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print('Successful login');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Home(auth: _auth,wantsTouchId:_useTouchId), maintainState: false),
      );
    }).catchError((err) {
      if (err.code == 'wrong-password') {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                  title: Text('Please enter correct password'),
                  actions: <Widget>[
                    CupertinoDialogAction(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ]);
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(255, 123, 67, 1.0),
                Color.fromRGBO(245, 50, 111, 1.0),
              ],
            ),
          ),
          child: Column(
            children: <Widget>[
              TopHeader(size: size),
              Text("Sign In",
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                  )),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'This field is mandatory';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          email = val;
                        },
                        autovalidateMode: AutovalidateMode.always,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.white),
                          hintText: "Enter Email",
                          border: UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'This field is mandatory';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          password = val;
                        },
                        autovalidateMode: AutovalidateMode.always,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.white),
                          hintText: "Password",
                          border: UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Checkbox(
                              activeColor: Colors.orange,
                              onChanged: (newValue) {
                                setState(() {
                                  _useTouchId = newValue;
                                });
                              },
                              value: _useTouchId),
                          Text("Use Touch ID",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      SizedBox(height: 30.0),
                      InkWell(
                        onTap: () {
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            _signIn();
                          }
                        },
                        child: Container(
                          width: size.width * 0.8,
                          height: size.height * 0.08,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text("Get Started",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                )),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: size.width * 0.13,
                            height: size.height * 0.13,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(FontAwesomeIcons.facebookF,
                                color: Colors.red, size: 30.0),
                          ),
                          SizedBox(width: 30.0),
                          Container(
                            width: size.width * 0.13,
                            height: size.height * 0.13,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(FontAwesomeIcons.twitter,
                                color: Colors.red, size: 40.0),
                          ),
                        ],
                      ),
                      Text("FORGOT PASSWORD?",
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
