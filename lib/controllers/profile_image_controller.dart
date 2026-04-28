import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ProfileImageController {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _picker = ImagePicker();

  // ── Cloudinary Configuration ──────────────────────────────────────────────
  final String _cloudName = 'daklgxzd7';
  final String _uploadPreset = 'hyy7xldd'; 

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

  /// Uploads image to Cloudinary via REST API and updates Firestore
  Future<String?> uploadProfileImage(File imageFile) async {
    final uid = _uid;
    if (uid == null) return null;

    if (_uploadPreset == 'YOUR_UPLOAD_PRESET' || _uploadPreset.isEmpty) {
      debugPrint('❌ ERROR: You must set an Unsigned Upload Preset in ProfileImageController');
      return null;
    }

    try {
      // ── Cloudinary REST API Upload ──
      final url = Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/image/upload');
      
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = _uploadPreset
        ..fields['public_id'] = uid
        ..fields['folder'] = 'profile_images'
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final streamedResponse = await request.send().timeout(const Duration(seconds: 15));
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
        debugPrint('❌ Cloudinary Upload Failed: ${response.body}');
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
