import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.productName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product Name: ${product.productName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('SKU: ${product.sku}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Price:₹ ${product.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Quantity: ${product.quantity}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
