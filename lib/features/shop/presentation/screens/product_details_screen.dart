import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String name;
  final String description;
  final String category;
  final double price;

  const ProductDetailsScreen({
    super.key,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Icon
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 90,
                color: AppTheme.primaryColor,
              ),
            ),

            const SizedBox(height: 24),

            // Category
            Text(
              category,
              style: const TextStyle(
                color: AppTheme.secondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            // Product Name
            Text(
              name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),

            const SizedBox(height: 12),

            // Price
            Text(
              'Rs. ${price.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),

            const SizedBox(height: 20),

            // Description
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.secondaryTextColor,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            // Add to Cart
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;

                  if (user == null) {
                    return;
                  }

                  final cartRef = FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .collection('cart')
                      .doc();

                  await cartRef.set({
                    'name': name,
                    'description': description,
                    'category': category,
                    'price': price,
                    'quantity': 1,
                    'addedAt': FieldValue.serverTimestamp(),
                  });

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product added to cart')),
                    );
                  }
                },
                icon: const Icon(Icons.shopping_cart_outlined),
                label: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
