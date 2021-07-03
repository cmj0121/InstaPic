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

  void signin(BuildContext context) {
    if (_username_controller.text != '' && _password_controller.text != '') {
      User user = User(_username_controller.text);
      user.save();
      Navigator.of(context).pushNamed(InstaPicPage.route);
    }
  }

  void signup(BuildContext context) {
    if (_username_controller.text != '' && _password_controller.text != '') {
      User user = User(_username_controller.text);
      user.save();
      Navigator.of(context).pushNamed(InstaPicPage.route);
    }
  }
}

// vim: set ts=2 sw=2 expandtab:
