import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;


class User extends StatelessWidget {
  static const String session_key = 'session';
  static const String username_key = 'username';

  final String? username;

  User(this.username);

  factory User.fromCookie() {
    String? username = html.window.localStorage[User.username_key];
    if (username != null && username == '') {
      // set username as null if empty
      username = null;
    }

    return User(username);
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
                User.logout();
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

  static void save(Map<String, String> json) {
    // save tookie
    html.window.localStorage[User.session_key] = json['session']!;
    html.window.localStorage[User.username_key] = json['username']!;
  }

  static void logout() {
    // remove the session from local storage
    html.window.localStorage.remove(User.session_key);
    html.window.localStorage.remove(User.username_key);
  }

  String session() {
    return html.window.localStorage[User.session_key] ?? '';
  }
}

// vim: set ts=2 sw=2 expandtab:
