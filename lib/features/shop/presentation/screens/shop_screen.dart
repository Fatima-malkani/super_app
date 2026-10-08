import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import 'product_details_screen.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      appBar: AppBar(
        title: const Text(
          'Shop',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy('name')
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Could not load products',
                style: TextStyle(
                  color: AppTheme.secondaryTextColor,
                ),
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No products available',
                style: TextStyle(
                  color: AppTheme.secondaryTextColor,
                ),
              ),
            );
          }

          final products = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: products.length,

            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.68,
            ),

            itemBuilder: (context, index) {
              final data =
                  products[index].data()
                      as Map<String, dynamic>;

              final String name =
                  data['name']?.toString() ?? 'Product';

              final String description =
                  data['description']?.toString() ?? '';

              final String category =
                  data['category']?.toString() ?? 'General';

              final double price =
                  double.tryParse(
                        data['price']?.toString() ?? '0',
                      ) ??
                      0;

              return _productCard(
                context: context,
                name: name,
                description: description,
                category: category,
                price: price,
              );
            },
          );
        },
      ),
    );
  }

  Widget _productCard({
    required BuildContext context,
    required String name,
    required String description,
    required String category,
    required double price,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(18),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                name: name,
                description: description,
                category: category,
                price: price,
              ),
            ),
          );
        },

        child: Padding(
          padding: const EdgeInsets.all(15),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Container(
                height: 75,
                width: double.infinity,

                decoration: BoxDecoration(
                  color:
                      AppTheme.primaryColor.withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(15),
                ),

                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppTheme.primaryColor,
                  size: 35,
                ),
              ),

              const SizedBox(height: 12),

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
                category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.secondaryTextColor,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.secondaryTextColor,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Rs. ${price.toStringAsFixed(0)}',

                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}