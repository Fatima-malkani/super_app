import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'checkout_screen.dart';
import '../../../../core/theme/app_theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // =========================
    // CHECK LOGIN
    // =========================

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Please login first',
            style: TextStyle(fontSize: 16, color: AppTheme.secondaryTextColor),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      // =========================
      // APP BAR
      // =========================
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,

        title: const Text(
          'My Cart',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
      ),

      // =========================
      // CART DATA
      // =========================
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .snapshots(),

        builder: (context, snapshot) {
          // -------------------------
          // LOADING
          // -------------------------

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          // -------------------------
          // ERROR
          // -------------------------

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 55,
                      color: Colors.red,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Could not load cart',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // -------------------------
          // NO DATA
          // -------------------------

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No cart data found',
                style: TextStyle(color: AppTheme.secondaryTextColor),
              ),
            );
          }

          final cartItems = snapshot.data!.docs;

          // -------------------------
          // EMPTY CART
          // -------------------------

          if (cartItems.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 70,
                    color: AppTheme.primaryColor,
                  ),

                  SizedBox(height: 15),

                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    'Add some products to your cart.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            );
          }

          // =========================
          // CALCULATE TOTAL
          // =========================

          double total = 0;

          for (final item in cartItems) {
            final data = item.data() as Map<String, dynamic>;

            final price = (data['price'] as num?)?.toDouble() ?? 0;

            final quantity = (data['quantity'] as num?)?.toInt() ?? 1;

            total += price * quantity;
          }

          // =========================
          // CART UI
          // =========================

          return Column(
            children: [
              // -------------------------
              // PRODUCT LIST
              // -------------------------
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),

                  itemCount: cartItems.length,

                  itemBuilder: (context, index) {
                    final item = cartItems[index];

                    final data = item.data() as Map<String, dynamic>;

                    final name = data['name']?.toString() ?? 'Product';

                    final description = data['description']?.toString() ?? '';

                    final category = data['category']?.toString() ?? 'General';

                    final price = (data['price'] as num?)?.toDouble() ?? 0;

                    final quantity = (data['quantity'] as num?)?.toInt() ?? 1;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),

                      padding: const EdgeInsets.all(15),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // =========================
                          // PRODUCT ICON
                          // =========================
                          Container(
                            height: 70,
                            width: 70,

                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.10),

                              borderRadius: BorderRadius.circular(15),
                            ),

                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              color: AppTheme.primaryColor,
                              size: 32,
                            ),
                          ),

                          const SizedBox(width: 15),

                          // =========================
                          // PRODUCT DETAILS
                          // =========================
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textColor,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  category,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.secondaryColor,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                if (description.isNotEmpty)
                                  Text(
                                    description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,

                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.secondaryTextColor,
                                    ),
                                  ),

                                const SizedBox(height: 7),

                                Text(
                                  'Rs. ${price.toStringAsFixed(0)}',

                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Container(
                                  margin: const EdgeInsets.only(top: 5),

                                  decoration: BoxDecoration(
                                    color: AppTheme.backgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),

                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // =========================
                                      // DECREASE
                                      // =========================
                                      IconButton(
                                        onPressed: () async {
                                          if (quantity > 1) {
                                            await item.reference.update({
                                              'quantity': quantity - 1,
                                            });
                                          }
                                        },

                                        icon: const Icon(
                                          Icons.remove,
                                          size: 18,
                                          color: AppTheme.primaryColor,
                                        ),

                                        constraints: const BoxConstraints(
                                          minWidth: 35,
                                          minHeight: 35,
                                        ),

                                        padding: EdgeInsets.zero,
                                      ),

                                      // =========================
                                      // QUANTITY
                                      // =========================
                                      Text(
                                        '$quantity',

                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.textColor,
                                        ),
                                      ),

                                      // =========================
                                      // INCREASE
                                      // =========================
                                      IconButton(
                                        onPressed: () async {
                                          await item.reference.update({
                                            'quantity': quantity + 1,
                                          });
                                        },

                                        icon: const Icon(
                                          Icons.add,
                                          size: 18,
                                          color: AppTheme.primaryColor,
                                        ),

                                        constraints: const BoxConstraints(
                                          minWidth: 35,
                                          minHeight: 35,
                                        ),

                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // =========================
                          // DELETE BUTTON
                          // =========================
                          IconButton(
                            onPressed: () async {
                              await item.reference.delete();

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Product removed from cart'),
                                  ),
                                );
                              }
                            },

                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // =========================
              // TOTAL SECTION
              // =========================
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: const BoxDecoration(color: Colors.white),

                child: SafeArea(
                  top: false,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      // -------------------------
                      // TOTAL
                      // -------------------------
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.secondaryTextColor,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            'Rs. ${total.toStringAsFixed(0)}',

                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),

                      // -------------------------
                      // CHECKOUT
                      // -------------------------
                      SizedBox(
                        width: 120,
                        height: 50,

                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutScreen(
                                  total: total,
                                  cartItems: cartItems.map((item) {
                                    return item.data() as Map<String, dynamic>;
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                          child: const Text('Checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
