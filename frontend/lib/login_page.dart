import 'package:flutter/material.dart';

class UserLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: login_page(context),
      ),
    );
  }

  Widget login_page(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          height: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Insta Pic',
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(height: 55.0),
              Container(
                padding: const EdgeInsets.all(13.0),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'Carol',
                      ),
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    SizedBox(height: 45.0),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: FlatButton(
                        child: Text(
                          'Login',
                          style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () => try_login(context),
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      )
    );
  }

  void try_login(BuildContext context) {
    var session = 'dummy';
    Navigator.of(context).pop(session);
  }
}

// vim: set ts=2 sw=2 expandtab:
