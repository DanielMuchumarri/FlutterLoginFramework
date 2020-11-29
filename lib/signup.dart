import 'package:drivers_ticket/main.dart';
import 'package:drivers_ticket/top_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String email, password, passwordConfirm;
  final formKey = GlobalKey<FormState>();

  void _createUser({String email, String pw}) {
    _auth
        .createUserWithEmailAndPassword(email: email, password: pw)
        .then((authResult) {
      Navigator.pop(context);
      print('yay! ${authResult.user}');

      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
                title: Text(
                    'Login created successfully, Please enter credentials to Login'),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ]);
          });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp(), maintainState: false),
      );
    }).catchError((err) {
      print(err.code);
      if (err.code == 'email-already-in-use') {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                  title: Text(
                      'This email already has an account associated with it'),
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
      body: Container(
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
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TopHeader(size: size),
              Text("CREATE YOUR LOGIN",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  )),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      validator: (emailValue) {
                        if (emailValue.isEmpty) {
                          return 'This field is mandatory';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          email = val.trim();
                        });
                      },
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
                      autovalidateMode: AutovalidateMode.always,
                      onChanged: (textValue) {
                        setState(() {
                          password = textValue;
                        });
                      },
                      validator: (pwValue) {
                        if (pwValue.isEmpty) {
                          return 'This field is mandatory';
                        }
                        if (pwValue.length < 8) {
                          return 'Password must be at lead 8 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.white),
                        hintText: "Password",
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      validator: (pwConfValue) {
                        if (pwConfValue != password) {
                          return 'Passwords much match';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.white),
                        hintText: "Re-Enter Password",
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Checkbox(
                            activeColor: Colors.orange,
                            onChanged: (bool chg) => chg,
                            value: true),
                        Text("Agree to Terms and Conditions",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FlatButton(
                          height: 50.0,
                          minWidth: 150.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: new BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          onPressed: () {
                            print('Cancel Button');
                            Navigator.pop(context);
                          },
                          child: Text('CANCEL',
                              style: TextStyle(color: Colors.red)),
                        ),
                        FlatButton(
                          height: 50.0,
                          minWidth: 150.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: new BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                              _createUser(email: email, pw: password);
                            }
                            print('Save Button ');
                          },
                          child:
                              Text('SAVE', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
