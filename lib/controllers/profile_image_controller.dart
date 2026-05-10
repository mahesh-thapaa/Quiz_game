import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:quiz_game/api_keys.dart';

class ProfileImageController {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _picker = ImagePicker();

  // ── Cloudinary Configuration ──────────────────────────────────────────────
  final String _cloudName = ApiKeys.cloudinaryCloudName;
  final String _uploadPreset = ApiKeys.profileUploadPreset;

  String? get _uid => _auth.currentUser?.uid;

  /// Picks an image from camera or gallery
  Future<XFile?> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 512,
        maxHeight: 512,
      );
      return image;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  /// Manually compresses and resizes an image to ensure small file size
  Future<File?> _compressImage(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      // Resize the image to 512px (maintaining aspect ratio if desired, 
      // but here we force a square or max 512)
      final resized = img.copyResize(
        image, 
        width: 512, 
        height: 512, 
        interpolation: img.Interpolation.linear
      );

      // Encode as JPG with 70% quality
      final compressedBytes = img.encodeJpg(resized, quality: 70);

      // Save to a temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/profile_temp_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(compressedBytes);

      return tempFile;
    } catch (e) {
      debugPrint('❌ Compression Error: $e');
      return null;
    }
  }

  /// Uploads image to Cloudinary via REST API and updates Firestore
  Future<String?> uploadProfileImage(File imageFile) async {
    final uid = _uid;
    if (uid == null) return null;

    if (_uploadPreset == 'YOUR_UPLOAD_PRESET' || _uploadPreset.isEmpty) {
      debugPrint('❌ ERROR: You must set an Unsigned Upload Preset in ProfileImageController');
      return null;
    }

    try {
      // 1. Manually compress image first to guarantee small size
      final compressedFile = await _compressImage(imageFile);
      if (compressedFile == null) {
        debugPrint('❌ Failed to compress image');
        return null;
      }

      // ── Cloudinary REST API Upload ──
      final url = Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/image/upload');
      
      // Use a timestamp to ensure a unique public_id/URL every time
      // This bypasses all caching and ensures the UI updates instantly.
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uniquePublicId = '${uid}_$timestamp';

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = _uploadPreset
        ..fields['public_id'] = uniquePublicId
        ..fields['folder'] = 'profile_images'
        ..files.add(await http.MultipartFile.fromPath('file', compressedFile.path));

      final fileBytes = await compressedFile.length();
      debugPrint('📤 Uploading to Cloudinary (${(fileBytes / 1024).toStringAsFixed(2)} KB)...');

      // Increased timeout to 120 seconds for better reliability on extremely slow networks
      final streamedResponse = await request.send().timeout(const Duration(seconds: 120));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final String downloadUrl = responseData['secure_url'];

        // Update Firestore
        await _db.collection('user').doc(uid).set({
          'avatarUrl': downloadUrl,
        }, SetOptions(merge: true));

        debugPrint('✅ Cloudinary Upload Success: $downloadUrl');
        return downloadUrl;
      } else {
        debugPrint('❌ Cloudinary Upload Failed (Status ${response.statusCode}): ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Cloudinary Upload Error: $e');
      return null;
    }
  }

  /// Removes profile image reference from Firestore
  Future<bool> deleteProfileImage() async {
    final uid = _uid;
    if (uid == null) return false;

    try {
      await _db.collection('user').doc(uid).set({
        'avatarUrl': "",
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      debugPrint('Error clearing avatarUrl in Firestore: $e');
      return false;
    }
  }
}
