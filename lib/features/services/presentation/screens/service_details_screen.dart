import 'package:flutter/material.dart';
import '../../../bookings/presentation/screens/booking_screen.dart';
import '../../../../core/theme/app_theme.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final String name;
  final String description;
  final String category;
  final double price;

  const ServiceDetailsScreen({
    super.key,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      appBar: AppBar(
        title: const Text(
          'Service Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Icon
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.home_repair_service_outlined,
                size: 80,
                color: AppTheme.primaryColor,
              ),
            ),

            const SizedBox(height: 25),

            // Service Name
            Text(
              name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),

            const SizedBox(height: 8),

            // Category
            Text(
              category,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.secondaryTextColor,
              ),
            ),

            const SizedBox(height: 20),

            // Price
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Rs. ${price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Description heading
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),

            const SizedBox(height: 10),

            // Description
            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: AppTheme.secondaryTextColor,
              ),
            ),

            const SizedBox(height: 35),

            // Book Service Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookingScreen(serviceName: name, price: price),
                    ),
                  );
                },
                child: const Text(
                  'Book Service',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
