// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:snkr_stacks/providers/mail_service.dart';
// import 'package:snkr_stacks/providers/product.dart';
// import 'package:snkr_stacks/providers/products_provider.dart';
// import 'package:snkr_stacks/providers/shippments_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:snkr_stacks/shared/loading.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:snkr_stacks/providers/resources.dart' as Resources;
// import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
// import 'package:http/http.dart' as http;
//
// class ReviewPurchaseScreen extends StatefulWidget {
//   static const routeName = '/review-purchase';
//
//   @override
//   _ReviewPurchaseScreenState createState() => _ReviewPurchaseScreenState();
// }
//
// class _ReviewPurchaseScreenState extends State<ReviewPurchaseScreen> {
//   bool _isLoading = false;
//   int _current = 0;
//   PageStorageBucket _bucket = PageStorageBucket();
//
//   @override
//   Widget build(BuildContext context) {
//     final productID = ModalRoute.of(context)!.settings.arguments as String; //is the id
//     final loadedProduct = Provider.of<Shippments>(
//       //final loadedProduct = Provider.of<Products>(
//       context,
//       listen: false,
//     ).findById(productID);
//
//     print('::loadedProduct.piToken on page open::>' + loadedProduct.piToken);
//
//     final double _height = 350;
//     //final double _height = MediaQuery.of(context).size.height;
//
//     List<String> imgList = [];
//
//     if (loadedProduct.imageUrl0 != "null" && loadedProduct.imageUrl0 != null && loadedProduct.imageUrl0 != "") {
//       imgList.add(loadedProduct.imageUrl0);
//       print("URL0 ADDED");
//       print("URL0 => ${loadedProduct.imageUrl0}");
//     }
//     if (loadedProduct.imageUrl1 != "null" && loadedProduct.imageUrl1 != null && loadedProduct.imageUrl1 != "") {
//       imgList.add(loadedProduct.imageUrl1);
//       print("URL0 ADDED");
//     }
//     if (loadedProduct.imageUrl2 != "null" && loadedProduct.imageUrl2 != null && loadedProduct.imageUrl2 != "") {
//       imgList.add(loadedProduct.imageUrl2);
//       print("URL0 ADDED");
//     }
//     // print("URL0:" + loadedProduct.imageUrl0);
//     // print("URL1:" + loadedProduct.imageUrl1);
//     // print("URL2:" + loadedProduct.imageUrl2);
//
//     final List<Widget> imageSliders = imgList
//         .map(
//           (item) => Container(
//             child: Container(
//               // margin: EdgeInsets.all(5.0),
//
//               // child: ClipRRect(
//               //   borderRadius: BorderRadius.all(
//               //     Radius.circular(5.0),
//               //  ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(15.0),
//                 child: Stack(
//                   children: <Widget>[
//                     Image.network(item, fit: BoxFit.fitWidth, height: _height, width: double.infinity),
//                     Positioned(
//                       bottom: 0.0,
//                       left: 0.0,
//                       right: 0.0,
//                       child: Container(
//                         // decoration: BoxDecoration(
//                         //   gradient: LinearGradient(
//                         //     colors: [
//                         //       Color.fromARGB(200, 0, 0, 0),
//                         //       Color.fromARGB(0, 0, 0, 0)
//                         //     ],
//                         //     begin: Alignment.bottomCenter,
//                         //     end: Alignment.topCenter,
//                         //   ),
//                         // ),
//                         padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//                         // child: Text(
//                         //   'No. ${imgList.indexOf(item)} image',
//                         //   style: TextStyle(
//                         //     color: Colors.white,
//                         //     fontSize: 20.0,
//                         //     fontWeight: FontWeight.bold,
//                         //   ),
//                         // ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               //  ),
//             ),
//           ),
//         )
//         .toList();
//
//     return _isLoading
//         ? Loading()
//         : Scaffold(
//             backgroundColor: Colors.white,
//             appBar: AppBar(backgroundColor: Colors.white, elevation: 0, centerTitle: true, title: Text(loadedProduct.title), surfaceTintColor: Colors.transparent),
//             body: Column(
//               children: <Widget>[
//                 Container(
//                   margin: EdgeInsets.all(5),
//                   padding: EdgeInsets.all(10),
//                   width: double.infinity,
//                   height: 325,
//                   // decoration: BoxDecoration(boxShadow: [
//                   //   BoxShadow(
//                   //     color: Colors.grey.withOpacity(0.5),
//                   //     spreadRadius: 3,
//                   //     blurRadius: 5,
//                   //     offset: Offset(0, 3), // changes position of shadow
//                   //   ),
//                   // ], borderRadius: BorderRadius.circular(17.0)),
//                   child: Hero(
//                     tag: productID,
//                     //child: ClipRRect(
//                     //  borderRadius: BorderRadius.circular(10.0),
//                     child: PageStorage(
//                       bucket: _bucket,
//                       child: GridTile(
//                         child: GestureDetector(
//                           onTap: () {
//                             //onDoubleTap: () {
//                             Navigator.of(context).pop();
//                           },
//
//                           // child: Image.network(loadedProduct.imageUrl0,
//                           //     //child: Image.file(loadedProduct.image,
//                           //     // fit: BoxFit.fitHeight),
//                           //     fit: BoxFit.fitWidth),
//                           //**old
//                           // child: CarouselSlider(
//                           //   options: CarouselOptions(
//                           //       aspectRatio: 2.0,
//                           //       enlargeCenterPage: true,
//                           //       enableInfiniteScroll: false,
//                           //       initialPage: 0,
//                           //       autoPlay: false),
//                           //   items: imageSliders,
//                           //   //**old
//                           // ),
//                           child: CarouselSlider(
//                             items: imageSliders,
//                             options: CarouselOptions(
//                               // aspectRatio: 2.0,
//                               height: _height,
//                               viewportFraction: 1.0,
//                               initialPage: 0,
//                               enlargeCenterPage: true,
//                               // enlargeCenterPage: false,
//                               enableInfiniteScroll: false,
//                               autoPlay: false,
//                               onPageChanged: (index, reason) {
//                                 setState(() {
//                                   _current = index;
//                                   // print("_current: $index");
//                                 });
//                               },
//                             ),
//                           ),
//
//                           // child: CarouselSlider(
//                           //   options: CarouselOptions(
//                           //     height: height,
//                           //     initialPage: 0,
//                           //     viewportFraction: 1.0,
//                           //     enlargeCenterPage: true,
//                           //     enableInfiniteScroll: false,
//                           //     autoPlay: false,
//                           //     onPageChanged: (index, reason) {
//                           //       setState(
//                           //         () {
//                           //           _current = index;
//                           //           print("_current: $index");
//                           //         },
//                           //       );
//                           //     },
//                           //   ),
//                           //   items: imgList
//                           //       .map(
//                           //         (item) => Container(
//                           //           child: Center(
//                           //             child: Image.network(
//                           //               item,
//                           //               fit: BoxFit.cover,
//                           //               height: height,
//                           //             ),
//                           //           ),
//                           //         ),
//                           //       )
//                           //       .toList(),
//                           // ),
//                         ),
//                       ),
//                     ),
//                     //  ),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: imgList.map((url) {
//                     int index = imgList.indexOf(url);
//                     return Container(
//                       width: 8.0,
//                       height: 8.0,
//                       margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//                       decoration: BoxDecoration(shape: BoxShape.circle, color: _current == index ? Color.fromRGBO(0, 0, 0, 0.9) : Color.fromRGBO(0, 0, 0, 0.4)),
//                     );
//                   }).toList(),
//                 ),
//                 SizedBox(height: 10),
//                 Expanded(
//                   flex: 1,
//                   child: Container(
//                     padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 15.0),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.only(top: 20.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Expanded(
//                                   child: Text(
//                                     '${loadedProduct.title}',
//                                     softWrap: true,
//                                     style: TextStyle(
//                                       fontSize: 20.0,
//                                       //fontWeight: FontWeight.w900,
//                                       //letterSpacing: 2.5,
//                                     ),
//                                   ),
//                                 ),
//                                 Text(
//                                   '\$${loadedProduct.price.toStringAsFixed(2)}',
//                                   style: TextStyle(
//                                     fontSize: 18.0,
//                                     //fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 20.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Text(
//                                   'SKU',
//                                   //'${loadedProduct.title}',
//                                   softWrap: true,
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     //fontWeight: FontWeight.w600,
//                                     //letterSpacing: 2.5,
//                                   ),
//                                 ),
//                                 Text(
//                                   '${loadedProduct.sku}',
//                                   style: TextStyle(
//                                     fontSize: 18.0,
//                                     //fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 20.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Text(
//                                   'Status',
//                                   //'${loadedProduct.title}',
//                                   softWrap: true,
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     //fontWeight: FontWeight.w600,
//                                     //letterSpacing: 2.5,
//                                   ),
//                                 ),
//                                 Text(
//                                   '${loadedProduct.status}',
//                                   style: TextStyle(
//                                     fontSize: 18.0,
//                                     //fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 25.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Text(
//                                   'Category',
//                                   //'${loadedProduct.title}',
//                                   softWrap: true,
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     //fontWeight: FontWeight.w600,
//                                     //letterSpacing: 2.5,
//                                   ),
//                                 ),
//                                 Text(
//                                   '${loadedProduct.type}',
//                                   style: TextStyle(
//                                     fontSize: 18.0,
//                                     //fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 20.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Text(
//                                   'Size',
//                                   //'${loadedProduct.title}',
//                                   softWrap: true,
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     //fontWeight: FontWeight.w600,
//                                     //letterSpacing: 2.5,
//                                   ),
//                                 ),
//                                 Text('${loadedProduct.size}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 20.0),
//                             child: Text(
//                               '${loadedProduct.description}',
//                               style: TextStyle(
//                                 fontSize: 17.5,
//                                 color: Colors.black54,
//                                 //height: 1.35,
//                                 fontStyle: FontStyle.italic,
//                                 //fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 20.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Text(
//                                   'Shipping Name',
//                                   //'${loadedProduct.title}',
//                                   softWrap: true,
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     //fontWeight: FontWeight.w600,
//                                     //letterSpacing: 2.5,
//                                   ),
//                                 ),
//                                 Text(
//                                   '${loadedProduct.shippingName}',
//                                   style: TextStyle(
//                                     fontSize: 18.0,
//                                     //fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 20.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Text(
//                                   'Shipping Address',
//                                   //'${loadedProduct.title}',
//                                   softWrap: true,
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     //fontWeight: FontWeight.w600,
//                                     //letterSpacing: 2.5,
//                                   ),
//                                 ),
//                                 Text(
//                                   '${loadedProduct.shippingAddress}',
//                                   style: TextStyle(
//                                     fontSize: 18.0,
//                                     //fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 20.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Text(
//                                   'Shipping City',
//                                   //'${loadedProduct.title}',
//                                   softWrap: true,
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     //fontWeight: FontWeight.w600,
//                                     //letterSpacing: 2.5,
//                                   ),
//                                 ),
//                                 Text('${loadedProduct.shippingCity}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w200)),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 20.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Text(
//                                   'Shipping State',
//                                   //'${loadedProduct.title}',
//                                   softWrap: true,
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     //fontWeight: FontWeight.w600,
//                                     //letterSpacing: 2.5,
//                                   ),
//                                 ),
//                                 Text('${loadedProduct.shippingState}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 20.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Text(
//                                   'Shipping Zip',
//                                   //'${loadedProduct.title}',
//                                   softWrap: true,
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     //fontWeight: FontWeight.w600,
//                                     //letterSpacing: 2.5,
//                                   ),
//                                 ),
//                                 Text('${loadedProduct.shippingZip}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 20.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Text(
//                                   'Shipping Phone',
//                                   //'${loadedProduct.title}',
//                                   softWrap: true,
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     //fontWeight: FontWeight.w600,
//                                     //letterSpacing: 2.5,
//                                   ),
//                                 ),
//                                 Text('${loadedProduct.shippingPhone}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 20.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Text(
//                                   'Shipping Email',
//                                   //'${loadedProduct.title}',
//                                   softWrap: true,
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     //fontWeight: FontWeight.w600,
//                                     //letterSpacing: 2.5,
//                                   ),
//                                 ),
//                                 Text('${loadedProduct.shippingEmail}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 40),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: <Widget>[
//                               Expanded(
//                                 child: Container(
//                                   margin: const EdgeInsets.symmetric(vertical: 8.0),
//                                   height: 48,
//                                   width: double.infinity,
//                                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: Colors.red),
//                                   child: TextButton(
//                                     child: Center(
//                                       child: Text(
//                                         'Reject',
//                                         style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.white, wordSpacing: 2.0, letterSpacing: 0.9),
//                                       ),
//                                     ),
//                                     onPressed: () async {
//                                       print('::loadedProduct.piToken ::>' + loadedProduct.piToken);
//                                       String _piToken = loadedProduct.piToken.toString();
//                                       //Provider.of<Shippments>(context, listen: false).archiveShippment(loadedProduct as Product);
//                                       print('calling executeRefund');
//                                       executeRefund(_piToken);
//                                       print('return executeRefund');
//                                       {
//                                         try {
//                                           await Provider.of<Shippments>(context, listen: false).deleteShippment(loadedProduct.id, loadedProduct.imageUrl0);
//                                         } catch (error) {
//                                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleting item failed!', textAlign: TextAlign.center)));
//                                         }
//                                         // delete
//                                         print('Item deleted by FailMail');
//                                       }
//                                       //delete
//
//                                       ScaffoldMessenger.of(context).showSnackBar(
//                                         SnackBar(
//                                           content: Text("Rejection email sent", textAlign: TextAlign.center),
//                                           backgroundColor: Colors.red,
//                                         ),
//                                       );
//                                       print('Reject pressed, sent text message that the purchase is no longer available');
//                                       print('code needed to send email/receipt');
//                                       //MailOptions();
//                                       //sendMail();
//                                       sendFailEmail(
//                                         loadedProduct.shippingEmail,
//                                         loadedProduct.imageUrl0,
//                                         loadedProduct.title,
//                                         loadedProduct.description,
//                                         loadedProduct.price,
//                                         loadedProduct.shippingName,
//                                         loadedProduct.shippingAddress,
//                                         loadedProduct.shippingZip,
//                                         loadedProduct.shippingState,
//                                         loadedProduct.shippingCity,
//                                         loadedProduct.status,
//                                         loadedProduct.size,
//                                         loadedProduct.type,
//                                       );
//                                       print('MailOptions called');
//                                       Navigator.of(context).pop();
//                                     }, //onPressed
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 10),
//                               Expanded(
//                                 child: Container(
//                                   margin: const EdgeInsets.symmetric(vertical: 8.0),
//                                   height: 48,
//                                   width: double.infinity,
//                                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: Colors.green),
//                                   child: TextButton(
//                                     child: Center(
//                                       child: Text(
//                                         'Confirm',
//                                         style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.white, wordSpacing: 2.0, letterSpacing: 0.9),
//                                       ),
//                                     ),
//                                     onPressed: () async {
//                                       ScaffoldMessenger.of(context).showSnackBar(
//                                         SnackBar(
//                                           content: Text("Confirmation email sent", textAlign: TextAlign.center),
//                                           backgroundColor: Colors.green,
//                                           duration: Duration(seconds: 2),
//                                         ),
//                                       );
//                                       print('confirmed pressed, send text message that purchased is confirmed, print shipping lable');
//                                       print('shippingEmail: ${loadedProduct.shippingEmail}');
//                                       sendConfirmEmail(
//                                         loadedProduct.shippingEmail,
//                                         loadedProduct.imageUrl0,
//                                         loadedProduct.title,
//                                         loadedProduct.description,
//                                         loadedProduct.price,
//                                         loadedProduct.shippingName,
//                                         loadedProduct.shippingAddress,
//                                         loadedProduct.shippingZip,
//                                         loadedProduct.shippingState,
//                                         loadedProduct.shippingCity,
//                                         loadedProduct.status,
//                                         loadedProduct.size,
//                                         loadedProduct.type,
//                                       );
//
//                                       {
//                                         try {
//                                           await Provider.of<Shippments>(context, listen: false).deleteShippment(loadedProduct.id, loadedProduct.imageUrl0);
//                                         } catch (error) {
//                                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleting item failed!', textAlign: TextAlign.center)));
//                                         }
//                                         //delete
//                                       }
//
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }
//
//   executeRefund(String _piToken) async {
//     print('issuing refund with piToken: $_piToken');
//     try {
//       Map<String, dynamic> body = {'payment_intent': _piToken};
//       print('body ===> ${body}');
//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/refunds'),
//         body: body,
//         headers: {
//           // 'Authorization': 'Bearer sk_test_51IN2IzCOjsikW1onnHc8MZhbHI4VSglHy5tr9bvMYPwwFntOyNsnepdULcEj1D78bQZwZbZEhqTar3SsFyQANNh400hZCwICdd',
//           'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
//           'Content-Type': 'application/x-www-form-urlencoded',
//         },
//       );
//       print('***Refund Intent response ===> ${response.body.toString()}');
//       print('***refund complete***');
//       return jsonDecode(response.body);
//     } catch (err) {
//       print('err refunding user: ${err.toString()}');
//     }
//   } //executeRefund
// }
