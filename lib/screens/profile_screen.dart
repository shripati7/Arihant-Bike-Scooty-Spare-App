import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../services/settings_service.dart';
import '../models/shop_settings.dart';
import 'my_orders_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController shopContactController = TextEditingController();

  bool isLoading = true;

  UserModel? currentUser;
  int totalProducts = 0;
  int totalOrders = 0;
  int pendingOrders = 0;
  int completedOrders = 0;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final user = await UserService.instance.getCurrentUser();

      if (user != null) {
        currentUser = user;

        nameController.text = user.name;
        phoneController.text = user.phone;
        emailController.text = user.email;
        addressController.text = user.address;

        final shopSettings =
            await SettingsService.instance.getShopSettings(user.shopId);

        if (shopSettings != null) {
          shopNameController.text = shopSettings.shopName;
          shopContactController.text = shopSettings.mobile;
        }

        await loadDealerStats();
      } else {
        final firebaseUser = AuthService.instance.currentUser;

        phoneController.text = firebaseUser?.phoneNumber ?? '';
      }
    } catch (e) {
      debugPrint('Load User Error: $e');
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadDealerStats() async {
    final shopId = currentUser?.shopId ?? '';

    if (shopId.isEmpty) return;

    final productsSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('shopId', isEqualTo: shopId)
        .get();

    final ordersSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('shopId', isEqualTo: shopId)
        .get();

    totalProducts = productsSnapshot.docs.length;

    totalOrders = ordersSnapshot.docs.length;

    pendingOrders = ordersSnapshot.docs.where((doc) {
      return (doc.data()['status'] ?? '') == 'Pending';
    }).length;

    completedOrders = ordersSnapshot.docs.where((doc) {
      return (doc.data()['status'] ?? '') == 'Completed';
    }).length;
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (currentUser == null) return;

    final updatedUser = UserModel(
      uid: currentUser!.uid,
      name: nameController.text.trim(),
      phone: currentUser!.phone,
      email: emailController.text.trim(),
      address: addressController.text.trim(),
      createdAt: currentUser!.createdAt,
      role: currentUser!.role,
      shopId: currentUser!.shopId,
      shopCode: currentUser!.shopCode,
      isActive: currentUser!.isActive,
      trialEndDate: currentUser!.trialEndDate,
    );

    await UserService.instance.updateUser(updatedUser);
    await SettingsService.instance.saveShopSettings(
      shopId: currentUser!.shopId,
      settings: ShopSettings(
        shopName: shopNameController.text.trim(),
        mobile: shopContactController.text.trim(),
        address: addressController.text.trim(),
        logo: '',
      ),
    );

    currentUser = updatedUser;

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile Updated Successfully'),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    shopNameController.dispose();
    shopContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 10),
            const CircleAvatar(
              radius: 45,
              child: Icon(
                Icons.person,
                size: 45,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: phoneController,
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: saveProfile,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Save Profile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Subscription Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      currentUser?.isActive == true
                          ? 'Status: Active'
                          : 'Status: Expired',
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Shop Code: ${currentUser?.shopCode ?? '-'}',
                    ),
                    const SizedBox(height: 6),
                    Builder(
                      builder: (context) {
                        final expiryDate = currentUser?.trialEndDate?.toDate();

                        final remainingDays = expiryDate == null
                            ? 0
                            : expiryDate.difference(DateTime.now()).inDays + 1;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expiry Date: ${expiryDate?.toString().split(' ')[0] ?? '-'}',
                            ),
                            const SizedBox(height: 6),
                            Text(
                              remainingDays > 0
                                  ? 'Remaining Days: $remainingDays Days'
                                  : 'Subscription Expired',
                              style: TextStyle(
                                color: remainingDays > 0
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Shop Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: shopNameController,
                      decoration: const InputDecoration(
                        labelText: 'Shop Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: shopContactController,
                      decoration: const InputDecoration(
                        labelText: 'Shop Contact',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dealer Dashboard',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text('Shop Name: ${shopNameController.text}'),
                    SizedBox(height: 6),
                    Text('Shop Code: ${currentUser?.shopCode ?? "-"}'),
                    SizedBox(height: 6),
                    Text(
                      currentUser?.isActive == true
                          ? 'Subscription: Active'
                          : 'Subscription: Expired',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.shopping_bag),
                title: const Text('My Orders'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyOrdersScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: const Text('Logout'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text(
                        'Are you sure you want to logout?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout != true) return;

                  await AuthService.instance.logout();

                  if (!mounted) return;

                  // AuthWrapper automatically redirects to Login Screen.
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
