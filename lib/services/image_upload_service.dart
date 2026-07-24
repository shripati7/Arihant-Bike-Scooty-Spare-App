import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickFromGallery() async {
    try {
      return await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
    } catch (e) {
      print("Gallery Error: $e");
      return null;
    }
  }

  Future<XFile?> pickFromCamera() async {
    try {
      return await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
    } catch (e) {
      print("Camera Error: $e");
      return null;
    }
  }

  Future<String?> uploadImage({
    required XFile imageFile,
    required String folderName,
  }) async {
    try {
      File file = File(imageFile.path);

      String fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}";

      Reference ref = _storage.ref().child(folderName).child(fileName);

      UploadTask uploadTask = ref.putFile(file);

      TaskSnapshot snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Image Upload Error: $e");
      return null;
    }
  }
}
