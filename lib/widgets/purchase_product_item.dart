// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:transparent_image/transparent_image.dart';
// import 'package:snkr_stacks/screens/review_purchase_screen.dart';
//
// import '../providers/products_provider.dart';
// import '../screens/edit_product_screen.dart';
//
// class PurchaseProductItem extends StatelessWidget {
//   final String id;
//   final String title;
//   final String imageUrl0;
//   final String sku;
//
//   PurchaseProductItem(this.id, this.title, this.imageUrl0, this.sku);
//
//   @override
//   Widget build(BuildContext context) {
//     //print('**purchased_product_item this.id::${this.id}');
//     //print('**Now in purchase_product_item.dart**');
//
//     //   final scaffold = Scaffold.of(context);
//     // return ListTile(
//     //   title: Text(title),
//     //   leading: CircleAvatar(
//     //     radius: 35,
//     //     backgroundImage: NetworkImage(imageUrl0),
//     //   ),
//     //   trailing: Container(
//     //     width: 100,
//     //     child: Row(
//     //       children: <Widget>[
//     //         IconButton(
//     //           icon: Icon(Icons.edit),
//     //           onPressed: () {
//     //             Navigator.of(context)
//     //                 .pushNamed(EditProductScreen.routeName, arguments: id);
//     //           },
//     //           color: Colors.lightGreen,
//     //         ),
//     //         IconButton(
//     //           icon: Icon(Icons.delete),
//     //           onPressed: () {
//     //             //delete
//     //             Provider.of<Products>(context, listen: false).deleteProduct(id);
//     //           },
//     //           color: Colors.red,
//     //         )
//     //       ],
//     //     ),
//     //   ),
//     // );
//
//     // set up the buttons
//     // Widget cancelButton = FlatButton(
//     //   child: Text("Cancel"),
//     //   onPressed: () {},
//     // );
//     // Widget continueButton = FlatButton(
//     //   child: Text("Continue"),
//     //   onPressed: () {},
//     // );
//     //
//     // // set up the AlertDialog
//     // AlertDialog alert = AlertDialog(
//     //   title: Text("AlertDialog"),
//     //   content: Text(
//     //       "Would you like to continue learning how to use Flutter alerts?"),
//     //   actions: [
//     //     cancelButton,
//     //     continueButton,
//     //   ],
//     // );
//
//     /*Basic Card with Small picture*/
//     //     return Card(
//     //       margin: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
//     //       child: Padding(
//     //           padding: EdgeInsets.all(5),
//     //           child: ListTile(
//     //             title: Text(title),
//     //             subtitle: Text('SKU: $sku'),
//     //             // leading: CircleAvatar(
//     //             //   radius: 35,
//     //             //   backgroundImage: NetworkImage(imageUrl0),
//     //             // ),
//     //             leading: ClipRRect(
//     //               borderRadius: BorderRadius.circular(10.0), //or 15.0
//     //               child: Container(
//     //                 height: 70.0,
//     //                 width: 70.0,
//     //                 child: Image.network(imageUrl0, fit: BoxFit.cover),
//     //               ),
//     //             ),
//     //             trailing: Container(
//     //               width: 100,
//     //               child: Row(
//     //                 mainAxisAlignment: MainAxisAlignment.end,
//     //                 children: <Widget>[
//     //                   IconButton(
//     //                     icon: Icon(Icons.rate_review),
//     //                     onPressed: () {
//     //                       Navigator.of(context).pushNamed(
//     //                           ReviewPurchaseScreen.routeName,
//     //                           arguments: id);
//     //                     },
//     //                     color: Colors.lightGreen,
//     //                   ),
//     //                   /* Code to Add Button instead of swipe delete */
//     // //                    IconButton(
//     // //                      icon: Icon(Icons.delete),
//     // //                      onPressed: () {
//     // //                        //delete
//     // //
//     // //                        Provider.of<Products>(context, listen: false)
//     // //                            .deleteProduct(id);
//     // //                      },
//     // //                      color: Colors.red,
//     // //                    )
//     //                   /* Code to Add Button instead of swipe delete */
//     //                 ],
//     //               ),
//     //             ),
//     //           )),
//     //     );
//
//     /*Full image card */
//     return Container(
//       child: Hero(
//         tag: this.id,
//         child: Card(
//           semanticContainer: true,
//           clipBehavior: Clip.antiAliasWithSaveLayer,
//           margin: EdgeInsets.fromLTRB(5, 5, 5, 7),
//           elevation: 10.0,
//           child: GridTile(
//             child: GestureDetector(
//               onTap: () {
//                 //onDoubleTap: () {
//                 Navigator.of(context).pushNamed(ReviewPurchaseScreen.routeName, arguments: id);
//               },
//               child: Stack(
//                 children: [
//                   // Image.network(this.imageUrl0,
//                   //     height: 150,
//                   //     width: double.infinity,
//                   //     //child: Image.file(loadedProduct.image,
//                   //     // fit: BoxFit.fitHeight),
//                   //     fit: BoxFit.cover),
//                   FadeInImage.memoryNetwork(height: 150, width: double.infinity, fit: BoxFit.cover, fadeInDuration: Duration(milliseconds: 650), placeholder: kTransparentImage, image: this.imageUrl0),
//                   Positioned(
//                     bottom: 26,
//                     right: 8,
//                     left: 8,
//                     child: Text(
//                       '${this.title}',
//                       style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 8,
//                     right: 8,
//                     left: 8,
//                     child: Text(
//                       'SKU: ${this.sku}',
//                       style: TextStyle(
//                         // fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
