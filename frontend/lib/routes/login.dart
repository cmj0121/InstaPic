import 'dart:convert';
import 'package:flutter/material.dart';

import 'index.dart';
import '../requests.dart';
import '../user.dart';


class LoginPage extends StatefulWidget {
  static const String route = '/login';

  final String title;
  final double width;
  final double height;

  LoginPage({
    this.title = 'Insta Pic',
    this.width = 400,
    this.height = 600,
  });

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final TextEditingController _username_controller = TextEditingController();
  final TextEditingController _password_controller = TextEditingController();

  String? _error_message;

  @override
  void dispose() {
    _username_controller.dispose();
    _password_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: api_username(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // show the loading page
          return CircularProgressIndicator();
        }

        final String username = snapshot.data!;
        if (username != '') {
          WidgetsBinding.instance?.addPostFrameCallback(
             (_) => Navigator.of(context).pushReplacementNamed(IndexPage.route)
          );
        }

        return builder(context);
      },
    );
  }

  Widget builder(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: widget.width,
          height: widget.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Insta Pic',
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(height: 55.0),
              loginCard(context),
            ],
          ),
        ),
      )
    );
  }

  Widget loginCard(BuildContext context) {
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
          SizedBox(height: 15.0),
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
                onPressed: () => signin_signup('/api/user/signin'),
              ),
              TextButton(
                child: Text(
                  'SignUp',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.red,
                  ),
                ),
                onPressed: () => signin_signup('/api/user'),
              ),
            ],
          ),
        ],
      )
    );
  }

  void signin_signup(String path) async {
    var resp = await http_post(path, {
      'username': _username_controller.text,
      'password': _password_controller.text,
    });

    switch (resp.statusCode) {
      case 201:
        // save cookie and back to index
        Map<String, dynamic> data = json.decode(utf8.decode(resp.bodyBytes));

        save_session(data[sessionKey] as String);
        Navigator.of(context).pushReplacementNamed(IndexPage.route);
        break;
      case 403:
        setState( () {
          _error_message = 'invalid username / password';
        });
        break;
      case 409:
        setState( () {
          _error_message = 'user ${_username_controller.text} already regist';
        });
        break;
      default:
        setState( () {
          _error_message = 'Unknown error: ${resp.statusCode}';
        });
        break;
    }
  }
}

// vim: set ts=2 sw=2 expandtab:
