import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        //child: SpinKitFadingCube(
        //child: SpinKitPianoWave(
        child: SpinKitWave(
          //color: Colors.black,
          color: Colors.grey,
          size: 50.0,
        ),
      ),
    );
  }
}
