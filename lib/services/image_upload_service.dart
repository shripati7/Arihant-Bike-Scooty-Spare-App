import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<File> _compressImage(File file) async {
    final tempDir = await getTemporaryDirectory();

    final targetPath =
        "${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 35,
      minWidth: 400,
      minHeight: 400,
    );

    if (compressedFile == null) {
      return file;
    }

    return File(compressedFile.path);
  }

  Future<String?> uploadImage({
    required XFile imageFile,
    required String folderName,
  }) async {
    try {
      File file = File(imageFile.path);

      file = await _compressImage(file);

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
