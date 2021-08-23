import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_application_qstp/widgets/action_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';

class ProductDescPage extends StatefulWidget {
  final String productId;

  ProductDescPage({required this.productId});

  @override
  _ProductDescPageState createState() => _ProductDescPageState();
}

class _ProductDescPageState extends State<ProductDescPage> {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection('products');

  final CollectionReference _userRef =
      FirebaseFirestore.instance.collection('users');

  bool isDetails = false;

  User? _user = FirebaseAuth.instance.currentUser;

  Future _addtoCart() {
    return _userRef
        .doc(_user!.uid)
        .collection("Cart")
        .doc(widget.productId)
        .set({'size': 1});
  }

  Future _addtoFavorites() {
    return _userRef
        .doc(_user!.uid)
        .collection("favorites")
        .doc(widget.productId)
        .set({'size': 1});
  }

  final SnackBar _snackBar = SnackBar(content: Text('Added to cart!'));

  final SnackBar _snackBar1 = SnackBar(
    content: Text('Added to favorites!'),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        FutureBuilder<DocumentSnapshot>(
            future: _productsRef.doc(widget.productId).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('${snapshot.error}'),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    Container(
                        padding: EdgeInsets.only(bottom: 30),
                        height: 300,
                        width: 300,
                        margin: EdgeInsets.fromLTRB(30, 150, 30, 0),
                        child: Stack(children: [
                          PageView(
                            children: [
                              for (var i = 0; i < 3; i++)
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 4, color: Colors.black),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Image.network('${data['image']}'),
                                ),
                            ],
                          ),
                          Positioned(
                              bottom: 5,
                              right: 10,
                              child: Icon(Icons.swipe_sharp))
                        ])),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 20, 15),
                      child: Text(
                        //Product name
                        '${data['title']}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    //Price of product
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 20, 10),
                      child: Text(
                        '\$${data['price']}',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                    ),
                    //Add to cart button
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await _addtoCart();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(_snackBar);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.deepOrange[600]),
                              margin: EdgeInsets.only(left: 30),
                              height: 30,
                              width: 280,
                              child: Center(
                                child: Text('Add to Cart'),
                              )),
                        ),
                        //add to fav button
                        GestureDetector(
                          onTap: () async {
                            await _addtoFavorites();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(_snackBar1);
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.deepOrange[600]),
                            child: Center(child: Icon(Icons.favorite_border)),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //DETAILS BUTTON
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isDetails = !isDetails;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.deepOrange[600]),
                              height: 30,
                              width: 70,
                              margin: EdgeInsets.only(top: 10),
                              child: Center(
                                child: Text(isDetails ? 'Close' : 'Details'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: isDetails
                          ? Container(
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 2),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text('${data['desc']}'),
                            )
                          : Container(),
                    ),
                  ],
                );
              }

              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              );
            }),
        CustomActionBar(
          hasBackArrow: true,
          hasTitle: false,
          hasBackground: false,
        )
      ],
    ));
  }
}
