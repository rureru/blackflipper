import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../LanguageProvider.dart';
import '../RoleProvider.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const BottomNavBar({super.key, required this.selectedIndex});

  void _onItemTapped(BuildContext context, int index) {
    final userRole = Provider.of<RoleProvider>(context, listen: false).userRole;
    int newIndex = index;
    if (userRole == UserRole.freemium && index >= 2) {
      newIndex = index + 1;
    }

    if (newIndex == selectedIndex) return;

    switch (newIndex) {
      case 0:
        Navigator.pushReplacementNamed(context, '/homePage');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/market');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/fav');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final userRole = Provider.of<RoleProvider>(context).userRole;

    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home),
        label: lang.getText('home'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.store),
        label: lang.getText('market'),
      ),
    ];

    if (userRole == UserRole.premium) {
      items.add(
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite),
          label: lang.getText('favorites'),
        ),
      );
    }

    items.add(
      BottomNavigationBarItem(
        icon: const Icon(Icons.settings),
        label: lang.getText('settings'),
      ),
    );

    int effectiveSelectedIndex = selectedIndex;
    if (userRole == UserRole.freemium && selectedIndex >= 2) {
      effectiveSelectedIndex = selectedIndex - 1;
    }

    return BottomNavigationBar(
      items: items,
      currentIndex: effectiveSelectedIndex,
      onTap: (index) => _onItemTapped(context, index),
      backgroundColor: Colors.black,
      selectedItemColor: const Color(0xFF00B054),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    );
  }
}
