import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> menuData = [];
  int selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchMenu();
  }

  Future<void> fetchMenu() async {
    final response = await http.get(Uri.parse('https://faheemkodi.github.io/mock-menu-api/menu.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      setState(() {
        menuData = responseData['categories'];
      });
    } else {
      throw Exception('Failed to load menu');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final cartProvider = Provider.of<CartProvider>(context);

    return  Consumer<CartProvider>(builder: (context, cartProvider, child) {
        return Scaffold(
          appBar: AppBar(

            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.black),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen()));
                    },
                  ),
                  if (cartProvider.items.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.red,
                        child: Text(
                          '${cartProvider.totalItems}',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: [

                Container(
                  height: 200,
                  color:Colors.green ,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: FirebaseAuth.instance.currentUser?.photoURL != null
                          ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                          : AssetImage('assets/default_profile.png') as ImageProvider, // Default image if no profile pic
                    ),
                  SizedBox(height: 4,),
                  Text(FirebaseAuth.instance.currentUser?.displayName ?? 'User',style: TextStyle(
                    color: Colors.black,fontSize: 23
                  ),),
                    SizedBox(height: 4,),
                 // Text(FirebaseAuth.instance.currentUser?.email ?? FirebaseAuth.instance.currentUser?.phoneNumber ?? ''),
                  Text("ID : ${FirebaseAuth.instance.currentUser?.uid ?? 'No UID'}",
                      style: TextStyle(
                      color: Colors.black,fontSize: 16
                  ),),
                ],),),
                ListTile(
                  title: const Text('Logout',style: TextStyle(
                      color: Colors.grey,fontSize: 20
                  )),
                  leading: Icon(Icons.login_outlined),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              // Category Tabs
              Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: menuData.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategoryIndex = index;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: selectedCategoryIndex == index ? Colors.red : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            menuData[index]['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: selectedCategoryIndex == index ? FontWeight.bold : FontWeight.normal,
                              color: selectedCategoryIndex == index ? Colors.red : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Menu List
              Expanded(
                child: menuData.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: menuData[selectedCategoryIndex]['dishes'].length,
                  itemBuilder: (context, dishIndex) {
                    final dish = menuData[selectedCategoryIndex]['dishes'][dishIndex];

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            // Dish Indicator (Veg / Non-Veg)
                            // Container(
                            //   width: 12,
                            //   height: 12,
                            //   decoration: BoxDecoration(
                            //     shape: BoxShape.circle,
                            //     border: Border.all(color: Colors.black),
                            //     color: Colors.red, // You can customize the color based on veg/non-veg
                            //   ),
                            // ),
                            SizedBox(width: 8),

                            // Dish Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container( width: MediaQuery.of(context).size.width* .7,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              dish['name'], maxLines: 3,
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'INR ${dish['price']}',
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                                ),
                                                Spacer(),
                                                Text(
                                                  '${dish['calories']} calories',
                                                  style: TextStyle(fontSize: 14, color: Colors.black,fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12), // Rounded corners for image
                                        child: Image.network(
                                          "https://www.allrecipes.com/thmb/hI5hYn1sJB2mJar0h0lechfe1PU=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/AR-14276-Strawberry-Spinach-Salad-4x3-135a121dc0b24ad693289e221dcd3477.jpg", // Image URL from dish data
                                          width: 80,  // Adjust the width as needed
                                          height: 80, // Adjust the height as needed
                                          fit: BoxFit.cover, // Ensure the image covers the area properly
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(Icons.broken_image, size: 80, color: Colors.grey); // Placeholder for error handling
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),


                                  Container(width: MediaQuery.of(context).size.width* .7,
                                    child: Text(
                                      dish['description'] ?? '',
                                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                    ),
                                  ),
                                  SizedBox(height: 5),


                                  Container(
                                    width: 130,
                                  //  height: 50,
                                    decoration: BoxDecoration(
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
                                          onPressed: () => cartProvider.removeFromCart(dish),
                                        ),
                                        SizedBox(width: 10,),
                                        Text(
                                          '${cartProvider.getItemQuantity(dish)}',
                                          style: TextStyle(
                                            fontSize: 16,color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        IconButton(
                                          icon: Icon(Icons.add, color: Colors.white),
                                          onPressed: () => cartProvider.addToCart(dish),
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (dish.containsKey('addoncat')) // Customizations available
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        "Customizations Available",
                                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // Cart Controls


                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        );
      }
    );
  }
}
