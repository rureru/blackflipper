import 'package:BlackFlipper/services/auth_service.dart';
import 'package:BlackFlipper/services/favorites_service.dart'; // Import FavoritesService
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../LanguageProvider.dart';
import '../RoleProvider.dart';

class GoPremiumPage extends StatelessWidget {
  const GoPremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final roleProvider = Provider.of<RoleProvider>(context, listen: false);
    final authService = AuthService();
    final favoritesService = FavoritesService(); // Create an instance

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(lang.getText('full_app')),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(FontAwesomeIcons.crown, color: Color(0xFFE5FF00), size: 100),
            const SizedBox(height: 20),
            Text(
              lang.getText('get_full_app'),
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                final userCredential = await authService.signInWithGoogle();
                if (userCredential != null) {
                  // Call createFavoritesFileForNewUser after successful sign-in
                  await favoritesService.createFavoritesFileForNewUser(userCredential.user!.uid);
                  roleProvider.setRole(UserRole.premium);
                  Navigator.pop(context);
                }
              },
              icon: const FaIcon(FontAwesomeIcons.google, color: Colors.white),
              label: const Text('Connect with Google', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
