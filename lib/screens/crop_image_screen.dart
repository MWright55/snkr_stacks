import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

class CropImageScreen extends StatefulWidget {
  final Uint8List imageData;

  const CropImageScreen({Key? key, required this.imageData}) : super(key: key);

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  final CropController _controller = CropController();
  bool _isCropping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crop Image')),
      body: _isCropping
          ? Center(child: CircularProgressIndicator())
          : Crop(
              image: widget.imageData,
              controller: _controller,
              onCropped: (croppedData) {
                Navigator.pop(context, croppedData);
              },
              initialSize: 0.8,
              baseColor: Colors.black,
              maskColor: Colors.black.withAlpha(100),
              withCircleUi: false,
              cornerDotBuilder: (size, edgeAlignment) => const DotControl(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => _isCropping = true);
          _controller.crop();
        },
        child: Icon(Icons.check),
      ),
    );
  }
}

class DotControl extends StatelessWidget {
  const DotControl();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    );
  }
}
