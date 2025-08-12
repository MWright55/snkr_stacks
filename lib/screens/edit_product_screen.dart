// import 'dart:io';
// import 'dart:typed_data';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart' as syspaths;
// import 'package:provider/provider.dart';
// import 'package:snkr_stacks/providers/product.dart';
// import 'package:snkr_stacks/providers/products_provider.dart';
// import 'package:snkr_stacks/shared/loading.dart';
// import 'package:snkr_stacks/providers/resources.dart' as RESOURCES;
// import 'crop_image_screen.dart';
// import 'package:uuid/uuid.dart';
//
// class EditProductScreen extends StatefulWidget {
//   static const routeName = '/edit-product';
//
//   @override
//   _EditProductScreenState createState() => _EditProductScreenState();
// }
//
// class _EditProductScreenState extends State<EditProductScreen> {
//   final _priceFocusNode = FocusNode();
//   final _descriptionFocusNode = FocusNode();
//   final _imageUrlController = TextEditingController();
//   final _imageUrlFocusNode = FocusNode();
//   final _skuFocusNode = FocusNode();
//   final _form = GlobalKey<FormState>();
//
//   //final List<String> _statusList = ['New', 'Like-New', 'Used', 'Other'];
//   final List<String> _statusList = RESOURCES.STATUS_LIST;
//
//   //final List<String> _typeList = ['Apparel', 'Accessories', 'Footwear', 'Other'];
//   final List<String> _typeList = RESOURCES.TYPE_LIST;
//
//   final List<String> _sizeList = RESOURCES.SIZE_LIST;
//
//   var _editedProduct = Product(
//     id: 'empty',
//     title: '',
//     price: 0,
//     description: '',
//     imageUrl0: '',
//     imageUrl1: '',
//     imageUrl2: '',
//     sku: '',
//     size: 'X-Small',
//     shippingAddress: '',
//     shippingEmail: '',
//     status: 'New',
//     poster: '',
//     buyer: '',
//     type: 'Apparel',
//     shippingState: '',
//     shippingName: '',
//     postertimeStamp: '',
//     buyertimeStamp: '',
//     shippingPhone: '',
//     shippingZip: '',
//     shippingCity: '',
//     piToken: '',
//   );
//   var _initValues = {
//     'title': '',
//     'description': '',
//     'price': '',
//     'imageUrl0': '',
//     'imageUrl1': '',
//     'imageUrl2': '',
//     'sku': '',
//     'status': '',
//     'type': '',
//     'size': '',
//     'timeStamp': DateTime.now().toIso8601String(),
//     'poster': '',
//   };
//   var _isInit = true;
//   bool _isLoading = false;
//   late User? _user;
//
//   @override
//   void initState() {
//     _getCurrentUser();
//     _imageUrlFocusNode.addListener(_updateImageUrl);
//     super.initState();
//   }
//
//   _getCurrentUser() async {
//     _user = FirebaseAuth.instance.currentUser!;
//     //print("currentUser::::!!!> ${_user?.uid}");
//     //print("currentUser::::!!!> ${_user?.email}");
//     if (_user != null) {
//       setState(() {
//         this._user = _user;
//       });
//     } else {
//       //do something
//     }
//     //return _user;
//   }
//
//   late File? _pickedImage = null;
//   late File? _pickedImage0 = File('/fake/file/path');
//   late File? _pickedImage1 = File('/fake/file/path');
//   late File? _pickedImage2 = File('/fake/file/path');
//   late String? _oldImage0 = null;
//   late String? _oldImage1 = null;
//   late String? _oldImage2 = null;
//   late File? _storedImage = null;
//   late File? _storedImage0 = null;
//   late File? _storedImage1 = null;
//   late File? _storedImage2 = null;
//   late String? _urlLocation = null;
//
//   /// all _pickedImages and _storedImages
//   /// were set to : late File _name = File('')
//
//   // void _selectImage(File pickedImage) {
//   //   _pickedImage = pickedImage;
//   // }
//
//   Future<void> _takePicture(String urlLocation) async {
//     final picker = ImagePicker();
//     // final imageFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 600);
//     //
//     // if (imageFile == null) {
//     //   return;
//     // }
//     //
//     // //await cropImage(imageFile as File);
//
//     final pickedXFile = await picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
//
//     if (pickedXFile == null) {
//       print('User canceled image selection.');
//       return;
//     }
//
//     final File imageFile = File(pickedXFile.path);
//
//     // Proceed to your crop logic or image update logic
//     await cropImage(imageFile, context);
//
//     print('**after cropImage call**');
//
//     // final appDir = await syspaths.getApplicationDocumentsDirectory();
//     // final fileName = path.basename(_storedImage!.path);
//     // _pickedImage = await _storedImage!.copy('${appDir.path}/$fileName');
//
//     // Save cropped image with a unique name
//     final appDir = await syspaths.getApplicationDocumentsDirectory();
//     final uniqueFileName = '${const Uuid().v4()}.png';
//     final savedImage = await _storedImage!.copy('${appDir.path}/$uniqueFileName');
//
//     // Assign to _pickedImage
//     _pickedImage = savedImage;
//
//     switch (urlLocation) {
//       case 'imageUrl0':
//         {
//           print("imageUrl0 is selected");
//           setState(() {
//             _editedProduct = Product(
//               title: _editedProduct.title,
//               price: _editedProduct.price,
//               description: _editedProduct.description,
//               imageUrl0: _pickedImage.toString(),
//               imageUrl1: _editedProduct.imageUrl1,
//               imageUrl2: _editedProduct.imageUrl2,
//               id: _editedProduct.id,
//               isFavorite: _editedProduct.isFavorite,
//               sku: _editedProduct.sku,
//               status: _editedProduct.status,
//               type: _editedProduct.type,
//               size: _editedProduct.size,
//               shippingAddress: '',
//               shippingEmail: '',
//               poster: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//               shippingState: '',
//               buyer: '',
//               shippingName: '',
//               shippingPhone: '',
//               shippingZip: '',
//               shippingCity: '',
//               postertimeStamp: DateTime.now().toIso8601String(),
//               buyertimeStamp: '',
//               piToken: '',
//             );
//           });
//           _storedImage0 = _storedImage;
//           _pickedImage0 = _pickedImage!;
//           print("_storedImage: $_storedImage");
//           print("_storedImage0: $_storedImage0");
//           print("_storedImage1: $_storedImage1");
//           print("_storedImage2: $_storedImage2");
//         }
//         break;
//       case 'imageUrl1':
//         {
//           print("imageUrl1 is selected");
//           setState(() {
//             _editedProduct = Product(
//               title: _editedProduct.title,
//               price: _editedProduct.price,
//               description: _editedProduct.description,
//               imageUrl0: _editedProduct.imageUrl0,
//               imageUrl1: _pickedImage.toString(),
//               imageUrl2: _editedProduct.imageUrl2,
//               id: _editedProduct.id,
//               isFavorite: _editedProduct.isFavorite,
//               sku: _editedProduct.sku,
//               status: _editedProduct.status,
//               type: _editedProduct.type,
//               size: _editedProduct.size,
//               shippingAddress: '',
//               shippingEmail: '',
//               poster: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//               shippingState: '',
//               buyer: '',
//               shippingName: '',
//               shippingPhone: '',
//               shippingZip: '',
//               shippingCity: '',
//               postertimeStamp: DateTime.now().toIso8601String(),
//               buyertimeStamp: '',
//               piToken: '',
//             );
//           });
//           _storedImage1 = _storedImage;
//           _pickedImage1 = _pickedImage!;
//           print("_storedImage: $_storedImage");
//           print("_storedImage0: $_storedImage0");
//           print("_storedImage1: $_storedImage1");
//           print("_storedImage2: $_storedImage2");
//         }
//         break;
//       case 'imageUrl2':
//         {
//           print("imageUrl2 is selected");
//           setState(() {
//             _editedProduct = Product(
//               title: _editedProduct.title,
//               price: _editedProduct.price,
//               description: _editedProduct.description,
//               imageUrl0: _editedProduct.imageUrl0,
//               imageUrl1: _editedProduct.imageUrl1,
//               imageUrl2: _pickedImage.toString(),
//               id: _editedProduct.id,
//               isFavorite: _editedProduct.isFavorite,
//               sku: _editedProduct.sku,
//               status: _editedProduct.status,
//               type: _editedProduct.type,
//               size: _editedProduct.size,
//               shippingAddress: '',
//               shippingEmail: '',
//               poster: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//               shippingState: '',
//               buyer: '',
//               shippingName: '',
//               shippingPhone: '',
//               shippingZip: '',
//               shippingCity: '',
//               postertimeStamp: DateTime.now().toIso8601String(),
//               buyertimeStamp: '',
//               piToken: '',
//             );
//           });
//           _storedImage2 = _storedImage;
//           _pickedImage2 = _pickedImage!;
//           print("_storedImage: $_storedImage");
//           print("_storedImage0: $_storedImage0");
//           print("_storedImage1: $_storedImage1");
//           print("_storedImage2: $_storedImage2");
//         }
//     }
//
//     Navigator.pop(context);
//     setNewUrl(_pickedImage);
//     //widget.onSelectImage(savedImage);
//   }
//
//   Future<void> _selectPicture(String urlLocation) async {
//     print('** Now in _selectPicture **');
//     _urlLocation = urlLocation;
//     final picker = ImagePicker();
//
//     final pickedXFile = await picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
//
//     if (pickedXFile == null) {
//       print('User canceled image selection.');
//       return;
//     }
//
//     final File imageFile = File(pickedXFile.path);
//
//     // Crop the image
//     await cropImage(imageFile, context);
//     print('**after cropImage call**');
//
//     // ✅ Null check for cropped image
//     if (_storedImage == null) {
//       print('❌ Error: _storedImage is null after cropping');
//       return;
//     }
//
//     // Save cropped image with a unique name
//     final appDir = await syspaths.getApplicationDocumentsDirectory();
//     final uniqueFileName = '${const Uuid().v4()}.png';
//     final savedImage = await _storedImage!.copy('${appDir.path}/$uniqueFileName');
//
//     // Assign to _pickedImage
//     _pickedImage = savedImage;
//
//     //FirebaseUser user = await FirebaseAuth.instance.currentUser();
//     //print("!!!${user.uid}");
//
//     switch (urlLocation) {
//       case 'imageUrl0':
//         {
//           print("imageUrl0 is selected");
//
//           // 👉 Optional: Clear cache to prevent stale image display
//           imageCache.clear();
//           imageCache.clearLiveImages();
//
//           setState(() {
//             _editedProduct = Product(
//               title: _editedProduct.title,
//               price: _editedProduct.price,
//               description: _editedProduct.description,
//               imageUrl0: _storedImage!.path,
//               // 👉 use real file path here
//               imageUrl1: _editedProduct.imageUrl1,
//               imageUrl2: _editedProduct.imageUrl2,
//               id: _editedProduct.id,
//               isFavorite: _editedProduct.isFavorite,
//               sku: _editedProduct.sku,
//               status: _editedProduct.status,
//               type: _editedProduct.type,
//               size: _editedProduct.size,
//               shippingAddress: '',
//               shippingEmail: '',
//               poster: '${_user!.email} ::> ${_user!.uid}',
//               // optional cleanup
//               shippingState: '',
//               buyer: '',
//               shippingName: '',
//               shippingPhone: '',
//               shippingZip: '',
//               shippingCity: '',
//               postertimeStamp: DateTime.now().toIso8601String(),
//               buyertimeStamp: '',
//               piToken: '',
//             );
//
//             _storedImage0 = _storedImage;
//             _pickedImage0 = _pickedImage!;
//           });
//
//           print("_storedImage: $_storedImage");
//           print("_storedImage0: $_storedImage0");
//           print("_storedImage1: $_storedImage1");
//           print("_storedImage2: $_storedImage2");
//         }
//         break;
//       case 'imageUrl1':
//         {
//           // 🛡️ Defensive null check
//           if (_storedImage == null) return;
//
//           // 👉 Optional: Clear cache to prevent stale image display
//           imageCache.clear();
//           imageCache.clearLiveImages();
//
//           // 👉 Handle when user selects to update imageUrl1
//           //print("imageUrl1 is selected");
//           setState(() {
//             _editedProduct = Product(
//               title: _editedProduct.title,
//               price: _editedProduct.price,
//               description: _editedProduct.description,
//               imageUrl0: _editedProduct.imageUrl0,
//               imageUrl1: _storedImage!.path,
//               // ✅ Use actual file path
//               imageUrl2: _editedProduct.imageUrl2,
//               id: _editedProduct.id,
//               isFavorite: _editedProduct.isFavorite,
//               sku: _editedProduct.sku,
//               status: _editedProduct.status,
//               type: _editedProduct.type,
//               size: _editedProduct.size,
//               shippingAddress: '',
//               shippingEmail: '',
//               poster: '${_user!.email} ::> ${_user!.uid}',
//               shippingState: '',
//               buyer: '',
//               shippingName: '',
//               shippingPhone: '',
//               shippingZip: '',
//               shippingCity: '',
//               postertimeStamp: DateTime.now().toIso8601String(),
//               buyertimeStamp: '',
//               piToken: '',
//             );
//
//             _storedImage1 = _storedImage;
//             _pickedImage1 = _pickedImage!;
//           });
//
//           //print("_storedImage: $_storedImage");
//           //print("_storedImage0: $_storedImage0");
//           //print("_storedImage1: $_storedImage1");
//           //print("_storedImage2: $_storedImage2");
//         }
//         break;
//       case 'imageUrl2':
//         {
//           // 🛡️ Defensive null check
//           if (_storedImage == null) return;
//
//           // 👉 Optional: Clear cache to prevent stale image display
//           imageCache.clear();
//           imageCache.clearLiveImages();
//
//           // 👉 Handle when user selects to update imageUrl2
//           //print("imageUrl2 is selected");
//           setState(() {
//             _editedProduct = Product(
//               title: _editedProduct.title,
//               price: _editedProduct.price,
//               description: _editedProduct.description,
//               imageUrl0: _editedProduct.imageUrl0,
//               imageUrl1: _editedProduct.imageUrl1,
//               imageUrl2: _storedImage!.path,
//               // ✅ Use actual file path
//               id: _editedProduct.id,
//               isFavorite: _editedProduct.isFavorite,
//               sku: _editedProduct.sku,
//               status: _editedProduct.status,
//               type: _editedProduct.type,
//               size: _editedProduct.size,
//               shippingAddress: '',
//               shippingEmail: '',
//               poster: '${_user!.email} ::> ${_user!.uid}',
//               shippingState: '',
//               buyer: '',
//               shippingName: '',
//               shippingPhone: '',
//               shippingZip: '',
//               shippingCity: '',
//               postertimeStamp: DateTime.now().toIso8601String(),
//               buyertimeStamp: '',
//               piToken: '',
//             );
//
//             _storedImage2 = _storedImage;
//             _pickedImage2 = _pickedImage!;
//           });
//
//           //print("_storedImage: $_storedImage");
//           //print("_storedImage0: $_storedImage0");
//           //print("_storedImage1: $_storedImage1");
//           //print("_storedImage2: $_storedImage2");
//         }
//     }
//
//     Navigator.pop(context);
//     setNewUrl(_pickedImage);
//     //widget.onSelectImage(savedImage);
//   }
//
//   // cropImage(imageFile) async {
//   //   print('** Now in cropImage **');
//   //   final croppedImage = await ImageCropper().cropImage(
//   //     sourcePath: imageFile.path,
//   //     compressQuality: 100,
//   //     // aspectRatioPresets: Platform.isAndroid
//   //     //     ? [CropAspectRatioPreset.square, CropAspectRatioPreset.ratio3x2, CropAspectRatioPreset.original, CropAspectRatioPreset.ratio4x3, CropAspectRatioPreset.ratio16x9]
//   //     //     : [
//   //     //         CropAspectRatioPreset.original,
//   //     //         CropAspectRatioPreset.square,
//   //     //         CropAspectRatioPreset.ratio3x2,
//   //     //         CropAspectRatioPreset.ratio4x3,
//   //     //         CropAspectRatioPreset.ratio5x3,
//   //     //         CropAspectRatioPreset.ratio5x4,
//   //     //         CropAspectRatioPreset.ratio7x5,
//   //     //         CropAspectRatioPreset.ratio16x9
//   //     //       ],
//   //     uiSettings: [
//   //       AndroidUiSettings(
//   //         toolbarTitle: 'Crop Image',
//   //         toolbarColor: Colors.black,
//   //         toolbarWidgetColor: Colors.white,
//   //         initAspectRatio: CropAspectRatioPreset.original,
//   //         lockAspectRatio: false,
//   //         // aspectRatioPresets: [
//   //         //   CropAspectRatioPreset.original,
//   //         //   CropAspectRatioPreset.square,
//   //         //   CropAspectRatioPreset.ratio4x3,
//   //         // ],
//   //       ),
//   //       IOSUiSettings(
//   //         title: 'Crop Image',
//   //         // aspectRatioPresets: [
//   //         //   CropAspectRatioPreset.original,
//   //         //   CropAspectRatioPreset.square,
//   //         //   CropAspectRatioPreset.ratio4x3,
//   //         // ],
//   //       ),
//   //     ], //uiSettings
//   //   );
//   //   if (croppedImage != null) {
//   //     print('**returned croppedImage: ${croppedImage.toString()}');
//   //     //File imageFile = croppedImage as File;
//   //     CroppedFile imageFile = croppedImage;
//   //     print('**imageFile ::> ${imageFile.path}');
//   //     //return imageFile;
//   //     setState(() {
//   //       _storedImage = File(imageFile.path);
//   //       print('_storedImage:$_storedImage');
//   //     });
//   //     //  croppedImage.copy(newPath);
//   //   }
//   // }
//
//   Future<void> cropImage(File imageFile, BuildContext context) async {
//     // Read image as bytes
//     final Uint8List imageBytes = await imageFile.readAsBytes();
//
//     // Navigate to crop screen and get result
//     final Uint8List croppedBytes = await Navigator.push(context, MaterialPageRoute(builder: (ctx) => CropImageScreen(imageData: imageBytes)));
//
//     if (croppedBytes != null) {
//       // Save cropped bytes to a temporary file
//       final Directory tempDir = await syspaths.getTemporaryDirectory();
//       final String filePath = '${tempDir.path}/cropped_image.png';
//       final File croppedFile = await File(filePath).writeAsBytes(croppedBytes);
//
//       print('Cropped image saved to: ${croppedFile.path}');
//
//       // Use your _storedImage variable if you're saving in state
//       // Be sure you're in a StatefulWidget to call setState
//       // ignore: use_build_context_synchronously
//       (context as Element).markNeedsBuild(); // ensures widget rebuild if needed
//       // ignore: use_build_context_synchronously
//       final state = context.findAncestorStateOfType<State<StatefulWidget>>();
//       state?.setState(() {
//         _storedImage = croppedFile;
//       });
//     }
//   }
//
//   void setNewUrl(value) {
//     print('***Now in setNewUrl***');
//     print('***imageUrl0:${_editedProduct.imageUrl0}');
//     print('***imageUrl1:${_editedProduct.imageUrl1}');
//     print('***imageUrl2:${_editedProduct.imageUrl2}');
//     print('***inside setNewUrl and new imageUrl = $value***');
//     print('***showing new _pickedImage:$_pickedImage');
//     print('***showing new _pickedImage:${_pickedImage.toString()}');
//   }
//
//   @override
//   void didChangeDependencies() {
//     if (_isInit) {
//       final productId = ModalRoute.of(context)!.settings.arguments;
//       if (productId != null) {
//         _editedProduct = Provider.of<Products>(context, listen: false).findById(productId.toString())!;
//         _initValues = {
//           'title': _editedProduct.title,
//           'description': _editedProduct.description,
//           'price': _editedProduct.price.toString(),
//           'imageUrl0': _editedProduct.imageUrl0,
//           'imageUrl1': _editedProduct.imageUrl1,
//           'imageUrl2': _editedProduct.imageUrl2,
//           'sku': _editedProduct.sku.toString(),
//           'status': _editedProduct.status,
//           'type': _editedProduct.type,
//           'size': _editedProduct.size,
//           'timeStamp': _editedProduct.postertimeStamp,
//         };
//         print('***title:${_editedProduct.title}');
//         print('***desc:${_editedProduct.description}');
//         print('***price:${_editedProduct.price}');
//         print('***imageUrl0:${_editedProduct.imageUrl0}');
//         print('***imageUrl1:${_editedProduct.imageUrl1}');
//         print('***imageUrl2:${_editedProduct.imageUrl2}');
//         print('***status:${_editedProduct.status}');
//         print('***postertimeStamp:${_editedProduct.postertimeStamp}');
//         _imageUrlController.text = _editedProduct.imageUrl0;
//       }
//     }
//     _isInit = false;
//     super.didChangeDependencies();
//   }
//
//   @override
//   void dispose() {
//     _imageUrlFocusNode.removeListener(_updateImageUrl);
//     _priceFocusNode.dispose();
//     _descriptionFocusNode.dispose();
//     _imageUrlController.dispose();
//     _imageUrlFocusNode.dispose();
//     _skuFocusNode.dispose();
//     super.dispose();
//   }
//
//   void _updateImageUrl() {
//     setState(() {
//       _editedProduct = Product(
//         title: _editedProduct.title,
//         price: _editedProduct.price,
//         description: _editedProduct.description,
//         imageUrl0: _editedProduct.imageUrl0,
//         imageUrl1: _editedProduct.imageUrl1,
//         imageUrl2: _editedProduct.imageUrl2,
//         id: _editedProduct.id,
//         isFavorite: _editedProduct.isFavorite,
//         sku: _editedProduct.sku,
//         status: _editedProduct.status,
//         type: _editedProduct.type,
//         size: _editedProduct.size,
//         shippingAddress: '',
//         shippingEmail: '',
//         poster: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//         shippingState: '',
//         buyer: '',
//         shippingName: '',
//         shippingPhone: '',
//         shippingZip: '',
//         shippingCity: '',
//         postertimeStamp: DateTime.now().toIso8601String(),
//         buyertimeStamp: '',
//         piToken: '',
//       );
//     });
//   }
//
//   void _saveForm() {
//     print('*** Now In _saveForm ***');
//     setState(() {
//       setState(() => _isLoading = true);
//       _editedProduct = Product(
//         title: _editedProduct.title,
//         price: _editedProduct.price,
//         description: _editedProduct.description,
//         imageUrl0: _editedProduct.imageUrl0,
//         imageUrl1: _editedProduct.imageUrl1,
//         imageUrl2: _editedProduct.imageUrl2,
//         id: _editedProduct.id,
//         isFavorite: _editedProduct.isFavorite,
//         sku: _editedProduct.sku,
//         status: _editedProduct.status,
//         type: _editedProduct.type,
//         size: _editedProduct.size,
//         postertimeStamp: DateTime.now().toIso8601String(),
//         shippingAddress: '',
//         shippingEmail: '',
//         poster: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//         shippingState: '',
//         buyer: '',
//         shippingName: '',
//         shippingPhone: '',
//         shippingZip: '',
//         shippingCity: '',
//         buyertimeStamp: '',
//         piToken: '',
//       );
//       // print('*** Now leaving _saveForm ***');
//       // print('*** ::> postertimeStamp: ${_editedProduct.postertimeStamp} ***');
//       // print('*** ::> poster: ${_editedProduct.poster} ***');
//     });
//
//     // print('***!Current AmountA:${_editedProduct.price.toString()}');
//     // print('***!Current AmountB:${_editedProduct.price * 100}');
//     // print('***!Current AmountC:${(_editedProduct.price).toInt()}');
//
//     final isValid = _form.currentState!.validate();
//     if (!isValid) {
//       print('!!Form IS NOT valid!!');
//       print('Edited Product id value:${_editedProduct.id}');
//       setState(() => _isLoading = false);
//       return;
//     } else {
//       print('!!Form IS valid!!');
//       _form.currentState!.save();
//     }
//
//     // print('Edited Product id value 2:${_editedProduct.id}');
//     // print('!!!current value of _editProduct.id: ${_editedProduct.id}');
//     String checker = _editedProduct.id;
//
//     if (checker != 'empty') {
//       print('***Now in _editedProduct.id != null');
//       Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id, _editedProduct);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Product Update Complete', textAlign: TextAlign.center),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } else {
//       print('***Now in addProduct***');
//
//       final postedData = Provider.of<Products>(context, listen: false);
//       if (postedData.items.length > RESOURCES.DB_LIMIT) {
//         print("*** DB Total : ${postedData.items.length} !!!");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Storage Limit Has Been Exceeded (${RESOURCES.DB_LIMIT}). Unable to upload product', textAlign: TextAlign.center),
//             backgroundColor: Colors.red,
//           ),
//         );
//       } // end if limit check
//       else {
//         Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('New Product Added', textAlign: TextAlign.center),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } // end else limit check
//     }
//     setState(() => _isLoading = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? Loading()
//         : GestureDetector(
//             onTap: () => FocusScope.of(context).unfocus(),
//             child: Scaffold(
//               backgroundColor: Colors.white,
//               appBar: AppBar(backgroundColor: Colors.white, elevation: 0, centerTitle: true, title: Text('Edit Product'), actions: <Widget>[]),
//               body: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Form(
//                   key: _form,
//                   child: ListView(
//                     children: <Widget>[
//                       TextFormField(
//                         initialValue: _initValues['title'],
//                         cursorColor: Colors.black,
//                         decoration: InputDecoration(
//                           labelText: 'Title',
//                           focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
//                         ),
//                         textInputAction: TextInputAction.next,
//                         onFieldSubmitted: (_) {
//                           FocusScope.of(context).requestFocus(_priceFocusNode);
//                         },
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Title cannot be empty, please provide a value.';
//                           }
//                           if (value.length >= 41) {
//                             return 'Text length limited to 40 characters.';
//                           }
//                           return null;
//                         },
//                         onSaved: (value) {
//                           if (value != null) {
//                             _editedProduct = Product(
//                               title: value,
//                               price: _editedProduct.price,
//                               description: _editedProduct.description,
//                               imageUrl0: _editedProduct.imageUrl0,
//                               imageUrl1: _editedProduct.imageUrl1,
//                               imageUrl2: _editedProduct.imageUrl2,
//                               id: _editedProduct.id,
//                               isFavorite: _editedProduct.isFavorite,
//                               sku: _editedProduct.sku,
//                               status: _editedProduct.status,
//                               type: _editedProduct.type,
//                               size: _editedProduct.size,
//                               shippingAddress: '',
//                               shippingEmail: '',
//                               poster: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//                               shippingState: '',
//                               buyer: '',
//                               shippingName: '',
//                               shippingPhone: '',
//                               shippingZip: '',
//                               shippingCity: '',
//                               postertimeStamp: DateTime.now().toIso8601String(),
//                               buyertimeStamp: '',
//                               piToken: '',
//                             );
//                           }
//                         },
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           DropdownButton<String>(
//                             hint: Text("Condition"),
//                             value: _editedProduct.status,
//                             items: _statusList.map<DropdownMenuItem<String>>((value) {
//                               return DropdownMenuItem(child: Text(value), value: value);
//                             }).toList(),
//                             onChanged: (value) {
//                               setState(() {
//                                 if (value != null) {
//                                   _editedProduct = Product(
//                                     title: _editedProduct.title,
//                                     price: _editedProduct.price,
//                                     description: _editedProduct.description,
//                                     imageUrl0: _editedProduct.imageUrl0,
//                                     imageUrl1: _editedProduct.imageUrl1,
//                                     imageUrl2: _editedProduct.imageUrl2,
//                                     id: _editedProduct.id,
//                                     isFavorite: _editedProduct.isFavorite,
//                                     sku: _editedProduct.sku,
//                                     status: value,
//                                     type: _editedProduct.type,
//                                     size: _editedProduct.size,
//                                     shippingAddress: '',
//                                     shippingEmail: '',
//                                     poster: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//                                     shippingState: '',
//                                     buyer: '',
//                                     shippingName: '',
//                                     shippingPhone: '',
//                                     shippingZip: '',
//                                     shippingCity: '',
//                                     postertimeStamp: DateTime.now().toIso8601String(),
//                                     buyertimeStamp: '',
//                                     piToken: '',
//                                   );
//                                 }
//                               });
//                             },
//                           ),
//                           DropdownButton<String>(
//                             //value: _selectedType,
//                             hint: Text("Category"),
//                             value: _editedProduct.type,
//                             items: _typeList.map<DropdownMenuItem<String>>((value) {
//                               return DropdownMenuItem(child: Text(value), value: value);
//                             }).toList(),
//                             onChanged: (value) {
//                               setState(() {
//                                 _editedProduct = Product(
//                                   title: _editedProduct.title,
//                                   price: _editedProduct.price,
//                                   description: _editedProduct.description,
//                                   imageUrl0: _editedProduct.imageUrl0,
//                                   imageUrl1: _editedProduct.imageUrl1,
//                                   imageUrl2: _editedProduct.imageUrl2,
//                                   id: _editedProduct.id,
//                                   isFavorite: _editedProduct.isFavorite,
//                                   sku: _editedProduct.sku,
//                                   status: _editedProduct.status,
//                                   type: value!,
//                                   size: _editedProduct.size,
//                                   shippingAddress: '',
//                                   shippingEmail: '',
//                                   poster: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//                                   shippingState: '',
//                                   buyer: '',
//                                   shippingName: '',
//                                   shippingPhone: '',
//                                   shippingZip: '',
//                                   shippingCity: '',
//                                   postertimeStamp: DateTime.now().toIso8601String(),
//                                   buyertimeStamp: '',
//                                   piToken: '',
//                                 );
//                               });
//                             },
//                           ),
//                           DropdownButton<String>(
//                             //value: _selectedType,
//                             hint: Text("Size"),
//                             value: _editedProduct.size,
//                             items: _sizeList.map<DropdownMenuItem<String>>((value) {
//                               return DropdownMenuItem(child: Text(value), value: value);
//                             }).toList(),
//                             onChanged: (value) {
//                               setState(() {
//                                 _editedProduct = Product(
//                                   title: _editedProduct.title,
//                                   price: _editedProduct.price,
//                                   description: _editedProduct.description,
//                                   imageUrl0: _editedProduct.imageUrl0,
//                                   imageUrl1: _editedProduct.imageUrl1,
//                                   imageUrl2: _editedProduct.imageUrl2,
//                                   id: _editedProduct.id,
//                                   isFavorite: _editedProduct.isFavorite,
//                                   sku: _editedProduct.sku,
//                                   status: _editedProduct.status,
//                                   type: _editedProduct.type,
//                                   size: value!,
//                                   shippingAddress: '',
//                                   shippingEmail: '',
//                                   poster: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//                                   shippingState: '',
//                                   buyer: '',
//                                   shippingName: '',
//                                   shippingPhone: '',
//                                   shippingZip: '',
//                                   shippingCity: '',
//                                   postertimeStamp: DateTime.now().toIso8601String(),
//                                   buyertimeStamp: '',
//                                   piToken: '',
//                                 );
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: <Widget>[
//                           Flexible(
//                             child: TextFormField(
//                               initialValue: _initValues['price'],
//                               decoration: InputDecoration(labelText: 'Price'),
//                               textInputAction: TextInputAction.next,
//                               keyboardType: TextInputType.numberWithOptions(decimal: true),
//                               focusNode: _priceFocusNode,
//                               onFieldSubmitted: (_) {
//                                 FocusScope.of(context).requestFocus(_descriptionFocusNode);
//                               },
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return 'Please enter a price.';
//                                 }
//                                 if (double.tryParse(value) == null) {
//                                   return 'Please enter a valid number.';
//                                 }
//                                 if (double.parse(value) <= 0) {
//                                   return 'Please enter a number greater than 0.';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 if (value != null) {
//                                   _editedProduct = Product(
//                                     title: _editedProduct.title,
//                                     price: double.parse(value),
//                                     description: _editedProduct.description,
//                                     imageUrl0: _editedProduct.imageUrl0,
//                                     imageUrl1: _editedProduct.imageUrl1,
//                                     imageUrl2: _editedProduct.imageUrl2,
//                                     id: _editedProduct.id,
//                                     isFavorite: _editedProduct.isFavorite,
//                                     sku: _editedProduct.sku,
//                                     status: _editedProduct.status,
//                                     type: _editedProduct.type,
//                                     size: _editedProduct.size,
//                                     shippingAddress: '',
//                                     shippingEmail: '',
//                                     poster: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//                                     shippingState: '',
//                                     buyer: '',
//                                     shippingName: '',
//                                     shippingPhone: '',
//                                     shippingZip: '',
//                                     shippingCity: '',
//                                     postertimeStamp: DateTime.now().toIso8601String(),
//                                     buyertimeStamp: '',
//                                     piToken: '',
//                                   );
//                                 }
//                               },
//                             ),
//                           ),
//                           Flexible(
//                             child: TextFormField(
//                               initialValue: _initValues['sku'],
//                               decoration: InputDecoration(labelText: 'Sku'),
//                               textInputAction: TextInputAction.next,
//                               keyboardType: TextInputType.text,
//                               onFieldSubmitted: (_) {
//                                 FocusScope.of(context).requestFocus(_descriptionFocusNode);
//                               },
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return 'Please enter a product SKU.';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 if (value != null) {
//                                   _editedProduct = Product(
//                                     title: _editedProduct.title,
//                                     price: _editedProduct.price,
//                                     description: _editedProduct.description,
//                                     imageUrl0: _editedProduct.imageUrl0,
//                                     imageUrl1: _editedProduct.imageUrl1,
//                                     imageUrl2: _editedProduct.imageUrl2,
//                                     id: _editedProduct.id,
//                                     isFavorite: _editedProduct.isFavorite,
//                                     sku: value,
//                                     status: _editedProduct.status,
//                                     type: _editedProduct.type,
//                                     size: _editedProduct.size,
//                                     shippingAddress: '',
//                                     shippingEmail: '',
//                                     poster: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//                                     shippingState: '',
//                                     buyer: '',
//                                     shippingName: '',
//                                     shippingPhone: '',
//                                     shippingZip: '',
//                                     shippingCity: '',
//                                     postertimeStamp: DateTime.now().toIso8601String(),
//                                     buyertimeStamp: '',
//                                     piToken: '',
//                                   );
//                                 }
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       TextFormField(
//                         initialValue: _initValues['description'],
//                         decoration: InputDecoration(labelText: 'Description'),
//                         maxLines: 3,
//                         keyboardType: TextInputType.multiline,
//                         focusNode: _descriptionFocusNode,
//                         textInputAction: TextInputAction.done,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter a description.';
//                           }
//                           if (value.length < 10) {
//                             return 'Should be at least 10 characters long.';
//                           }
//                           return null;
//                         },
//                         onSaved: (value) {
//                           if (value != null) {
//                             _editedProduct = Product(
//                               title: _editedProduct.title,
//                               price: _editedProduct.price,
//                               description: value,
//                               imageUrl0: _editedProduct.imageUrl0,
//                               imageUrl1: _editedProduct.imageUrl1,
//                               imageUrl2: _editedProduct.imageUrl2,
//                               id: _editedProduct.id,
//                               isFavorite: _editedProduct.isFavorite,
//                               sku: _editedProduct.sku,
//                               status: _editedProduct.status,
//                               type: _editedProduct.type,
//                               size: _editedProduct.size,
//                               shippingAddress: '',
//                               shippingEmail: '',
//                               poster: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//                               shippingState: '',
//                               buyer: '',
//                               shippingName: '',
//                               shippingPhone: '',
//                               shippingZip: '',
//                               shippingCity: '',
//                               postertimeStamp: DateTime.now().toIso8601String(),
//                               buyertimeStamp: '',
//                               piToken: '',
//                             );
//                           }
//                         },
//                       ),
//                       SizedBox(height: 30),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: <Widget>[
//                           Flexible(
//                             child: GestureDetector(
//                               onTap: () {
//                                 // print("Box0 pressed");
//                                 // print("_storedImage0: $_storedImage0");
//                                 // print("_urlLoacation: $_urlLocation");
//                                 // print("_editedProduct0: ${_editedProduct.imageUrl0}");
//                                 displayBottomSheet(context, 'imageUrl0');
//                               },
//                               onLongPress: () {
//                                 print("Box0 long pressed");
//                                 {
//                                   showDialog(
//                                     context: context,
//                                     builder: (ctx) => AlertDialog(
//                                       title: Text('Delete Image?', textAlign: TextAlign.center),
//                                       content: Text('Do you want to delete image from current Product post?'),
//                                       actions: <Widget>[
//                                         TextButton(
//                                           child: Text('No'),
//                                           onPressed: () {
//                                             Navigator.of(ctx).pop(false);
//                                           },
//                                         ),
//                                         TextButton(
//                                           child: Text('Yes', style: TextStyle(color: Colors.red)),
//                                           onPressed: () {
//                                             print("yes pressed");
//                                             _urlLocation = 'imageUrl0';
//                                             setState(() {
//                                               _editedProduct = Product(
//                                                 title: _editedProduct.title,
//                                                 price: _editedProduct.price,
//                                                 description: _editedProduct.description,
//                                                 imageUrl0: 'imageUrl0',
//                                                 imageUrl1: _editedProduct.imageUrl1,
//                                                 imageUrl2: _editedProduct.imageUrl2,
//                                                 id: _editedProduct.id,
//                                                 isFavorite: _editedProduct.isFavorite,
//                                                 sku: _editedProduct.sku,
//                                                 status: _editedProduct.status,
//                                                 type: _editedProduct.type,
//                                                 size: _editedProduct.size,
//                                                 shippingAddress: '',
//                                                 shippingEmail: '',
//                                                 poster: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//                                                 shippingState: '',
//                                                 buyer: '',
//                                                 shippingName: '',
//                                                 shippingPhone: '',
//                                                 shippingZip: '',
//                                                 shippingCity: '',
//                                                 postertimeStamp: DateTime.now().toIso8601String(),
//                                                 buyertimeStamp: '',
//                                                 piToken: '',
//                                               );
//                                             });
//
//                                             //print("yes pressed #2");
//                                             Navigator.of(ctx).pop(true);
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }
//                               },
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 width: 115,
//                                 //width: double.infinity,
//                                 height: 115,
//                                 margin: EdgeInsets.only(top: 8, right: 10),
//
//                                 decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.grey)),
//
//                                 child:
//                                     _storedImage0 != null &&
//                                         _urlLocation ==
//                                             'imageUrl0' //need imageUrl from product
//                                     ? Image.file(_storedImage0!, fit: BoxFit.cover, width: double.infinity)
//                                     : _storedImage0 != null
//                                     ? Image.file(_storedImage0!, fit: BoxFit.cover, width: double.infinity)
//                                     : _editedProduct.imageUrl0 == '' || _editedProduct.imageUrl0 == 'imageUrl0'
//                                     ? Text('Select Image', textAlign: TextAlign.center)
//                                     : Image.network(_editedProduct.imageUrl0),
//                                 //: Text( 'No Image Taken'),
//                               ),
//                             ),
//                           ),
//                           Flexible(
//                             child: GestureDetector(
//                               onTap: () {
//                                 // print("Box1 pressed");
//                                 // print("_storedImage1: $_storedImage1");
//                                 // print("_urlLoacation: $_urlLocation");
//                                 displayBottomSheet(context, 'imageUrl1');
//                               },
//                               onLongPress: () {
//                                 print("Box1 long pressed");
//                                 {
//                                   showDialog(
//                                     context: context,
//                                     builder: (ctx) => AlertDialog(
//                                       title: Text('Delete Image?', textAlign: TextAlign.center),
//                                       content: Text('Do you want to delete image from current Product post?'),
//                                       actions: <Widget>[
//                                         TextButton(
//                                           child: Text('No'),
//                                           onPressed: () {
//                                             Navigator.of(ctx).pop(false);
//                                           },
//                                         ),
//                                         TextButton(
//                                           child: Text('Yes', style: TextStyle(color: Colors.red)),
//                                           onPressed: () {
//                                             print("yes pressed");
//                                             _urlLocation = 'imageUrl1';
//                                             setState(() {
//                                               _editedProduct = Product(
//                                                 title: _editedProduct.title,
//                                                 price: _editedProduct.price,
//                                                 description: _editedProduct.description,
//                                                 imageUrl0: _editedProduct.imageUrl0,
//                                                 imageUrl1: 'imageUrl1',
//                                                 imageUrl2: _editedProduct.imageUrl2,
//                                                 id: _editedProduct.id,
//                                                 isFavorite: _editedProduct.isFavorite,
//                                                 sku: _editedProduct.sku,
//                                                 status: _editedProduct.status,
//                                                 type: _editedProduct.type,
//                                                 size: _editedProduct.size,
//                                                 shippingAddress: '',
//                                                 shippingEmail: '',
//                                                 poster: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//                                                 shippingState: '',
//                                                 buyer: '',
//                                                 shippingName: '',
//                                                 shippingPhone: '',
//                                                 shippingZip: '',
//                                                 shippingCity: '',
//                                                 postertimeStamp: DateTime.now().toIso8601String(),
//                                                 buyertimeStamp: '',
//                                                 piToken: '',
//                                               );
//                                             });
//
//                                             print("yes pressed #2");
//                                             Navigator.of(ctx).pop(true);
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }
//                               },
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 width: 115,
//                                 //width: double.infinity,
//                                 height: 115,
//                                 margin: EdgeInsets.only(top: 8, right: 10),
//                                 decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.grey)),
//
//                                 child:
//                                     _storedImage1 != null &&
//                                         _urlLocation ==
//                                             'imageUrl1' //need imageUrl from product
//                                     ? Image.file(_storedImage1!, fit: BoxFit.cover, width: double.infinity)
//                                     : _storedImage1 != null
//                                     ? Image.file(_storedImage1!, fit: BoxFit.cover, width: double.infinity)
//                                     : _editedProduct.imageUrl1 == '' || _editedProduct.imageUrl1 == 'imageUrl1'
//                                     // : _editedProduct.imageUrl0 == null
//                                     ? Text('Select Image', textAlign: TextAlign.center)
//                                     : Image.network(_editedProduct.imageUrl1),
//                               ),
//                             ),
//                           ),
//                           Flexible(
//                             child: GestureDetector(
//                               onTap: () {
//                                 // print("Box2 pressed");
//                                 displayBottomSheet(context, 'imageUrl2');
//                               },
//                               onLongPress: () {
//                                 print("Box2 long pressed");
//                                 {
//                                   showDialog(
//                                     context: context,
//                                     builder: (ctx) => AlertDialog(
//                                       title: Text('Delete Image?', textAlign: TextAlign.center),
//                                       content: Text('Do you want to delete image from current Product post?'),
//                                       actions: <Widget>[
//                                         TextButton(
//                                           child: Text('No'),
//                                           onPressed: () {
//                                             Navigator.of(ctx).pop(false);
//                                           },
//                                         ),
//                                         TextButton(
//                                           child: Text('Yes', style: TextStyle(color: Colors.red)),
//                                           onPressed: () {
//                                             print("yes pressed");
//                                             _urlLocation = 'imageUrl2';
//                                             setState(() {
//                                               _editedProduct = Product(
//                                                 title: _editedProduct.title,
//                                                 price: _editedProduct.price,
//                                                 description: _editedProduct.description,
//                                                 imageUrl0: _editedProduct.imageUrl0,
//                                                 imageUrl1: _editedProduct.imageUrl1,
//                                                 imageUrl2: 'imageUrl2',
//                                                 id: _editedProduct.id,
//                                                 isFavorite: _editedProduct.isFavorite,
//                                                 sku: _editedProduct.sku,
//                                                 status: _editedProduct.status,
//                                                 type: _editedProduct.type,
//                                                 size: _editedProduct.size,
//                                                 shippingAddress: '',
//                                                 shippingEmail: '',
//                                                 poster: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//                                                 shippingState: '',
//                                                 buyer: '',
//                                                 shippingName: '',
//                                                 shippingPhone: '',
//                                                 shippingZip: '',
//                                                 shippingCity: '',
//                                                 postertimeStamp: DateTime.now().toIso8601String(),
//                                                 buyertimeStamp: '',
//                                                 piToken: '',
//                                               );
//                                             });
//
//                                             print("yes pressed #2");
//                                             Navigator.of(ctx).pop(true);
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }
//                               },
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 width: 115,
//                                 height: 115,
//                                 margin: EdgeInsets.only(top: 8, right: 10),
//                                 decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.grey)),
//
//                                 child:
//                                     _storedImage2 != null &&
//                                         _urlLocation ==
//                                             'imageUrl2' //need imageUrl from product
//                                     ? Image.file(_storedImage2!, fit: BoxFit.cover, width: double.infinity)
//                                     : _storedImage2 != null
//                                     ? Image.file(_storedImage2!, fit: BoxFit.cover, width: double.infinity)
//                                     : _editedProduct.imageUrl2 == '' || _editedProduct.imageUrl2 == 'imageUrl2'
//                                     ? Text('Select Image', textAlign: TextAlign.center)
//                                     : Image.network(_editedProduct.imageUrl2),
//                                 //: Text( 'No Image Taken),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(children: <Widget>[SizedBox(height: 20)]),
//                     ],
//                   ),
//                 ),
//               ),
//               bottomNavigationBar: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [BoxShadow(color: Colors.black)],
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(15.0),
//                   child: TextButton.icon(
//                     style: TextButton.styleFrom(
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       minimumSize: Size(0, 48),
//                       backgroundColor: Colors.black,
//                     ),
//                     label: Text(
//                       'Save',
//                       style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.white, wordSpacing: 2.0, letterSpacing: 0.9),
//                     ),
//                     icon: Icon(Icons.save, color: Colors.white),
//                     onPressed: () async {
//                       // print('Save Button pressed');
//
//                       // print("!!!123!!!");
//                       // print('_pickedImage0 ::> ${_pickedImage0?.uri}');
//                       // print('_pickedImage1 ::> ${_pickedImage1?.uri}');
//                       // print('_pickedImage2 ::> ${_pickedImage2?.uri}');
//
//                       _oldImage0 = _editedProduct.imageUrl0;
//                       _oldImage1 = _editedProduct.imageUrl1;
//                       _oldImage2 = _editedProduct.imageUrl2;
//
//                       if (_form.currentState!.validate()) {
//                         await _uploadImage(_pickedImage0!, _oldImage0!, _pickedImage1!, _oldImage1!, _pickedImage2!, _oldImage2!);
//
//                         Navigator.of(context).pop();
//                       }
//
//                       // print('***image to be uploaded:$_pickedImage');
//
//                       // print('After pause');
//                     },
//                     onLongPress: () async {
//                       print('<:: long press for duplicate ::>');
//
//                       ///Add code to duplicate entry for multiple entries
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           );
//   }
//
//   Future<String> _uploadImage(File uploadingImage0, String oldImage0, File uploadingImage1, String oldImage1, File uploadingImage2, String oldImage2) async {
//     File _image0 = uploadingImage0;
//     File _image1 = uploadingImage1;
//     File _image2 = uploadingImage2;
//
//     String link0 = '';
//     String link1 = '';
//     String link2 = '';
//
//     // print('now in _uploadImage');
//     // print('upladingImage !!!:${_image0.toString()}');
//     // print('leaving _uploadImage');
//
//     List<File> _images = [];
//
//     _images.add(_image0);
//     _images.add(_image1);
//     _images.add(_image2);
//
//     if (_image0.toString() == File('/fake/file/path').toString()) {
//       print("TRUE TRUE TRUE");
//     } else {
//       print('---------------');
//       print(_image0.toString());
//       print(File('/fake/file/path').toString());
//       print('---------------');
//     }
//     print('File::> ${File('')}');
//     print('current value of _image0 ::> ${_image0.toString()}');
//     print('_image0.toString() ::> ${_image0.toString()}');
//
//     if (_image0.toString() != File('/fake/file/path').toString()) {
//       print('** Now in True _image0');
//       await _uploadImage0(_image0);
//       print('***await for link0 is done: $link0***');
//     }
//
//     //if (_image1 != '') {
//     if (_image1.toString() != File('/fake/file/path').toString()) {
//       await _uploadImage1(_image1);
//       print('***await for link1 is done: $link1***');
//     }
//
//     //if (_image2 != '') {
//     if (_image2.toString() != File('/fake/file/path').toString()) {
//       await _uploadImage2(_image2);
//       print('***new link2: $link2***');
//     }
//
//     //fix here (use above logic to check against File('/fake/file/path')
//     //check if each image slot IS blank/empty, then set to old image (meaning the image was not updated and the old one should be used)
//     if (_image0.toString() == File('/fake/file/path').toString() && _image1.toString() == File('/fake/file/path').toString() && _image2.toString() == File('/fake/file/path').toString()) {
//       setState(() {
//         _editedProduct = Product(
//           title: _editedProduct.title,
//           price: _editedProduct.price,
//           description: _editedProduct.description,
//           imageUrl0: oldImage0,
//           imageUrl1: oldImage1,
//           imageUrl2: oldImage2,
//           id: _editedProduct.id,
//           isFavorite: _editedProduct.isFavorite,
//           sku: _editedProduct.sku,
//           status: _editedProduct.status,
//           type: _editedProduct.type,
//           size: _editedProduct.size,
//           shippingAddress: '',
//           shippingEmail: '',
//           poster: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//           shippingState: '',
//           buyer: '',
//           shippingName: '',
//           shippingPhone: '',
//           shippingZip: '',
//           shippingCity: '',
//           postertimeStamp: DateTime.now().toIso8601String(),
//           buyertimeStamp: '',
//           piToken: '',
//         );
//         // print('::> TimeStamp check: ${DateTime.now()} <::');
//         // print('::> Other check: ${DateTime.now().toIso8601String()} <::');
//         // print('::> Other check: ${_editedProduct.postertimeStamp} <::');
//       });
//
//       _saveForm();
//     }
//
//     _saveForm();
//     return 'done';
//   }
//
//   void displayBottomSheet(BuildContext context, String urlLocation) {
//     print("current URL Position: $urlLocation");
//
//     showModalBottomSheet(
//       context: context,
//       builder: (ctx) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.12,
//           child: Row(
//             children: <Widget>[
//               Expanded(
//                 child: TextButton.icon(
//                   icon: Icon(Icons.camera, color: Colors.black),
//                   label: Text('Camera', style: TextStyle(color: Colors.black)),
//                   onPressed: () => _takePicture(urlLocation),
//                 ),
//               ),
//               VerticalDivider(thickness: 2, color: Colors.black, width: 10),
//               Expanded(
//                 child: TextButton.icon(
//                   icon: Icon(Icons.filter, color: Colors.black),
//                   label: Text('Gallery', style: TextStyle(color: Colors.black)),
//                   onPressed: () => _selectPicture(urlLocation),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _uploadImage0(File _image0) async {
//     String link0 = '';
//     //String link1;
//
//     print('**_uploadImage0 current _image0 ::> $_image0');
//     FirebaseStorage fs = FirebaseStorage.instance;
//
//     Reference rootReference = fs.ref();
//
//     Reference pictureFolderRef = rootReference.child("pictures").child("${DateTime.now()}");
//
//     await pictureFolderRef.putFile(_image0).then((storageTask) async {
//       link0 = await storageTask.ref.getDownloadURL();
//     });
//
//     print("uploaded");
//     print("**********");
//     print(link0);
//
//     print('current imageUrl ${_editedProduct.imageUrl0}');
//     print('current link value ${link0.toString()}');
//     setState(() {
//       _editedProduct = Product(
//         title: _editedProduct.title,
//         price: _editedProduct.price,
//         description: _editedProduct.description,
//         imageUrl0: link0.toString(),
//         imageUrl1: _editedProduct.imageUrl1,
//         imageUrl2: _editedProduct.imageUrl2,
//         id: _editedProduct.id,
//         isFavorite: _editedProduct.isFavorite,
//         sku: _editedProduct.sku,
//         status: _editedProduct.status,
//         type: _editedProduct.type,
//         size: _editedProduct.size,
//         shippingAddress: '',
//         shippingEmail: '',
//         poster: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//         shippingState: '',
//         buyer: '',
//         shippingName: '',
//         shippingPhone: '',
//         shippingZip: '',
//         shippingCity: '',
//         postertimeStamp: DateTime.now().toIso8601String(),
//         buyertimeStamp: '',
//         piToken: '',
//       );
//     });
//
//     print('***new link: $link0***');
//   }
//
//   Future<void> _uploadImage1(File _image1) async {
//     String link1 = '';
//
//     FirebaseStorage fs = FirebaseStorage.instance;
//
//     Reference rootReference = fs.ref();
//
//     Reference pictureFolderRef = rootReference.child("pictures").child("${DateTime.now()}");
//
//     await pictureFolderRef.putFile(_image1).then((storageTask) async {
//       link1 = await storageTask.ref.getDownloadURL();
//     });
//
//     print("uploaded");
//     print("**********");
//     print(link1);
//
//     print('current imageUrl ${_editedProduct.imageUrl0}');
//     print('current link value ${link1.toString()}');
//     setState(() {
//       _editedProduct = Product(
//         title: _editedProduct.title,
//         price: _editedProduct.price,
//         description: _editedProduct.description,
//         imageUrl0: _editedProduct.imageUrl0,
//         imageUrl1: link1.toString(),
//         imageUrl2: _editedProduct.imageUrl2,
//         id: _editedProduct.id,
//         isFavorite: _editedProduct.isFavorite,
//         sku: _editedProduct.sku,
//         status: _editedProduct.status,
//         type: _editedProduct.type,
//         size: _editedProduct.size,
//         shippingAddress: '',
//         shippingEmail: '',
//         poster: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//         shippingState: '',
//         buyer: '',
//         shippingName: '',
//         shippingPhone: '',
//         shippingZip: '',
//         shippingCity: '',
//         postertimeStamp: DateTime.now().toIso8601String(),
//         buyertimeStamp: '',
//         piToken: '',
//       );
//     });
//     print('***new link: $link1***');
//     //    _saveForm();
//     //return link;
//     //   });
//   }
//
//   Future<void> _uploadImage2(File _image2) async {
//     String link2 = '';
//
//     FirebaseStorage fs = FirebaseStorage.instance;
//
//     Reference rootReference = fs.ref();
//
//     Reference pictureFolderRef = rootReference.child("pictures").child("${DateTime.now()}");
//
//     await pictureFolderRef.putFile(_image2)
//     //.onComplete
//     .then((storageTask) async {
//       link2 = await storageTask.ref.getDownloadURL();
//     });
//     print("uploaded");
//     print("**********");
//     print(link2);
//
//     print('current imageUrl ${_editedProduct.imageUrl2}');
//     print('current link value ${link2.toString()}');
//     setState(() {
//       _editedProduct = Product(
//         title: _editedProduct.title,
//         price: _editedProduct.price,
//         description: _editedProduct.description,
//         imageUrl0: _editedProduct.imageUrl0,
//         imageUrl1: _editedProduct.imageUrl1,
//         imageUrl2: link2.toString(),
//         id: _editedProduct.id,
//         isFavorite: _editedProduct.isFavorite,
//         sku: _editedProduct.sku,
//         status: _editedProduct.status,
//         type: _editedProduct.type,
//         size: _editedProduct.size,
//         shippingAddress: '',
//         shippingEmail: '',
//         poster: this._user!.email.toString() + ' ::> ' + this._user!.uid.toString(),
//         shippingState: '',
//         buyer: '',
//         shippingName: '',
//         shippingPhone: '',
//         shippingZip: '',
//         shippingCity: '',
//         postertimeStamp: DateTime.now().toIso8601String(),
//         buyertimeStamp: '',
//         piToken: '',
//       );
//     });
//   }
// }
