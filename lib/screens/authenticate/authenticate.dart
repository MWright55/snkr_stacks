import 'package:flutter/material.dart';
import 'package:snkr_stacks/screens/authenticate/vndy_login.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: VndyLogin(),
      //child: Home(),
    );
  }
}
