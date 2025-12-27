// Prevent web runtime crashes by stubbing out mobile plugins.
import 'dart:io' show Platform; // ONLY USED ON MOBILE — never executed on Web

bool isWebViewSupported() => false;
bool isImagePickerSupported() => false;
bool isImageCropperSupported() => false;


