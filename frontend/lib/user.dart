import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

import 'route.dart';
import 'requests.dart';

const String sessionKey = 'session';

void save_session(String? session) {
  if (session == null) {
    html.window.localStorage.remove(sessionKey);
    return;
  }
  html.window.localStorage[sessionKey] = session;
}

String get_session() {
  return html.window.localStorage[sessionKey] ?? '';
}

void logout() {
  html.window.localStorage.remove(sessionKey);
}

class User extends StatelessWidget {
  String username;

  User(this.username);

  @override
  Widget build(BuildContext context) {

    return TextButton(
      child: Text(username),
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
                Navigator.of(context).pushReplacementNamed(IndexPage.route);
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
