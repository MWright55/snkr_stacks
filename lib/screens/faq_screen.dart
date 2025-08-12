import 'package:flutter/material.dart';
import 'package:snkr_stacks/providers/resources.dart' as Resources;

class FAQScreen extends StatefulWidget {
  static const routeName = '/faq-screen';

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, surfaceTintColor: Colors.transparent, elevation: 0.0, centerTitle: true, title: Text('FAQ')),
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
                    'Frequently Asked Questions',
                    style: TextStyle(fontSize: 26.5, color: Colors.black, height: 1.35, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Q: Lorem ipsum dolor sit amet, consectetur adipiscing elit,  ',
                    style: TextStyle(fontSize: 18.5, color: Colors.black, height: 1.35, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'A: Lorem ipsum dolor sit amet, consectetur adipiscing elit, ',
                    style: TextStyle(
                      fontSize: 15.5,
                      color: Colors.black,
                      height: 1.35,
                      // fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Q: Lorem ipsum dolor sit amet, consectetur adipiscing elit,  ',
                    style: TextStyle(fontSize: 18.5, color: Colors.black, height: 1.35, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'A: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. ',
                    style: TextStyle(fontSize: 15.5, color: Colors.black, height: 1.35, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Q: Lorem ipsum dolor sit amet, consectetur adipiscing elit,  ',
                    style: TextStyle(fontSize: 18.5, color: Colors.black, height: 1.35, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'A: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. ',
                    style: TextStyle(
                      fontSize: 15.5,
                      color: Colors.black,
                      height: 1.35,
                      //ontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Q: Lorem ipsum dolor sit amet, consectetur adipiscing elit,  ',
                    style: TextStyle(fontSize: 18.5, color: Colors.black, height: 1.35, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'A: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. ',
                    style: TextStyle(
                      fontSize: 15.5,
                      color: Colors.black,
                      height: 1.35,
                      //fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Q: Lorem ipsum dolor sit amet, consectetur adipiscing elit,  ',
                    style: TextStyle(fontSize: 18.5, color: Colors.black, height: 1.35, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'A: Lorem ipsum dolor sit amet, consectetur adipiscing elit, dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. ',
                    style: TextStyle(
                      fontSize: 15.5,
                      color: Colors.black,
                      height: 1.35,
                      //fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Q: Lorem ipsum dolor sit amet, consectetur adipiscing elit,  ',
                    style: TextStyle(fontSize: 18.5, color: Colors.black, height: 1.35, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'A: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.  commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. ',
                    style: TextStyle(
                      fontSize: 15.5,
                      color: Colors.black,
                      height: 1.35,
                      //fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Q: Lorem ipsum dolor sit amet, consectetur adipiscing elit,  ',
                    style: TextStyle(fontSize: 18.5, color: Colors.black, height: 1.35, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'A: Lorem ipsum dolor sit amet, consectetur adipiscing elit, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. ',
                    style: TextStyle(
                      fontSize: 15.5,
                      color: Colors.black,
                      height: 1.35,
                      //fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  //'Thank You For Your Business',
                  Resources.LINE_END,
                  style: TextStyle(fontSize: 22.5, color: Colors.black, height: 1.35, fontWeight: FontWeight.w600),
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
}
