import 'package:flutter/material.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';

import 'login_page.dart';
import 'photo_page.dart';
import 'upload_page.dart';


// main function, start your application
void main() {
  configureApp();
  runApp( InstaPicApp() );
}


// the main widget of the InstaPic
class InstaPicApp extends StatelessWidget {
  final String title = 'Insta Pic';

  @override
  Widget build(BuildContext context) {
    // check the current session and get user info

    return MaterialApp(
      title: title,
      // the default theme of all application
      theme: ThemeData.dark(),
      // default route page
      initialRoute: InstaPicPage.route,
      routes: <String, WidgetBuilder> {
        InstaPicPage.route: (BuildContext context) => InstaPicPage(title: title),
        UploadPage.route: (BuildContext context) => UploadPage(title: title),
      },
    );
  }
}

// vim: set ts=2 sw=2 expandtab:
