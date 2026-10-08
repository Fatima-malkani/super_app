import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),

      body: user == null
          ? const Center(
              child: Text(
                'Please login first',
                style: TextStyle(
                  color: AppTheme.secondaryTextColor,
                ),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .where(
                    'userId',
                    isEqualTo: user.uid,
                  )
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
                      'Could not load bookings',
                      style: TextStyle(
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return _emptyBookings();
                }

                final bookings = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final data = bookings[index].data()
                        as Map<String, dynamic>;

                    return _bookingCard(data);
                  },
                );
              },
            ),
    );
  }

  Widget _bookingCard(Map<String, dynamic> data) {
    final String serviceName =
        data['serviceName']?.toString() ?? 'Service';

    final String status =
        data['status']?.toString() ?? 'pending';

    final String address =
        data['address']?.toString() ?? '';

    final String phone =
        data['phone']?.toString() ?? '';

    final String time =
        data['time']?.toString() ?? '';

    final double price =
        double.tryParse(
              data['price']?.toString() ?? '0',
            ) ??
            0;

    String date = '';

    if (data['date'] is Timestamp) {
      final bookingDate =
          (data['date'] as Timestamp).toDate();

      date =
          '${bookingDate.day}/${bookingDate.month}/${bookingDate.year}';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color:
                      AppTheme.primaryColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.home_repair_service_outlined,
                  color: AppTheme.primaryColor,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Rs. ${price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              _statusBadge(status),
            ],
          ),

          const SizedBox(height: 18),

          _infoRow(
            Icons.calendar_month_outlined,
            date,
          ),

          const SizedBox(height: 8),

          _infoRow(
            Icons.access_time,
            time,
          ),

          const SizedBox(height: 8),

          _infoRow(
            Icons.location_on_outlined,
            address,
          ),

          const SizedBox(height: 8),

          _infoRow(
            Icons.phone_outlined,
            phone,
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    String statusText = status.toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusText,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppTheme.secondaryColor,
        ),
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String text,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppTheme.secondaryTextColor,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            text.isEmpty ? 'Not provided' : text,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.secondaryTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _emptyBookings() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_month_outlined,
              size: 65,
              color: AppTheme.secondaryTextColor,
            ),

            const SizedBox(height: 15),

            const Text(
              'No Bookings Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Your service bookings will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}