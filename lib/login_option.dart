import 'package:drivers_ticket/home.dart';
import 'package:drivers_ticket/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_twitter/flutter_twitter.dart';

class LoginOption extends StatefulWidget {
  LoginOption({Key key, this.iconName, this.title}) : super(key: key);

  final IconData iconName;
  final String title;

  @override
  _LoginOptionState createState() => _LoginOptionState();
}

class _LoginOptionState extends State<LoginOption> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();
  TwitterLogin twitterLogin;

  void _signInFacebook(context) async {
    await facebookLogin.logIn(['email']).then((result) async {
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              });
          final FacebookAccessToken accessToken = result.accessToken;
          print('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');

          print('1****');
          await http
              .get(
                  'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}')
              .then((graphResponse) {
            print(graphResponse.body);

            final credential =
                FacebookAuthProvider.credential(accessToken.token);

            _auth.signInWithCredential(credential);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Home(auth: _auth, fbLogin: facebookLogin),
                  maintainState: false),
            );

            //   Navigator.of(context).pushNamedAndRemoveUntil(
            //       'Home', (Route<dynamic> route) => false);
          });

          break;

        case FacebookLoginStatus.cancelledByUser:
          print('Login cancelled by the user.');
          break;
        case FacebookLoginStatus.error:
          print('Something went wrong with the login process.\n'
              'Here\'s the error Facebook gave us: ${result.errorMessage}');
          break;
      }
    });
  }

  void _signInTwitter() async {
    twitterLogin = new TwitterLogin(
      consumerKey: '47NyFr8ScktKJpPv1DpyJqjxQ',
      consumerSecret: 'ltkjR2K2YlAKUFSAfw9dFtMhcvPhTFwcWTh5OAI3RpRD3FZLBG',
    );

    final TwitterLoginResult result = await twitterLogin.authorize();

    if (result.status == TwitterLoginStatus.loggedIn) {
                showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              });
      final AuthCredential credential = TwitterAuthProvider.credential(
          accessToken: result.session.token, secret: result.session.secret);
      await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Home(auth: _auth, twitterLogin: twitterLogin),
            maintainState: false),
      );
    } else if (result.status == TwitterLoginStatus.cancelledByUser) {
      print('Login cancelled by user.');
    } else {
      print(result.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print('Hello Facebook 1');
        if (widget.title == ' | Sign in with Facebook') {
          print('Hello Facebook 2');
          _signInFacebook(context);
        } else if (widget.title == ' | Sign in with Twitter') {
          print('Hello Facebook 3');
          _signInTwitter();
        } else {
          print('Hello Facebook 4');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUp()),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 20.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: buildContent(widget.iconName),
      ),
    );
  }

  Row buildContent(iconName) {
    if (iconName != null) {
      return Row(children: <Widget>[
        Icon(iconName, color: Colors.red, size: 30.0),
        Text(
          widget.title,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ]);
    } else {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(iconName, color: Colors.red, size: 30.0),
            Text(
              widget.title,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ]);
    }
  }
}
