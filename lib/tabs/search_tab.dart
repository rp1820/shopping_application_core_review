import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_application_qstp/screens/product_description_page.dart';
import 'package:shopping_application_qstp/widgets/custom_input_fields.dart';
import 'package:shopping_application_qstp/widgets/product_card.dart';

class SearchTab extends StatefulWidget {
  SearchTab({Key? key}) : super(key: key);

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection('products');

  String _searchValue = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if (_searchValue.isEmpty)
            Center(
              child: Container(
                  child: Icon(
                Icons.search,
                size: 200,
              )),
            )
          else
            FutureBuilder<QuerySnapshot>(
              future: _productsRef
                  .orderBy('title')
                  .startAt([_searchValue]).endAt(['$_searchValue\uf8ff']).get(),
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
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: CustomInputFields(
              hint: 'Search...',
              onSubmitted: (value) {
                setState(() {
                  _searchValue = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
