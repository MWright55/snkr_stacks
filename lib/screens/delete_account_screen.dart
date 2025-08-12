import 'dart:async';
import 'package:flutter/material.dart';
import 'package:snkr_stacks/providers/resources.dart' as Resources;
import 'package:snkr_stacks/services/auth.dart';

class DeleteAccountScreen extends StatefulWidget {
  static const routeName = '/delete_account_screen.dart';

  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  late Timer _timer;

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0.0, centerTitle: true, title: Text('Delete Account')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            //scrollDirection: Axis.horizontal,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Request for Account Deletion',
                    style: TextStyle(fontSize: 18.5, color: Colors.black, height: 1.35, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'By selecting the Delete Account button below, your account information will be deleted and access to this application will be removed. Please press and hold the Delete button for 10 seconds.',
                    style: TextStyle(fontSize: 13.5, color: Colors.black, height: 1.35, fontWeight: FontWeight.w800),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'If this is not your intent, please return to the previous screen ',
                    style: TextStyle(fontSize: 13.5, color: Colors.black, height: 1.35, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: 100),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: GestureDetector(
                    onTapDown: (_) {
                      print('Delete Button held...');
                      _timer = Timer(Duration(seconds: 10), onDeletePress);
                    },
                    onTapUp: (_) {
                      print('Delete Button released...');
                      _timer.cancel();
                    },
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: Size(0, 48),
                        textStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700, color: Colors.white, wordSpacing: 2.0, letterSpacing: 0.9),
                        backgroundColor: Colors.red,
                      ),
                      child: Text('Delete Account'),
                      onLongPress: () {
                        print('Delete Button held');
                      },
                      onPressed: () {
                        print('Delete Button Pressed');
                      },
                    ),
                  ),
                ),
                SizedBox(height: 200),
                Text(
                  'Thank You',
                  style: TextStyle(fontSize: 18.5, color: Colors.black, height: 1.35, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 50),
                Image.asset(Resources.LOGO, fit: BoxFit.cover, height: 60),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDeletePress() {
    print('onDeletePress called');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure you want to Delete Account?'),
        content: Text('These actions are not reversible. A new account will need to be created!'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.blue),
            child: Text('CANCEL'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('DELETE'),
            onPressed: () {
              print('do Nothing');
            },
            onLongPress: () {
              print('2nd long press');
              confirmDelete();
            },
          ),
        ],
      ),
    );
  }

  void confirmDelete() {
    print('confirm Delete called');
    _auth.deleteUser();
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
