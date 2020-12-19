import 'package:drivers_ticket/login_option.dart';
import 'package:drivers_ticket/signin.dart';
import 'package:drivers_ticket/top_header.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*Hello*/
class Body extends StatelessWidget {
  Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Material(
      child: Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: <Widget>[
                TopHeader(size: size),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: size.width,
                  height: size.height * 0.50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      LoginOption(
                          iconName: FontAwesomeIcons.facebookF,
                          title: ' | Sign in with Facebook'),
                      SizedBox(height: 20),
                      LoginOption(
                          iconName: FontAwesomeIcons.twitter,
                          title: ' | Sign in with Twitter'),
                      SizedBox(height: 20),
                      LoginOption(title: 'Sign Up'),
                      SizedBox(height: 20),
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignIn()),
                          );
                        },
                        child: Text(
                          'ALREADY REGISTERED? SIGN IN',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
      ),
    );
  }
}
