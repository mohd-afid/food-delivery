import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header showing number of items and dishes
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${cart.items.length} Dishes - ${cart.totalItems} Items",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // List of cart items
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Item name and price
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 150,
                                child: Text(
                                  item['name'],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              SizedBox(height: 4),
                              Text(
                                "${item['calories']} calories",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                          // Quantity controls
                          Container(decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                          BorderRadius.all(Radius.circular(45))),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Padding(
                                    padding: const EdgeInsets.only(bottom: 14.0),
                                    child: Icon(Icons.minimize_rounded, color: Colors.white,),
                                  ),
                                  onPressed: () => cart.removeFromCart(item),
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  '${item['quantity']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                IconButton(
                                  icon: Icon(Icons.add, color: Colors.white),
                                  onPressed: () => cart.addToCart(item),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "INR ${item['price']}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Divider(),
            // Total Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "INR ${cart.totalAmount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Place Order Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Order Placed'),
                    content: Text('Order successfully placed!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          cart.clearCart();
                          Navigator.popUntil(context, ModalRoute.withName('/home'));
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                'Place Order',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
