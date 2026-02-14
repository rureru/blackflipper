import 'package:BlackFlipper/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../LanguageProvider.dart';
import '../OverlayProvider.dart'; // Import OverlayProvider
import '../RoleProvider.dart';
import '../components/pp.dart';
import '../components/terms.dart';
import '../components/bottom_nav_bar.dart';
import 'GoPremiumPage.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  static String routeName = 'settings';
  static String routePath = '/settings';

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  bool _notificationsEnabled = false;
  final AuthService _authService = AuthService();

  final List<Map<String, String>> languages = [
    {'code': 'en', 'label': 'English'},
    {'code': 'tr', 'label': 'Türkçe'},
    {'code': 'ru', 'label': 'Русский'},
    {'code': 'fr', 'label': 'Français'},
  ];

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context, listen: true);
    final overlayProvider = Provider.of<OverlayProvider>(context, listen: true);
    final roleProvider = Provider.of<RoleProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(lang.getText('settings')),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              if (user == null)
                _buildSettingsCard(
                  context,
                  lang,
                  icon: FontAwesomeIcons.crown,
                  iconColor: const Color(0xFFE5FF00),
                  title: lang.getText('full_app'),
                  subtitle: lang.getText('get_full_app'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GoPremiumPage()),
                    );
                  },
                )
              else
                _buildProfileCard(context, lang, user),
              if (roleProvider.userRole == UserRole.premium)
                ...[
                  _buildSwitchCard(
                    context,
                    lang,
                    title: lang.getText('notifications'),
                    value: _notificationsEnabled,
                    onChanged: (value) => setState(() => _notificationsEnabled = value),
                  ),
                  _buildSwitchCard(
                    context,
                    lang,
                    title: lang.getText('overlay'),
                    value: overlayProvider.isOverlayEnabled, // Use state from OverlayProvider
                    onChanged: (value) => overlayProvider.toggleOverlayWithPermission(value), // Call toggleOverlayWithPermission
                  ),
                ],
              _buildSettingsCard(
                context,
                lang,
                title: lang.getText('privacy_policy'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const Dialog(child: PpWidget()),
                  );
                },
              ),
              _buildSettingsCard(
                context,
                lang,
                title: lang.getText('terms_conditions'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const Dialog(child: TermsWidget()),
                  );
                },
              ),
              _buildLanguageCard(context, lang),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 3),
    );
  }

  Widget _buildProfileCard(BuildContext context, LanguageProvider lang, User user) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.photoURL ?? ''),
        ),
        title: Text(user.displayName ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(user.email ?? '', style: const TextStyle(color: Colors.white70)),
        trailing: IconButton(
          icon: const Icon(Icons.logout, color: Colors.white70),
          onPressed: () async {
            await _authService.signOut();
          },
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context,
    LanguageProvider lang,
    {
    IconData? icon,
    Color? iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: icon != null ? FaIcon(icon, color: iconColor) : null,
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.white70)) : null,
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchCard(
    BuildContext context,
    LanguageProvider lang,
    {
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF00B054),
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context, LanguageProvider lang) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(lang.getText('language'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: lang.languageCode,
              dropdownColor: Colors.grey[800],
              style: const TextStyle(color: Colors.white),
              items: languages.map<DropdownMenuItem<String>>((Map<String, String> language) {
                return DropdownMenuItem<String>(
                  value: language['code'],
                  child: Text(language['label']!),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  lang.setLanguage(newValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
