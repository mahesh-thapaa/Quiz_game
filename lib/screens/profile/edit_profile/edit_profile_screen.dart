import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'package:quiz_game/screens/profile/edit_profile/profile_avatar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _bioController;

  bool _isSaving = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    final p = context.read<UserProgressProvider>();
    _usernameController = TextEditingController(text: p.username);
    _bioController = TextEditingController(text: p.bio);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  final GlobalKey<ProfileAvatarState> _avatarKey =
      GlobalKey<ProfileAvatarState>();

  // ── Save username + bio ────────────────────────────────────────────────────
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _saved = false;
    });

    await context.read<UserProgressProvider>().updateProfile(
      username: _usernameController.text,
      bio: _bioController.text,
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
      _saved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.hText),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: AppColors.hText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Avatar with camera icon ────────────────────────────────
                Center(
                  child: Column(
                    children: [
                      // ProfileAvatar reads from provider automatically
                      ProfileAvatar(
                        key: _avatarKey,
                        radius: 52,
                        showCameraIcon: true,
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => _avatarKey.currentState?.showPicker(),
                        child: const Text(
                          'Change Photo',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ── Username ───────────────────────────────────────────────
                _label('Username'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _usernameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(color: AppColors.hText),
                  decoration: _inputDecoration(
                    'Enter your username',
                    Icons.person_outline,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Username cannot be empty';
                    }
                    if (v.trim().length < 3) {
                      return 'At least 3 characters required';
                    }
                    if (v.trim().length > 20) {
                      return 'Max 20 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 6),
                Text(
                  'Shown on your profile and leaderboards.',
                  style: TextStyle(color: AppColors.stext, fontSize: 12),
                ),
                const SizedBox(height: 24),

                // ── Bio ────────────────────────────────────────────────────
                Row(
                  children: [
                    _label('Bio'),
                    const SizedBox(width: 6),
                    Text(
                      '(optional)',
                      style: TextStyle(color: AppColors.stext, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _bioController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  maxLength: 120,
                  style: TextStyle(color: AppColors.hText),
                  decoration:
                      _inputDecoration(
                        'Tell others a bit about yourself…',
                        Icons.edit_note_rounded,
                      ).copyWith(
                        alignLabelWithHint: true,
                        counterStyle: TextStyle(color: AppColors.stext),
                      ),
                ),
                const SizedBox(height: 32),

                // ── Save button ────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _saved
                          ? Colors.green
                          : AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            _saved ? 'Saved ✓' : 'Save Changes',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      color: AppColors.hText,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.stext.withValues(alpha: 0.6)),
      prefixIcon: Icon(icon, color: AppColors.stext, size: 20),
      filled: true,
      fillColor: AppColors.cardBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}
