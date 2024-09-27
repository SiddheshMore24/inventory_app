class Product {
  int? id;
  String productName;
  String sku;
  double price;
  int quantity;

  Product({
    this.id,
    required this.productName,
    required this.sku,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'sku': sku,
      'price': price,
      'quantity': quantity,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      productName: map['productName'],
      sku: map['sku'],
      price: map['price'],
      quantity: map['quantity'],
    );
  }
}
