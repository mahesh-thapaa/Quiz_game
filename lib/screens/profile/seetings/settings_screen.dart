// lib/screens/settings/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/profile/settings_models.dart';
import 'package:quiz_game/provider/notification_provider.dart';
import 'package:quiz_game/auth/change_password_screen.dart';
import 'widgets/settings_toggle_tile.dart';
import 'widgets/settings_arrow_tile.dart';
// import 'widgets/settings_dropdown_tile.dart';
import 'widgets/settings_section_header.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsModel _settings;

  @override
  void initState() {
    super.initState();
    _settings = SettingsModel();
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = context.watch<NotificationProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.hText, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: AppColors.hText,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingsSectionHeader(title: 'GENERAL'),
            _SectionCard(
              children: [
                SettingsToggleTile(
                  icon: Icons.dark_mode_outlined,
                  label: 'Dark Mode',
                  value: _settings.darkMode,
                  onChanged: (v) {
                    setState(() => _settings.darkMode = v);
                  },
                ),
                _TileDivider(),
                SettingsToggleTile(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  value: notificationProvider.notificationsEnabled,
                  onChanged: (v) => notificationProvider.toggleNotifications(v),
                ),
                // _TileDivider(),
                // SettingsToggleTile(
                //   icon: Icons.volume_up_outlined,
                //   label: 'Sound Effects',
                //   value: _settings.soundEffects,
                //   onChanged: (v) => setState(() => _settings.soundEffects = v),
                // ),
              ],
            ),

            const SettingsSectionHeader(title: 'ACCOUNT'),
            _SectionCard(
              children: [
                SettingsArrowTile(
                  icon: Icons.lock_outline,
                  label: 'Change Password',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            // const SettingsSectionHeader(title: 'PREFERENCES'),
            // _SectionCard(
            //   children: [
            //     SettingsDropdownTile(
            //       icon: Icons.language_outlined,
            //       label: 'Language',
            //       value: _settings.language,
            //       options: _languages,
            //       onChanged: (v) => setState(() => _settings.language = v),
            //     ),
            // ],
            // ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Version 2.4.0 (Lumino Technology)',
                style: TextStyle(color: AppColors.stext, fontSize: 12),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: children),
    );
  }
}

class _TileDivider extends StatelessWidget {
  const _TileDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.divider,
    );
  }
}
