import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterme/pages/home_page.dart';
import 'package:flutterme/pages/login_page.dart';
import 'package:flutterme/utils/app_shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  createState() => new SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  final globalKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    new Future.delayed(const Duration(seconds: 3), _handleTapEvent);
    return new Scaffold(
      key: globalKey,
      body: _splashContainer(),
    );
  }

  Widget _splashContainer() {
    return GestureDetector(
        onTap: _handleTapEvent,
        child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: new BoxDecoration(color: Colors.blue[400]),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: new Text(
                    "Flutter Me",
                    style: new TextStyle(color: Colors.white, fontSize: 24.0),
                  ),
                ),
              ],
            )));
  }

  void _handleTapEvent() async {
    bool isLoggedIn = await AppSharedPreferences.isUserLoggedIn();
    if (this.mounted) {
      setState(() {
        if (isLoggedIn != null && isLoggedIn) {
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (context) => new HomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (context) => new LoginPage()),
          );
        }
      });
    }
  }

}
