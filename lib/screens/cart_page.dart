import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_application_qstp/screens/product_description_page.dart';
import 'package:shopping_application_qstp/widgets/action_bar.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection('products');

  final CollectionReference _userRef =
      FirebaseFirestore.instance.collection('users');

  User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _userRef.doc(_user!.uid).collection("Cart").get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(child: Text('${snapshot.error}')),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(
                  padding: EdgeInsets.fromLTRB(20, 80, 20, 0),
                  children: snapshot.data!.docs.map((document) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDescPage(
                                        productId: document.id,
                                      )));
                        },
                        child: FutureBuilder<DocumentSnapshot>(
                          future: _productsRef.doc(document.id).get(),
                          builder: (context, productSnapshot) {
                            if (productSnapshot.hasError) {
                              return Container(
                                child: Center(
                                  child: Text('${productSnapshot.error}'),
                                ),
                              );
                            }

                            if (productSnapshot.connectionState ==
                                ConnectionState.done) {
                              Map<String, dynamic> _productMap =
                                  productSnapshot.data!.data()
                                      as Map<String, dynamic>;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 30.0,
                                  horizontal: 24.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 90,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          "${_productMap['image']}",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: 16.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 190,
                                            child: Text(
                                              "${_productMap['title']}",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4.0,
                                            ),
                                            child: Text(
                                              "\$${_productMap['price']}",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.deepOrange,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Container(
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              ),
                            );
                          },
                        ));
                  }).toList(),
                );
              }

              //Loading Time

              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: CustomActionBar(
              hasTitle: true,
              hasBackground: true,
              hasBackArrow: true,
              title: 'Cart',
            ),
          )
        ],
      ),
    );
  }
}
