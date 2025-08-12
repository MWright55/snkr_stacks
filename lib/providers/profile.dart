import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Profile with ChangeNotifier {
  final String userName;
  final String email;
  final String userType;
  final String userID;
  Profile(
      {required this.userName,
      required this.email,
      required this.userID,
      required this.userType});
}
