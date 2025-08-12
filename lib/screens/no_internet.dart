import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({Key? key}) : super(key: key);
  static const routeName = '/no_internet.dart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height, //Get.height = MediaQuery.of(context).size.height
        width: Get.width, //Get.width = MediaQuery.of(context).size.width
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Here I am using an svg icon
            Icon(
              Icons.wifi,
              size: 200,
              //width: 200,
              //height: 200,
              color: Colors.red,
            ),
            const SizedBox(height: 30),
            const Text(
              'Internet Connection lost!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Text(
              'Please check your connection and try again.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
