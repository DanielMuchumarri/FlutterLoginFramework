import 'package:drivers_ticket/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter/flutter_twitter.dart';

class Home extends StatelessWidget {
  final FacebookLogin fbLogin;
  //final FacebookLoginResult rs;
  final FirebaseAuth auth;
  final TwitterLogin twitterLogin;
  //final String fbLogin;

  Home({this.fbLogin, this.auth, this.twitterLogin});

  Future<void> _logOut(context) async {
    if (fbLogin != null) {
      print('Inside facebook logout section');
      print(await fbLogin.isLoggedIn);
      //print(json.encode(auth));
      await fbLogin.logOut();
      await auth.signOut();
      print('Logged out.');
      bool isLoggedIn = await fbLogin.isLoggedIn;
      if (isLoggedIn == false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyApp(), maintainState: false),
        );
        // Navigator.of(context)
        //     .pushReplacementNamed('main');
      }
      print(await fbLogin.isLoggedIn);
      // print(accessToken.token);
      // print(fbLogin.n);
    } else if (twitterLogin != null) {
      print('Inside twitter logout section');
      bool isActive;
      isActive = await twitterLogin.isSessionActive;
      print(isActive);
      await twitterLogin.logOut();
      isActive = await twitterLogin.isSessionActive;
      if (isActive == false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyApp(), maintainState: false),
        );
      }
      print(isActive);
    } else if (auth != null && twitterLogin == null && fbLogin == null) {
      auth.signOut();

      auth.authStateChanges().listen((User user) {
        if (user == null) {
          print('User is currently signed out!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyApp(), maintainState: false),
          );
        } else {
          print('User is signed in!');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final Shader linearGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromRGBO(255, 123, 67, 1.0),
        Color.fromRGBO(245, 50, 111, 1.0),
      ],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    return Material(
        child: SafeArea(
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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.menu),
                  ),
                  IconButton(
                    onPressed: () {
                      _logOut(context);
                    },
                    icon: Icon(Icons.logout),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Your Score',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'BigShoulders',
                        //foreground: Paint()..shader = linearGradient,
                        color: Colors.white,
                      )),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(255, 123, 67, 1.0),
                            Color.fromRGBO(245, 50, 111, 1.0),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("80",
                            style: TextStyle(
                              fontSize: 40.0,
                              color: Colors.white.withOpacity(0.5),
                            )),
                      )),
                ],
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: <Widget>[
                    Text("Pending Payments",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'BigShoulders',
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Row(
                    children: <Widget>[
                      buildPendingPaymentCard(size),
                      SizedBox(width: 30),
                      buildPendingPaymentCard(size),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: <Widget>[
                    Text("Previous History",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'BigShoulders',
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Row(
                    children: <Widget>[
                      buildPendingPaymentCard(size),
                      SizedBox(width: 30),
                      buildPendingPaymentCard(size),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Container buildPendingPaymentCard(Size size) {
    return Container(
      width: size.width * .8,
      height: size.height * 0.25,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(255, 123, 67, 1.0),
            Color.fromRGBO(245, 50, 111, 1.0),
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          SizedBox(height: 5.0),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: "Ticket # : ",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: "12345678",
                          style: TextStyle(
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
              ]),
          SizedBox(height: 12.0),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: 'Date Issued \n',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: '11/26/2020',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: 'Last Date of Payment \n',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '12/26/2020',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
          SizedBox(height: 15.0),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: RichText(
                    softWrap: true,
                    text: TextSpan(
                      text: "Reason \n",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              "Overspeed driving at 90 miles/hr on a road with high speed 60 miles/hr",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
        ]),
      ),
    );
  }
}
