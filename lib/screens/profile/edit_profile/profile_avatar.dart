import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'package:quiz_game/provider/profile_image_provider.dart';
import 'package:quiz_game/controllers/profile_image_controller.dart';

class ProfileAvatar extends StatefulWidget {
  final double radius;
  final bool showCameraIcon;
  final VoidCallback? onUploadComplete;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    this.radius = 24,
    this.showCameraIcon = false,
    this.onUploadComplete,
    this.onTap,
  });

  @override
  State<ProfileAvatar> createState() => ProfileAvatarState();
}

class ProfileAvatarState extends State<ProfileAvatar> {
  final _controller = ProfileImageController();
  bool _isUploading = false;
  File? _previewImage; // To show image immediately after picking

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileImageProvider>().loadAvatar();
    });
  }

  void showPicker() => _showPickerOptions(context);

  Future<void> _handleImageAction(
    BuildContext context,
    ImageSource? source,
  ) async {
    Navigator.pop(context);

    if (source == null) {
      try {
        setState(() => _isUploading = true);
        final success = await _controller.deleteProfileImage();
        if (success) {
          if (mounted) {
            context.read<ProfileImageProvider>().removeAvatar();
            setState(() => _previewImage = null);
          }
        }
      } finally {
        if (mounted) setState(() => _isUploading = false);
      }
      return;
    }

    final XFile? pickedFile = await _controller.pickImage(source);
    if (pickedFile == null) return;

    // Show preview immediately
    final file = File(pickedFile.path);
    setState(() => _previewImage = file);

    try {
      setState(() => _isUploading = true);

      // Upload image
      final downloadUrl = await _controller.uploadProfileImage(file);

      if (downloadUrl != null) {
        if (mounted) {
          context.read<ProfileImageProvider>().setAvatarUrl(downloadUrl);
          widget.onUploadComplete?.call();
          // After remote URL is in provider, we can clear local preview
          setState(() => _previewImage = null);
        }
      } else {
        if (mounted) {
          // If upload failed, clear preview too or keep it?
          // Usually better to keep it but show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Failed to sync photo to cloud. Check your connection.',
              ),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.white24, width: 1),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Upload error: $e');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _showPickerOptions(BuildContext context) {
    final hasImage =
        context.read<ProfileImageProvider>().avatarUrl.isNotEmpty ||
        _previewImage != null;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text(
                'Camera',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => _handleImageAction(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text(
                'Gallery',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => _handleImageAction(context, ImageSource.gallery),
            ),
            if (hasImage)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.redAccent),
                title: const Text(
                  'Remove Photo',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onTap: () => _handleImageAction(context, null),
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<UserProgressProvider>();
    final imgProv = context.watch<ProfileImageProvider>();

    final avatarUrl = imgProv.avatarUrl;
    final hasRemoteImage = avatarUrl.isNotEmpty;
    final hasPreview = _previewImage != null;
    final letter = p.username.isNotEmpty ? p.username[0].toUpperCase() : '?';

    // Image Priority: 1. Local Preview (picked but uploading), 2. Remote URL, 3. Initials
    ImageProvider? image;
    if (hasPreview) {
      image = FileImage(_previewImage!);
    } else if (hasRemoteImage) {
      image = NetworkImage(avatarUrl);
    }

    return GestureDetector(
      onTap:
          widget.onTap ??
          (widget.showCameraIcon ? () => _showPickerOptions(context) : null),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: widget.radius,
            backgroundColor: AppColors.deepCard,
            backgroundImage: image,
            child: _isUploading || imgProv.isLoading
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : (image == null
                      ? Text(
                          letter,
                          style: TextStyle(
                            color: AppColors.hText,
                            fontSize: widget.radius * 0.7,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null),
          ),
          if (widget.showCameraIcon)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: widget.radius * 0.65,
                height: widget.radius * 0.65,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: widget.radius * 0.35,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
