import 'dart:developer';
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
      log(
        "Gallery Error",
        error: e,
        name: "ImageUploadService",
      );
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
      log(
        "Camera Error",
        error: e,
        name: "ImageUploadService",
      );
      return null;
    }
  }

  Future<String?> uploadImage({
    required XFile imageFile,
    required String folderName,
  }) async {
    try {
      final File file = File(imageFile.path);

      final String fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}";

      final Reference ref = _storage.ref().child(folderName).child(fileName);

      final UploadTask uploadTask = ref.putFile(file);

      final TaskSnapshot snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      log(
        "Image Upload Error",
        error: e,
        name: "ImageUploadService",
      );
      return null;
    }
  }
}
