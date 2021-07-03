import 'package:flutter/material.dart';
import 'login_page.dart';
import 'photo_page.dart';
import 'upload_page.dart';


void main() => runApp( InstaPicApp() );

// the main widget of the InstaPic
class InstaPicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InstaPic',
      theme: ThemeData.dark(),
      home: InstaPicPage(),
      routes: <String, WidgetBuilder> {
        '/login': (BuildContext context) => UserLoginPage(),
        '/upload': (BuildContext context) => UploadPage(),
      },
    );
  }
}

// vim: set ts=2 sw=2 expandtab:
