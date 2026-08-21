import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/supplier_model.dart';

class SupplierService {
  SupplierService._();

  static final SupplierService instance = SupplierService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _suppliers =>
      _firestore.collection('suppliers');

  Future<void> createSupplier(SupplierModel supplier) async {
    await _suppliers.doc(supplier.supplierId).set(
          supplier.toMap(),
        );
  }

  Future<SupplierModel?> getSupplier(String supplierId) async {
    final doc = await _suppliers.doc(supplierId).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return SupplierModel.fromMap(doc.data()!);
  }

  Future<List<SupplierModel>> getAllSuppliers() async {
    final snapshot = await _suppliers.get();

    return snapshot.docs
        .map((doc) => SupplierModel.fromMap(doc.data()))
        .toList();
  }

  Future<void> updateSupplier(SupplierModel supplier) async {
    await _suppliers.doc(supplier.supplierId).update(
          supplier.toMap(),
        );
  }

  Future<void> deleteSupplier(String supplierId) async {
    await _suppliers.doc(supplierId).delete();
  }
}
