import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;


class User extends StatelessWidget {
  static const String session_key = 'session';

  final String? username;

  User(@required this.username);

  factory User.fromCookie() {
    String? session = html.window.localStorage[User.session_key];

    // get user info
    return User(session);
  }

  void save() {
    if (username != null) {
      // save session into local storage
      html.window.localStorage[User.session_key] = username!;
    }
  }

  void logout() {
    // remove the session from local storage
    html.window.localStorage.remove(User.session_key);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(username ?? '<Not Login>'),
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text('Did you want to logout'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                logout();
                // back to index
                Navigator.of(context).pushReplacementNamed('/');
              }
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.pop(context, 'No'),
            ),
          ],
        ),
      ),
    );
  }
}

// vim: set ts=2 sw=2 expandtab:
