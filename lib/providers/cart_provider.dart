import 'package:flutter/cupertino.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];
  double _totalAmount = 0.0;

  List<Map<String, dynamic>> get items => _items;
  double get totalAmount => _totalAmount;

  /// Get the quantity of a specific dish in the cart
  int getItemQuantity(Map<String, dynamic> item) {
    // Find the item in the cart
    int index = _items.indexWhere((cartItem) => cartItem['id'] == item['id']);

    // If the item is found, return its quantity, otherwise return 0
    if (index != -1) {
      return _items[index]['quantity'] ?? 0; // Return the quantity if it exists, otherwise 0
    }

    // Return 0 if the item is not in the cart
    return 0;
  }


  void addToCart(Map<String, dynamic> item) {
    // Check if the item is already in the cart
    int existingIndex = _items.indexWhere((cartItem) => cartItem['id'] == item['id']);
    if (existingIndex != -1) {
      // If already exists, increment quantity instead of adding it again
      _items[existingIndex]['quantity'] = (_items[existingIndex]['quantity'] ?? 0) + 1;
    } else {
      // If not, add the item with quantity 1
      item['quantity'] = 1;
      _items.add(item);
    }

    // Ensure price is correctly parsed as a double
    double price = double.tryParse(item['price'].toString()) ?? 0.0;
    _totalAmount += price; // Use double for accurate calculations

    notifyListeners();
  }

  void removeFromCart(Map<String, dynamic> item) {
    // Find the item in the cart
    int index = _items.indexWhere((cartItem) => cartItem['id'] == item['id']);
    if (index != -1) {
      // Get the current quantity and price of the item
      int currentQuantity = _items[index]['quantity'] ?? 0;
      double price = double.tryParse(item['price'].toString()) ?? 0.0;

      if (currentQuantity > 1) {
        // If quantity is more than 1, just decrement the quantity
        _items[index]['quantity'] = currentQuantity - 1;
        _totalAmount -= price; // Subtract the price for the decreased quantity
      } else {
        // If quantity is 1, remove the item from the cart
        _totalAmount -= price; // Subtract the price before removing the item
        _items.removeAt(index);
      }

      // Notify listeners to update the UI
      notifyListeners();
    }
  }

  num get totalItems {
    num total = 0; // Use 'num' to handle both int and double
    // Iterate over each item in the cart and sum up the quantities
    for (var item in _items) {
      total += item['quantity'] ?? 0; // Add quantity to total, defaulting to 0 if null
    }
    return total;
  }



  /// Clear the cart after order placement
  void clearCart() {
    _items.clear();
    _totalAmount = 0.0;
    notifyListeners();
  }
}
