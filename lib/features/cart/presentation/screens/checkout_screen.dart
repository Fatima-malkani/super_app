import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double total;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.total,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isLoading = false;

  Future<void> _placeOrder() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please login first')));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final firestore = FirebaseFirestore.instance;

      // Prepare order items
      final List<Map<String, dynamic>> orderItems = widget.cartItems.map((
        item,
      ) {
        final price = (item['price'] as num?)?.toDouble() ?? 0;

        final quantity = (item['quantity'] as num?)?.toInt() ?? 1;

        return {
          'name': item['name']?.toString() ?? 'Product',
          'category': item['category']?.toString() ?? 'General',
          'price': price,
          'quantity': quantity,
          'subtotal': price * quantity,
        };
      }).toList();

      // Create order
      await firestore.collection('orders').add({
        'userId': user.uid,
        'items': orderItems,
        'total': widget.total,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Get cart items
      final cartSnapshot = await firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();

      // Delete cart items
      final batch = firestore.batch();

      for (final doc in cartSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      // Success message
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Order Confirmed',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            content: const Text(
              'Your order has been placed successfully.',
              style: TextStyle(color: AppTheme.secondaryTextColor),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      // Go back to Home
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not place order: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Order Items',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),

                const SizedBox(height: 15),

                ...widget.cartItems.map((item) {
                  final name = item['name']?.toString() ?? 'Product';

                  final price = (item['price'] as num?)?.toDouble() ?? 0;

                  final quantity = (item['quantity'] as num?)?.toInt() ?? 1;

                  final subtotal = price * quantity;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            color: AppTheme.primaryColor,
                            size: 30,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textColor,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                'Rs. ${price.toStringAsFixed(0)} × $quantity',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.secondaryTextColor,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                'Subtotal: Rs. ${subtotal.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          // Bottom section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(color: Colors.white),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                        ),
                      ),

                      Text(
                        'Rs. ${widget.total.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _placeOrder,
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Confirm Order',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
