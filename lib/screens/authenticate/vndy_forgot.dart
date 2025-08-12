import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snkr_stacks/providers/resources.dart' as Resources;
import 'package:snkr_stacks/services/auth.dart';
import 'package:snkr_stacks/shared/loading.dart';

class VndyForgot extends StatefulWidget {
  static final String id = 'VndyForgot';

  @override
  _VndyForgotState createState() => _VndyForgotState();
}

class _VndyForgotState extends State<VndyForgot> {
  final _formKey = GlobalKey<FormState>();

  // final AuthService _auth = AuthService();
  bool loading = false;

  late String _email;
  String error = '';

  _submit() async {
    //print('Now in _submit!!!');
    error = '';
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      //print(_email);

      //_auth.sendPasswordResetEmail(_email);
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password Reset Email Sent, Double Check Spam Folder', textAlign: TextAlign.center),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } //end if
  } //end _submit

  _passwordCheck() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      _formKey.currentState!.save();
      _submit();
    } else {
      setState(() => loading = false);
    }
  } // _passwordCheck

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(Resources.LOGO, fit: BoxFit.cover, height: 125),
                      Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(fontSize: 18.0, fontFamily: GoogleFonts.bebasNeue().fontFamily, fontWeight: FontWeight.bold, color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey)),
                                  ),
                                  validator: (input) => !input!.contains('@') ? 'Please enter a valid email' : null,
                                  onSaved: (input) => _email = input!,
                                ),
                              ),
                              SizedBox(height: 35.0),
                              Text(error, style: TextStyle(color: Colors.red, fontSize: 18.0)),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(30.0),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    minimumSize: Size(0, 48),
                                    textStyle: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      wordSpacing: 2.0,
                                      letterSpacing: 1.9,
                                      fontFamily: GoogleFonts.bebasNeue().fontFamily,
                                    ),
                                    backgroundColor: Colors.black,
                                  ),
                                  child: Text('Reset Password'),
                                  onPressed: _passwordCheck,
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Back to Login', style: TextStyle(fontSize: 18.0, fontFamily: GoogleFonts.bebasNeue().fontFamily)),
                                  SizedBox(width: 5.0),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 18.0,

                                        ///Accent Color
                                        color: Theme.of(context).colorScheme.tertiary,
                                        fontFamily: GoogleFonts.bebasNeue().fontFamily,
                                        fontWeight: FontWeight.bold,
                                        //  decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
