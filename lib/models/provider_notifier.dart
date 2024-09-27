import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_helper.dart';
import 'product.dart';

class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]) {
    _loadProducts();
  }
  Future<void> refreshProducts() async {
    await _loadProducts();
  }
  Future<void> _loadProducts() async {
    final products = await DBHelper.instance.readAllProducts();
    state = products;
  }

  Future<void> addProduct(Product product) async {
    try {
      await DBHelper.instance.createProduct(product);
      await _loadProducts();
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future<void> removeProduct(String sku) async {
    try {
      await DBHelper.instance.deleteProduct(sku);
      await _loadProducts();
    } catch (e) {
      print('Error removing product: $e');
    }
  }

  Future<void> updateQuantity(String sku, int newQuantity) async {
    try {
      final updatedProduct = state.firstWhere((product) => product.sku == sku)
        ..quantity = newQuantity;
      await DBHelper.instance.updateProduct(updatedProduct);
      await _loadProducts();
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  Future<void> updateProduct(Product updatedProduct) async {
    try {
      await DBHelper.instance.updateProduct(updatedProduct);
      await _loadProducts();
    } catch (e) {
      print('Error updating product: $e');
    }
  }
}

final productProvider =
StateNotifierProvider<ProductNotifier, List<Product>>((ref) {
  return ProductNotifier();
});
