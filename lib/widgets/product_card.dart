import 'package:flutter/material.dart';
import 'package:shopping_application_qstp/screens/product_description_page.dart';

class ProductCard extends StatelessWidget {
  final Function onPressed;
  final String imageUrl;
  final String title;
  final String price;
  final String productId;
  const ProductCard(
      {required this.imageUrl,
      required this.onPressed,
      required this.price,
      required this.title,
      required this.productId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDescPage(
                      productId: productId,
                    )));
      },
      child: Container(
        padding: EdgeInsets.all(50),
        child: Column(
          children: [
            //the image of product
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.amber,
                    border: Border.all(width: 4, color: Colors.black),
                    borderRadius: BorderRadius.circular(5)),
                child: Image.network(
                  '$imageUrl',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                child: Text(
                  price,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.deepOrange),
                ),
              ),
            ),

            //Product name and price of product
          ],
        ),
        // Text('Name: ${document['price']}')
      ),
    );
  }
}
