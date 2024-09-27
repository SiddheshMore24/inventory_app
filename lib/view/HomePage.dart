import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../models/provider_notifier.dart';
import 'AddProductPage.dart';
import 'EditProductPage.dart';
import 'ProductDetailsPage.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortOption = 'Name';

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);

    final filteredProducts = products.where((product) {
      return product.productName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (_sortOption == 'Name') {
      filteredProducts.sort((a, b) => a.productName.compareTo(b.productName));
    } else if (_sortOption == 'Price') {
      filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Product List', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue.shade800,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue.shade800,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by product name',
                        prefixIcon: Icon(Icons.search, color: Colors.blue.shade800),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _sortOption,
                        onChanged: (String? newValue) {
                          setState(() {
                            _sortOption = newValue!;
                          });
                        },
                        items: <String>['Name', 'Price']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        icon: Icon(Icons.sort, color: Colors.blue.shade800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
              child: Text(
                'No Products Available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.productName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (product.quantity < 5)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Low Stock',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text('Price: ₹ ${product.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.green.shade700)),
                        Text('SKU: ${product.sku}'),
                        Text('Quantity: ${product.quantity}'),
                      ],
                    ),
                    onTap: () {
                      _showProductDetailsDialog(context, product);
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade800,
                      child: Text(
                        product.productName[0],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue.shade800,
      ),
    );
  }

  void _showProductDetailsDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(product.productName, style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price: ₹ ${product.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.green.shade700)),
              SizedBox(height: 4),
              Text('SKU: ${product.sku}'),
              SizedBox(height: 4),
              Text('Quantity: ${product.quantity}'),
              if (product.quantity < 5)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '⚠️ Low Stock',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          actions: [
            ElevatedButton.icon(
              icon: Icon(Icons.edit),
              label: Text('Edit',style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
                _editProduct(context, ref, product);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
              ),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.delete),
              label: Text('Delete',style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct(ref, product.sku);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _editProduct(BuildContext context, WidgetRef ref, Product product) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProductPage(product: product),
      ),
    );

    if (result == true) {
      ref.refresh(productProvider);
    }
  }

  void _deleteProduct(WidgetRef ref, String sku) async {
    await showDialog(
      context: ref.context,
      builder: (context) => AlertDialog(
        title: Text('Delete Product'),
        content: Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(productProvider.notifier).removeProduct(sku);
              Navigator.of(context).pop();
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}