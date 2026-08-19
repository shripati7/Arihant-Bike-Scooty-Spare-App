import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageDealersScreen extends StatelessWidget {
  const ManageDealersScreen({super.key});

  Future<void> _activateDealer(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'isActive': true,
    });
  }

  Future<void> _deactivateDealer(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'isActive': false,
    });
  }

  Future<void> _extendSubscription(
    String uid,
    Timestamp? currentExpiry,
  ) async {
    final baseDate = currentExpiry?.toDate() ?? DateTime.now();

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'isActive': true,
      'trialEndDate': Timestamp.fromDate(
        baseDate.add(
          const Duration(days: 30),
        ),
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Dealers'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'dealer')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No Dealers Found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          final dealers = snapshot.data!.docs;

          final totalDealers = dealers.length;

          final activeDealers = dealers.where((dealer) {
            final data = dealer.data() as Map<String, dynamic>;
            return data['isActive'] == true;
          }).length;

          final expiredDealers = totalDealers - activeDealers;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('$totalDealers'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              const Text(
                                'Active',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('$activeDealers'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              const Text(
                                'Expired',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('$expiredDealers'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: dealers.length,
                  itemBuilder: (context, index) {
                    final doc = dealers[index];

                    final data = doc.data() as Map<String, dynamic>;

                    final expiryDate =
                        (data['trialEndDate'] as Timestamp?)?.toDate();

                    final remainingDays = expiryDate == null
                        ? 0
                        : expiryDate.difference(DateTime.now()).inDays + 1;

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['name']?.toString().isNotEmpty == true
                                  ? data['name']
                                  : 'Dealer',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Shop Code: ${data['shopCode'] ?? '-'}',
                            ),
                            Text(
                              'Mobile: ${data['phone'] ?? '-'}',
                            ),
                            Text(
                              'Status: ${data['isActive'] == true ? "Active" : "Expired"}',
                            ),
                            Text(
                              'Expiry: ${expiryDate?.toString().split(' ')[0] ?? '-'}',
                            ),
                            Text(
                              remainingDays > 0
                                  ? 'Remaining Days: $remainingDays'
                                  : 'Subscription Expired',
                              style: TextStyle(
                                color: remainingDays > 0
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _activateDealer(
                                      doc.id,
                                    );
                                  },
                                  child: const Text(
                                    'Activate',
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _deactivateDealer(
                                      doc.id,
                                    );
                                  },
                                  child: const Text(
                                    'Deactivate',
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _extendSubscription(
                                      doc.id,
                                      data['trialEndDate'],
                                    );
                                  },
                                  child: const Text(
                                    '+30 Days',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
