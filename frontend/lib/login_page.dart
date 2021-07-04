import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'photo_page.dart';
import 'user.dart';


// login page
class UserLoginPage extends StatefulWidget {
  static const String route = '/login';

  final String title;

  UserLoginPage({
    required this.title,
  });

  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLoginPage> {
  final double width = 400;
  final double height = 600;
  final TextEditingController _username_controller = TextEditingController();
  final TextEditingController _password_controller = TextEditingController();

  String? _error_message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: width,
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Insta Pic',
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(height: 55.0),
              loginPage(context),
            ],
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    _username_controller.dispose();
    _password_controller.dispose();
    super.dispose();
  }

  Widget loginPage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _username_controller,
            decoration: InputDecoration(
              labelText: 'Username',
              hintText: 'Carol',
            ),
          ),
          TextField(
            obscureText: true,
            controller: _password_controller,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
          ),
          Opacity(
            opacity: _error_message != null ? 1.0 : 0.0,
            child: Text(
              _error_message ?? "<Error>",
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                color: Colors.red,
              ),
            )
          ),
          SizedBox(height: 45.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                child: Text(
                  'SignIn',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.lightBlue,
                  ),
                ),
                onPressed: () => signin(context),
              ),
              TextButton(
                child: Text(
                  'SignUp',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.red,
                  ),
                ),
                onPressed: () => signup(context),
              ),
            ],
          ),
        ],
      )
    );
  }

  void signin(BuildContext context) async {
    if (_username_controller.text != '' && _password_controller.text != '') {
      final resp = await http.post(
        Uri.base.replace(path: Uri.base.path + 'api/user/signin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': _username_controller.text,
          'password': _password_controller.text,
        })
      );

      switch (resp.statusCode) {
        case 201:
          // save cookie
          Map<String, String> session = json.decode(utf8.decode(resp.bodyBytes));
          User.save(session);
          Navigator.of(context).pushNamed(InstaPicPage.route);
          break;
        case 403:
          setState( () {
            _error_message = "fail to signin, invalid username / password";
          });
          break;
        default:
          print('fail to login: ${resp.statusCode}');
          setState( () {
            _error_message = "Unkown error ${resp.statusCode}";
          });
          throw Exception('fail to login: ${resp.statusCode}');
      }
    }
  }

  void signup(BuildContext context) async {
    if (_username_controller.text != '' && _password_controller.text != '') {
      final resp = await http.post(
        Uri.base.replace(path: Uri.base.path + 'api/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': _username_controller.text,
          'password': _password_controller.text,
        })
      );

      switch (resp.statusCode) {
        case 201:
          // save cookie
          Map<String, String> session = json.decode(utf8.decode(resp.bodyBytes));
          User.save(session);
          Navigator.of(context).pushNamed(InstaPicPage.route);
          break;
        case 409:
          setState( () {
            _error_message = "user already exist ${_username_controller.text}";
          });
          break;
        default:
          print('fail to login: ${resp.statusCode}');
          setState( () {
            _error_message = "Unkown error ${resp.statusCode}";
          });
          throw Exception('fail to login: ${resp.statusCode}');
      }
    }
  }
}

// vim: set ts=2 sw=2 expandtab:
