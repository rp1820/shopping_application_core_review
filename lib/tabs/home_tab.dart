import 'package:flutter/material.dart';
import 'package:shopping_application_qstp/screens/product_description_page.dart';
import 'package:shopping_application_qstp/widgets/action_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:shopping_application_qstp/widgets/product_card.dart';

class HomeTab extends StatefulWidget {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection('products');

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: widget._productsRef.get(),
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
                    return ProductCard(
                      title: document['title'],
                      imageUrl: document['image'],
                      price: '\$${document['price']}',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProductDescPage(productId: document.id)));
                      },
                      productId: document.id,
                    );
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
          CustomActionBar(
            hasBackArrow: false,
            hasTitle: true,
            title: 'Home',
            hasBackground: true,
          )
        ],
      ),
    );
  }
}
