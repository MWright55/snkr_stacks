import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snkr_stacks/providers/resources.dart' as Resources;
import 'package:snkr_stacks/services/auth.dart';
import 'package:snkr_stacks/shared/loading.dart';

class VndySignup extends StatefulWidget {
  static final String id = 'VndySignup';

  @override
  _VndySignupState createState() => _VndySignupState();
}

class _VndySignupState extends State<VndySignup> {
  final _formKey = GlobalKey<FormState>();

  final AuthService _auth = AuthService();
  bool loading = false;

  late String _email, _password, _passwordConfirm, _userName;
  String error = '';
  late String resultMsg;
  dynamic result;

  var passwordTemp;

  _submit() async {
    error = '';
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      result = await _auth.registerWithEmailAndPassword(_email, _password, _userName);
      print("***result =>$result");

      if (result == null) {
        setState(() => error = 'An unexpected error has occurred');
      } else if (result.toString().contains('email-already-in-use')) {
        setState(() => error = 'The email address is already in use by another account');
      } else if (result.toString().contains('invalid-email')) {
        setState(() => error = 'This Email address is not valid. Please Select another');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account Created', textAlign: TextAlign.center),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } //end if
    print('### about to exit _submit');
  } //end _submit

  _passwordCheck() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      _formKey.currentState!.save();

      if (_password != _passwordConfirm) {
        setState(() => error = 'Passwords do not match! Confirm Passwords');
        loading = false;
      } else {
        setState(() => loading = false);
        _submit();
      }
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
                                    labelText: 'Username',
                                    labelStyle: TextStyle(fontFamily: GoogleFonts.bebasNeue().fontFamily, fontWeight: FontWeight.bold, color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey)),
                                  ),
                                  validator: (input) => input!.trim().isEmpty ? 'Must be at least 4 characters' : null,
                                  onSaved: (input) => _userName = input!,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(fontFamily: GoogleFonts.bebasNeue().fontFamily, fontWeight: FontWeight.bold, color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey)),
                                  ),
                                  validator: (input) => !input!.contains('@') ? 'Please enter a valid email' : null,
                                  onSaved: (input) => _email = input!,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(fontFamily: GoogleFonts.bebasNeue().fontFamily, fontWeight: FontWeight.bold, color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey)),
                                  ),
                                  validator: (input) => input!.length < 6 ? 'Must be at least 6 characters' : null,
                                  onSaved: (input) => _password = input!,
                                  obscureText: true,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    labelStyle: TextStyle(fontFamily: GoogleFonts.bebasNeue().fontFamily, fontWeight: FontWeight.bold, color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey)),
                                  ),
                                  validator: (input) {
                                    if (input!.isEmpty) {
                                      return 'Please enter a Password';
                                    }
                                    if (input.length < 6) {
                                      return 'Must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                  onSaved: (input) => _passwordConfirm = input!,
                                  obscureText: true,
                                ),
                              ),
                              SizedBox(height: 32.0),
                              Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0)),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(30.0),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    minimumSize: Size(0, 48),
                                    textStyle: TextStyle(
                                      fontFamily: GoogleFonts.bebasNeue().fontFamily,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      wordSpacing: 2.0,
                                      letterSpacing: 1.9,
                                    ),
                                    backgroundColor: Colors.black,
                                  ),
                                  child: Text('Sign Up'),
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
                                        //  decoration: TextDecoration.underline
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
