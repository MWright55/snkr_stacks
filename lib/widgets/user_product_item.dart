import 'package:flutter/material.dart';
import 'package:snkr_stacks/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:snkr_stacks/providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl0;
  final String sku;

  UserProductItem(this.id, this.title, this.imageUrl0, this.sku);

  @override
  Widget build(BuildContext context) {
    //    return ListTile(
    //      title: Text(title),
    //      leading: CircleAvatar(
    //        radius: 35,
    //        backgroundImage: NetworkImage(imageUrl),
    //      ),
    //      trailing: Container(
    //        width: 100,
    //        child: Row(
    //          children: <Widget>[
    //            IconButton(
    //              icon: Icon(Icons.edit),
    //              onPressed: () {
    //                Navigator.of(context)
    //                    .pushNamed(EditProductScreen.routeName, arguments: id);
    //              },
    //              color: Colors.lightGreen,
    //            ),
    //            IconButton(
    //              icon: Icon(Icons.delete),
    //              onPressed: () {
    //                //delete
    //                Provider.of<Products>(context, listen: false).deleteProduct(id);
    //              },
    //              color: Colors.red,
    //            )
    //          ],
    //        ),
    //      ),
    //    );

    print('***Now in user_product_item***');
    print(imageUrl0);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white, size: 35),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Delete Item?', textAlign: TextAlign.center),
            content: Text('Do you want to delete item from current Inventory?'),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              TextButton(
                child: Text('Yes', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (directions) async {
        try {
          await Provider.of<Products>(context, listen: false).deleteProduct(id, imageUrl0);
        } catch (error) {
          //scaffold.showSnackBar(
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleting item failed!', textAlign: TextAlign.center)));
        }
        //delete
      },

      child: Container(
        child: Hero(
          tag: id,
          child: Card(
            // borderRadius: BorderRadius.circular(10.0),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            margin: EdgeInsets.fromLTRB(5, 5, 5, 7),
            elevation: 10.0,
            child: GridTile(
              child: GestureDetector(
                onDoubleTap: () {
                  //onLongPress: () {
                  //Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: id);
                },
                child: Image.network(
                  imageUrl0,
                  height: 150,
                  width: double.infinity,
                  //child: Image.file(loadedProduct.image,
                  // fit: BoxFit.fitHeight),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),

      //       child: Container(
      //         height: 100,
      //         child: Card(
      //           margin: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
      //           child: Padding(
      //               padding: EdgeInsets.all(5),
      //               child: ListTile(
      //                 title: Text(title),
      //                 subtitle: Text('SKU: $sku'),
      //                 // leading: CircleAvatar(
      //                 //   radius: 35,
      //                 //   backgroundImage: NetworkImage(imageUrl0),
      //                 // ),
      //                 leading: ClipRRect(
      //                   borderRadius: BorderRadius.circular(10.0), //or 15.0
      //                   child: Container(
      //                     height: 70.0,
      //                     width: 70.0,
      //                     child: Image.network(imageUrl0, fit: BoxFit.cover),
      //                   ),
      //                 ),
      //                 trailing: Container(
      //                   width: 100,
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.end,
      //                     children: <Widget>[
      //                       IconButton(
      //                         icon: Icon(Icons.edit),
      //                         onPressed: () {
      //                           Navigator.of(context).pushNamed(
      //                               EditProductScreen.routeName,
      //                               arguments: id);
      //                         },
      //                         color: Colors.lightGreen,
      //                       ),
      //                       /* Code to Add Button instead of swipe delete */
      // //                    IconButton(
      // //                      icon: Icon(Icons.delete),
      // //                      onPressed: () {
      // //                        //delete
      // //
      // //                        Provider.of<Products>(context, listen: false)
      // //                            .deleteProduct(id);
      // //                      },
      // //                      color: Colors.red,
      // //                    )
      //                       /* Code to Add Button instead of swipe delete */
      //                     ],
      //                   ),
      //                 ),
      //               )),
      //         ),
      //       ),
    );
  }
}
