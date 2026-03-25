// lib/screens/edit_profile/edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

import 'package:quiz_game/screens/profile/edit_profile/edit_avatar.dart';
import 'package:quiz_game/screens/profile/edit_profile/edit_field.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialBio;
  final String avatarAsset;

  const EditProfileScreen({
    super.key,
    this.initialName = 'Sushant',
    this.initialBio =
        'UI/UX Enthusiast and trivia lover based in San Francisco. '
        'Passionate about building seamless mobile experiences.',
    this.avatarAsset = 'asstes/images/ronaldo.png',
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _bioCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _bioCtrl = TextEditingController(text: widget.initialBio);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    setState(() => _saving = true);
    // Simulate network save
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final c = ThemeColors.of(context);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: c.hText, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: c.hText,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Avatar
            Center(
              child: EditAvatar(
                avatarAsset: widget.avatarAsset,
                onChangeTap: () {
                  // TODO: image picker
                },
              ),
            ),

            const SizedBox(height: 32),

            // Name field
            EditField(
              label: 'NAME',
              controller: _nameCtrl,
              hint: 'Enter your name',
            ),

            const SizedBox(height: 20),

            // Bio field
            EditField(
              label: 'SHORT BIO',
              controller: _bioCtrl,
              maxLines: 5,
              hint: 'Tell us about yourself...',
            ),

            const SizedBox(height: 36),

            // Save button
            GestureDetector(
              onTap: _saving ? null : _onSave,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: _saving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
