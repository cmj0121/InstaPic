import 'package:flutter/material.dart';
import 'login_page.dart';
import 'photo_page.dart';

void main() => runApp( InstaPicApp() );

// the main widget of the InstaPic
class InstaPicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InstaPic',
      theme: ThemeData.dark(),
      home: InstaPic(),
    );
  }
}

class InstaPic extends StatefulWidget {
  @override
  _InstaPicState createState() => _InstaPicState();
}

class _InstaPicState extends State<InstaPic> {
  @override
  Widget build(BuildContext context) {
    return UserLoginPage(() => {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => InstaPicPage(),
        )
      )
    });
  }
}

// vim: set ts=2 sw=2 expandtab:
