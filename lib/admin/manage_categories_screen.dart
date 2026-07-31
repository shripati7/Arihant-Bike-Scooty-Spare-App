import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  final CollectionReference categoriesRef =
      FirebaseFirestore.instance.collection('categories');

  bool loading = false;

  Future<void> addCategory() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Add Category"),
          content: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: "Category Name",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = controller.text.trim();

                if (name.isEmpty) {
                  return;
                }

                final duplicate = await categoriesRef
                    .where("name", isEqualTo: name)
                    .limit(1)
                    .get();

                if (!mounted) return;

                if (duplicate.docs.isNotEmpty) {
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Category already exists."),
                    ),
                  );

                  return;
                }

                setState(() {
                  loading = true;
                });

                await categoriesRef.add({
                  "name": name,
                  "createdAt": FieldValue.serverTimestamp(),
                });

                if (!mounted) return;

                Navigator.of(context).pop();

                setState(() {
                  loading = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Category added successfully."),
                  ),
                );
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> renameCategory(DocumentSnapshot document) async {
    final data = document.data() as Map<String, dynamic>;

    final controller = TextEditingController(
      text: data["name"] ?? "",
    );

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Rename Category"),
          content: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: "Category Name",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final newName = controller.text.trim();

                if (newName.isEmpty) return;

                final duplicate = await categoriesRef
                    .where("name", isEqualTo: newName)
                    .limit(1)
                    .get();

                if (!mounted) return;

                final alreadyExists = duplicate.docs.any(
                  (doc) => doc.id != document.id,
                );

                if (alreadyExists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Category already exists."),
                    ),
                  );
                  return;
                }

                await categoriesRef.doc(document.id).update({
                  "name": newName,
                });

                if (!mounted) return;

                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Category updated successfully."),
                  ),
                );
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteCategory(DocumentSnapshot document) async {
    final data = document.data() as Map<String, dynamic>;
    final categoryName = data["name"] ?? "";

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Delete Category"),
          content: Text(
            'Are you sure you want to delete "$categoryName"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final productSnapshot = await FirebaseFirestore.instance
        .collection("products")
        .where("category", isEqualTo: categoryName)
        .limit(1)
        .get();

    if (!mounted) return;

    if (productSnapshot.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "This category is being used by products.",
          ),
        ),
      );
      return;
    }

    await categoriesRef.doc(document.id).delete();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Category deleted successfully."),
      ),
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildEmpty() {
    return const Center(
      child: Text(
        "No Categories Found",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: categoriesRef.orderBy("name").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoading();
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return buildEmpty();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final document = docs[index];
            final data = document.data() as Map<String, dynamic>;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.category),
                ),
                title: Text(
                  data["name"] ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text("Product Category"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        renameCategory(document);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        deleteCategory(document);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Categories"),
        centerTitle: true,
      ),
      body: buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: loading ? null : addCategory,
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.add),
      ),
    );
  }
}
