import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  static String routeName = '/products-screen';
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Products Page')),
    );
  }
}
