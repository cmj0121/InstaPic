import 'package:flutter/material.dart';

class User extends StatelessWidget {
  final String username;

  User(@required this.username);

  @override
  Widget build(BuildContext context) {
    return Text(username);
  }
}

// vim: set ts=2 sw=2 expandtab:
