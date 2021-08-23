import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_application_qstp/screens/cart_page.dart';

class CustomActionBar extends StatefulWidget {
  final bool hasTitle;
  final bool hasBackground;
  final bool hasBackArrow;
  final String? title;
  const CustomActionBar(
      {required this.hasTitle,
      required this.hasBackground,
      this.title,
      required this.hasBackArrow});

  @override
  _CustomActionBarState createState() => _CustomActionBarState();
}

class _CustomActionBarState extends State<CustomActionBar> {
  final CollectionReference _userRef =
      FirebaseFirestore.instance.collection('users');

  User? _user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    bool _hasBackArrow = widget.hasBackArrow ?? false;
    bool _hasTitle = widget.hasTitle ?? true;
    bool _hasBackground = widget.hasBackground ?? true;

    return Container(
      decoration: BoxDecoration(
          gradient: widget.hasBackground
              ? LinearGradient(
                  colors: [
                    Colors.red.shade900,
                    Colors.red.shade900.withOpacity(0)
                  ],
                  begin: Alignment(0, 0),
                  end: Alignment(0, 1),
                )
              : null),
      padding: EdgeInsets.fromLTRB(20, 70, 20, 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //first child of row --> black rounded box
          if (_hasBackArrow)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.black),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          //second child of row---> text bar to display name of page we are currently in
          if (_hasTitle)
            Positioned(
              child: Text(
                widget.title ?? 'aCTION bAR',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          //third child ---> cart button

          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CartPage()));
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2), color: Colors.black),
              //stack to keep one circular count display on top of the cart symbol
              child: Stack(
                children: [
                  Positioned(
                    top: 5,
                    left: 5,
                    bottom: 5,
                    right: 5,
                    child: Icon(
                      Icons.shopping_cart_rounded,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: 1.5,
                    left: 20,
                    child: Container(
                      child: Center(
                          child: StreamBuilder<QuerySnapshot>(
                        stream: _userRef
                            .doc(_user!.uid)
                            .collection('Cart')
                            .snapshots(),
                        builder: (context, snapshot) {
                          int _totalproducts = 0;

                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            List _documents = snapshot.data!.docs;
                            _totalproducts = _documents.length;
                          }

                          return Text(
                            '$_totalproducts',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 8),
                          );
                        },
                      )),
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.red[600],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
