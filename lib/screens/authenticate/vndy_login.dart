import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:snkr_stacks/providers/resources.dart' as Resources;
import 'package:snkr_stacks/responsive/dimensions.dart';
import 'package:snkr_stacks/screens/authenticate/vndy_forgot.dart';
import 'package:snkr_stacks/screens/authenticate/vndy_signup.dart';
import 'package:snkr_stacks/services/auth.dart';
import 'package:snkr_stacks/shared/loading.dart';

class VndyLogin extends StatefulWidget {
  static final String id = 'VndyLogin';

  @override
  _VndyLoginState createState() => _VndyLoginState();
}

class _VndyLoginState extends State<VndyLogin> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  late String _email, _password;
  String error = '';

  _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      _formKey.currentState!.save();

      dynamic result = await _auth.signInWithEmailAndPassword(_email, _password);

      if (result == null) {
        setState(() => error = 'ERROR SIGNING IN. PLEASE CHECK CREDENTIALS.');
        loading = false;
      }

      //print(_email);
      //print(_password);
    }
  }

  _launchAppleURL() async {
    final Uri _url = Uri.parse('https://apps.apple.com/us/app/vndy/id1638162193');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  _launchAndroidURL() async {
    final Uri _url = Uri.parse('https://play.google.com/store/apps/details?id=betatest.vndy&hl=en_US');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: LayoutBuilder(
    //     builder: (context, constraints) {
    //       return Row(
    //         children: [
    //           // Left Side
    //           Expanded(
    //             child: Container(
    //               color: Colors.blueAccent, // Unique color for left side
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   // Logo Area
    //                   Container(
    //                     color: Colors.greenAccent, // Unique color for logo
    //                     height: 100,
    //                     width: 100,
    //                     child: Center(child: Text('Logo')), // Placeholder logo
    //                   ),
    //
    //                   SizedBox(height: 20),
    //
    //                   // Text Area
    //                   Column(
    //                     children: [
    //                       Text(
    //                         'Business Name',
    //                         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    //                       ),
    //                       Text(
    //                         'Tagline goes here',
    //                         style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
    //                       ),
    //                     ],
    //                   ),
    //
    //                   SizedBox(height: 20),
    //
    //                   // Images Area
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       Container(
    //                         color: Colors.redAccent, // Unique color for image 1
    //                         height: 25,
    //                         width: 80,
    //                       ),
    //                       SizedBox(width: 20),
    //                       Container(
    //                         color: Colors.orangeAccent, // Unique color for image 2
    //                         height: 25,
    //                         width: 80,
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //
    //           // Right Side
    //           Expanded(
    //             child: Container(
    //               color: Colors.purpleAccent, // Unique color for right side
    //               child: Center(
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(16.0),
    //                   child: Column(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: [
    //                       // Username Field
    //                       TextField(
    //                         decoration: InputDecoration(
    //                           labelText: 'Username',
    //                           border: OutlineInputBorder(),
    //                           filled: true,
    //                           fillColor: Colors.white,
    //                         ),
    //                       ),
    //
    //                       SizedBox(height: 20),
    //
    //                       // Password Field
    //                       TextField(
    //                         decoration: InputDecoration(
    //                           labelText: 'Password',
    //                           border: OutlineInputBorder(),
    //                           filled: true,
    //                           fillColor: Colors.white,
    //                         ),
    //                         obscureText: true,
    //                       ),
    //
    //                       SizedBox(height: 20),
    //
    //                       // Submit Button
    //                       TextButton(
    //                         style: TextButton.styleFrom(
    //                             foregroundColor: Colors.white,
    //                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //                             minimumSize: Size(0, 48),
    //                             textStyle: TextStyle(
    //                               fontFamily: GoogleFonts.bebasNeue().fontFamily,
    //                               fontSize: 18.0,
    //                               fontWeight: FontWeight.w400,
    //                               color: Colors.white,
    //                               wordSpacing: 2.0,
    //                               letterSpacing: 1.9,
    //                             ),
    //                             backgroundColor: Colors.teal),
    //                         child: Text('Login'),
    //                         onPressed: _submit,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       );
    //     },
    //   ),
    // );

    if (MediaQuery.of(context).size.width < mobileWidth) {
      ///Mobile View
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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(fontSize: 20.0, fontFamily: GoogleFonts.bebasNeue().fontFamily, fontWeight: FontWeight.bold, color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
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
                                    labelStyle: TextStyle(fontSize: 20.0, fontFamily: GoogleFonts.bebasNeue().fontFamily, fontWeight: FontWeight.bold, color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                  ),
                                  validator: (input) => input!.length < 6 ? 'Must be at least 6 characters' : null,
                                  onSaved: (input) => _password = input!,
                                  obscureText: true,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                alignment: Alignment(1.0, 0.0),
                                padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                                child: InkWell(
                                  onTap: () {
                                    print("Forgot Password !!!");
                                    Navigator.pushNamed(context, VndyForgot.id);
                                  },
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      fontSize: 20.0,

                                      ///Accent Color
                                      color: Theme.of(context).colorScheme.tertiary,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: GoogleFonts.bebasNeue().fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(30),
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
                                  child: Text('Login'),
                                  onPressed: _submit,
                                ),
                              ),
                              SizedBox(height: 12.0),
                              Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0)),
                              SizedBox(height: 35.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('New to VNDY ?', style: TextStyle(fontSize: 18.0, fontFamily: GoogleFonts.bebasNeue().fontFamily)),
                                  SizedBox(width: 5.0),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, VndySignup.id);
                                    },
                                    child: Text(
                                      'Register',
                                      style: TextStyle(
                                        fontSize: 18.0,

                                        ///Accent Color
                                        color: Theme.of(context).colorScheme.tertiary,
                                        fontFamily: GoogleFonts.bebasNeue().fontFamily,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
    } else if (MediaQuery.of(context).size.width < tabletWidth) {
      ///Tablet View
      return loading
          ? Loading()
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                body: Row(
                  children: [
                    // Left Column
                    Expanded(
                      flex: 1,

                      ///Left Column
                      child: Container(
                        // color: Colors.blueAccent, // Unique color for left side
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Logo Area
                            Container(
                              // color: Colors.greenAccent, // Unique color for logo
                              height: 50,
                              width: 50,
                              child: Center(
                                // child: Image.asset(
                                //   Resources.PHONE_MODEL,
                                //   fit: BoxFit.cover,
                                //   height: 350,
                                // ),
                                child: Image.asset(Resources.LOGO, fit: BoxFit.cover, height: 125),
                              ), // Placeholder logo
                            ),

                            SizedBox(height: 20),

                            // Text Area
                            Column(
                              children: [
                                Text('VNDY App', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                Text('A new way to shop online', style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                              ],
                            ),

                            SizedBox(height: 20),

                            // Images Area
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: IconButton(
                                    icon: Image.asset(Resources.APPLE_BUTTON, fit: BoxFit.cover, height: 50, width: 150),
                                    onPressed: () {
                                      _launchAppleURL();
                                      print("Apple Button Pressed !!!");
                                    },
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  child: IconButton(
                                    icon: Image.asset(Resources.ANDROID_BUTTON, fit: BoxFit.cover, height: 50, width: 150),
                                    onPressed: () {
                                      _launchAndroidURL();
                                      print("Android Button Pressed !!!");
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Right Column
                    Expanded(
                      flex: 2,

                      ///Right Column
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(Resources.LOGO, fit: BoxFit.cover, height: 125),
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          labelStyle: TextStyle(fontSize: 20.0, fontFamily: GoogleFonts.bebasNeue().fontFamily, fontWeight: FontWeight.bold, color: Colors.grey),
                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
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
                                          labelStyle: TextStyle(fontSize: 20.0, fontFamily: GoogleFonts.bebasNeue().fontFamily, fontWeight: FontWeight.bold, color: Colors.grey),
                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                        ),
                                        validator: (input) => input!.length < 6 ? 'Must be at least 6 characters' : null,
                                        onSaved: (input) => _password = input!,
                                        obscureText: true,
                                      ),
                                    ),
                                    SizedBox(height: 5.0),
                                    Container(
                                      alignment: Alignment(1.0, 0.0),
                                      padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                                      child: InkWell(
                                        onTap: () {
                                          print("Forgot Password !!!");
                                          Navigator.pushNamed(context, VndyForgot.id);
                                        },
                                        child: Text(
                                          'Forgot Password',
                                          style: TextStyle(
                                            fontSize: 20.0,

                                            ///Accent Color
                                            color: Theme.of(context).colorScheme.tertiary,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: GoogleFonts.bebasNeue().fontFamily,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20.0),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(30),
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
                                        child: Text('Login'),
                                        onPressed: _submit,
                                      ),
                                    ),
                                    SizedBox(height: 12.0),
                                    Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0)),
                                    SizedBox(height: 35.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('New to VNDY ?', style: TextStyle(fontSize: 18.0, fontFamily: GoogleFonts.bebasNeue().fontFamily)),
                                        SizedBox(width: 5.0),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context, VndySignup.id);
                                          },
                                          child: Text(
                                            'Register',
                                            style: TextStyle(
                                              fontSize: 18.0,

                                              ///Accent Color
                                              color: Theme.of(context).colorScheme.tertiary,
                                              fontFamily: GoogleFonts.bebasNeue().fontFamily,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
    } else {
      ///Desktop View
      return loading
          ? Loading()
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                body: Row(
                  children: [
                    /// Left Column
                    Expanded(
                      flex: 1,
                      child: Container(
                        // color: Colors.blueAccent, // Unique color for left side
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Logo Area
                            Container(
                              // color: Colors.greenAccent, // Unique color for logo
                              height: 500,
                              width: 500,
                              child: Center(
                                child: Image.asset(Resources.PHONE_MODEL, fit: BoxFit.cover, height: 350),
                                //child: Image.asset(Resources.LOGO, fit: BoxFit.cover, height: 125),
                              ), // Placeholder logo
                            ),

                            SizedBox(height: 20),

                            // Text Area
                            Column(
                              children: [
                                Text('VNDY App', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                Text('A new way to shop online', style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                              ],
                            ),

                            SizedBox(height: 20),

                            // Images Area
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: IconButton(
                                    icon: Image.asset(Resources.APPLE_BUTTON, fit: BoxFit.cover, height: 50, width: 200),
                                    onPressed: () {
                                      _launchAppleURL();
                                      print("Apple Button Pressed !!!");
                                    },
                                  ),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  child: IconButton(
                                    icon: Image.asset(Resources.ANDROID_BUTTON, fit: BoxFit.cover, height: 50, width: 200),
                                    onPressed: () {
                                      _launchAndroidURL();
                                      print("Android Button Pressed !!!");
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// Right Column
                    Expanded(
                      flex: 1,

                      ///Right Column
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(Resources.LOGO, fit: BoxFit.cover, height: 125),
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          labelStyle: TextStyle(fontSize: 20.0, fontFamily: GoogleFonts.bebasNeue().fontFamily, fontWeight: FontWeight.bold, color: Colors.grey),
                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
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
                                          labelStyle: TextStyle(fontSize: 20.0, fontFamily: GoogleFonts.bebasNeue().fontFamily, fontWeight: FontWeight.bold, color: Colors.grey),
                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                        ),
                                        validator: (input) => input!.length < 6 ? 'Must be at least 6 characters' : null,
                                        onSaved: (input) => _password = input!,
                                        obscureText: true,
                                      ),
                                    ),
                                    SizedBox(height: 5.0),
                                    Container(
                                      alignment: Alignment(1.0, 0.0),
                                      padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                                      child: InkWell(
                                        onTap: () {
                                          print("Forgot Password !!!");
                                          Navigator.pushNamed(context, VndyForgot.id);
                                        },
                                        child: Text(
                                          'Forgot Password',
                                          style: TextStyle(
                                            fontSize: 20.0,

                                            ///Accent Color
                                            color: Theme.of(context).colorScheme.tertiary,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: GoogleFonts.bebasNeue().fontFamily,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20.0),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(30),
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
                                        child: Text('Login'),
                                        onPressed: _submit,
                                      ),
                                    ),
                                    SizedBox(height: 12.0),
                                    Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0)),
                                    SizedBox(height: 35.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('New to VNDY ?', style: TextStyle(fontSize: 18.0, fontFamily: GoogleFonts.bebasNeue().fontFamily)),
                                        SizedBox(width: 5.0),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context, VndySignup.id);
                                          },
                                          child: Text(
                                            'Register',
                                            style: TextStyle(
                                              fontSize: 18.0,

                                              ///Accent Color
                                              color: Theme.of(context).colorScheme.tertiary,
                                              fontFamily: GoogleFonts.bebasNeue().fontFamily,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
    }

    //old code
    // return loading
    //     ? Loading()
    //     : GestureDetector(
    //         onTap: () => FocusScope.of(context).unfocus(),
    //         child: Scaffold(
    //           body: Center(
    //             child: SingleChildScrollView(
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: <Widget>[
    //                   Image.asset(Resources.LOGO, fit: BoxFit.cover, height: 125),
    //                   Form(
    //                     key: _formKey,
    //                     child: Column(
    //                       mainAxisSize: MainAxisSize.min,
    //                       children: <Widget>[
    //                         Padding(
    //                           padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
    //                           child: TextFormField(
    //                             decoration: InputDecoration(
    //                                 labelText: 'Email',
    //                                 labelStyle: TextStyle(fontSize: 20.0, fontFamily: GoogleFonts.bebasNeue().fontFamily, fontWeight: FontWeight.bold, color: Colors.grey),
    //                                 focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black))),
    //                             validator: (input) => !input!.contains('@') ? 'Please enter a valid email' : null,
    //                             onSaved: (input) => _email = input!,
    //                           ),
    //                         ),
    //                         Padding(
    //                           padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
    //                           child: TextFormField(
    //                             decoration: InputDecoration(
    //                                 labelText: 'Password',
    //                                 labelStyle: TextStyle(fontSize: 20.0, fontFamily: GoogleFonts.bebasNeue().fontFamily, fontWeight: FontWeight.bold, color: Colors.grey),
    //                                 focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black))),
    //                             validator: (input) => input!.length < 6 ? 'Must be at least 6 characters' : null,
    //                             onSaved: (input) => _password = input!,
    //                             obscureText: true,
    //                           ),
    //                         ),
    //                         SizedBox(height: 5.0),
    //                         Container(
    //                           alignment: Alignment(1.0, 0.0),
    //                           padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
    //                           child: InkWell(
    //                             onTap: () {
    //                               print("Forgot Password !!!");
    //                               Navigator.pushNamed(context, VndyForgot.id);
    //                             },
    //                             child: Text(
    //                               'Forgot Password',
    //                               style: TextStyle(
    //                                 fontSize: 20.0,
    //
    //                                 ///Accent Color
    //                                 color: Colors.deepOrange,
    //                                 fontWeight: FontWeight.bold,
    //                                 fontFamily: GoogleFonts.bebasNeue().fontFamily,
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                         SizedBox(height: 20.0),
    //                         Container(
    //                           width: double.infinity,
    //                           padding: EdgeInsets.all(30),
    //                           child: TextButton(
    //                             style: TextButton.styleFrom(
    //                                 foregroundColor: Colors.white,
    //                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //                                 minimumSize: Size(0, 48),
    //                                 textStyle: TextStyle(
    //                                   fontFamily: GoogleFonts.bebasNeue().fontFamily,
    //                                   fontSize: 18.0,
    //                                   fontWeight: FontWeight.w400,
    //                                   color: Colors.white,
    //                                   wordSpacing: 2.0,
    //                                   letterSpacing: 1.9,
    //                                 ),
    //                                 backgroundColor: Colors.black),
    //                             child: Text('Login'),
    //                             onPressed: _submit,
    //                           ),
    //                         ),
    //                         SizedBox(height: 12.0),
    //                         Text(
    //                           error,
    //                           style: TextStyle(color: Colors.red, fontSize: 14.0),
    //                         ),
    //                         SizedBox(height: 35.0),
    //                         Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: <Widget>[
    //                             Text(
    //                               'New to VNDY ?',
    //                               style: TextStyle(fontSize: 18.0, fontFamily: GoogleFonts.bebasNeue().fontFamily),
    //                             ),
    //                             SizedBox(width: 5.0),
    //                             InkWell(
    //                               onTap: () {
    //                                 Navigator.pushNamed(context, VndySignup.id);
    //                               },
    //                               child: Text(
    //                                 'Register',
    //                                 style: TextStyle(
    //                                   fontSize: 18.0,
    //
    //                                   ///Accent Color
    //                                   color: Colors.deepOrange,
    //                                   fontFamily: GoogleFonts.bebasNeue().fontFamily,
    //                                   fontWeight: FontWeight.bold,
    //                                 ),
    //                               ),
    //                             )
    //                           ],
    //                         )
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
  }
}
