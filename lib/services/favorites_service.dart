import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:BlackFlipper/services/auth_service.dart';
import '../models/item_model.dart';

class FavoritesService {
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(bucket: 'favorites');

  // Helper to get the correct storage path
  String _getFavoritesPath(String userId) {
    return 'users/$userId/favorites.json';
  }

  Future<void> createFavoritesFileForNewUser(String userId) async {
    print('FavoritesService: createFavoritesFileForNewUser called for userId: $userId');
    try {
      final ref = _storage.ref(_getFavoritesPath(userId));
      await ref.getMetadata();
      print('FavoritesService: Favorites file already exists for userId: $userId');
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        print('FavoritesService: Creating new favorites file for userId: $userId');
        final ref = _storage.ref(_getFavoritesPath(userId));
        final data = jsonEncode([]);
        await ref.putString(data);
        print('FavoritesService: New favorites file created for userId: $userId');
      } else {
        print('FavoritesService: Error in createFavoritesFileForNewUser: $e');
      }
    }
  }

  Future<void> _writeFavorites(List<Item> favorites, String userId) async {
    print('FavoritesService: _writeFavorites called for userId: $userId');
    try {
      final ref = _storage.ref(_getFavoritesPath(userId));
      final data = jsonEncode(favorites.map((item) => item.toMap()).toList());
      await ref.putString(data);
      print('FavoritesService: Favorites written successfully for userId: $userId');
    } catch (e) {
      print('FavoritesService: Error writing favorites for userId $userId: $e');
      rethrow;
    }
  }

  Future<List<Item>> _readFavorites(String userId) async {
    print('FavoritesService: _readFavorites called for userId: $userId');
    try {
      final ref = _storage.ref(_getFavoritesPath(userId));
      final data = await ref.getData();
      if (data == null) {
        print('FavoritesService: No data found for userId: $userId');
        return [];
      }

      final List<dynamic> json = jsonDecode(utf8.decode(data));
      print('FavoritesService: Favorites read successfully for userId: $userId');
      return json.map((itemJson) => Item.fromJson(itemJson)).toList();
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        print('FavoritesService: Favorites file not found for userId: $userId');
        return [];
      }
      print('FavoritesService: FirebaseException in _readFavorites: $e');
      rethrow;
    } catch (e) {
      print('FavoritesService: General error in _readFavorites for userId $userId: $e');
      rethrow;
    }
  }

  Future<void> addFavorite(Item item) async {
    print('FavoritesService: addFavorite called for item: ${item.uniqueName}');
    final user = AuthService().getCurrentUser();
    if (user == null) {
      print('FavoritesService: addFavorite - No user logged in.');
      return;
    }
    print('FavoritesService: addFavorite - User UID: ${user.uid}');
    final favorites = await _readFavorites(user.uid);
    if (!favorites.any((i) => i.uniqueName == item.uniqueName)) {
      favorites.add(item);
      await _writeFavorites(favorites, user.uid);
      print('FavoritesService: Item ${item.uniqueName} added to favorites.');
    } else {
      print('FavoritesService: Item ${item.uniqueName} already in favorites.');
    }
  }

  Future<void> removeFavorite(String uniqueName) async {
    print('FavoritesService: removeFavorite called for item: $uniqueName');
    final user = AuthService().getCurrentUser();
    if (user == null) {
      print('FavoritesService: removeFavorite - No user logged in.');
      return;
    }
    print('FavoritesService: removeFavorite - User UID: ${user.uid}');
    final favorites = await _readFavorites(user.uid);
    favorites.removeWhere((i) => i.uniqueName == uniqueName);
    await _writeFavorites(favorites, user.uid);
    print('FavoritesService: Item $uniqueName removed from favorites.');
  }

  Stream<List<Item>> getFavorites() async* {
    print('FavoritesService: getFavorites called.');
    final user = AuthService().getCurrentUser();
    if (user == null) {
      print('FavoritesService: getFavorites - No user logged in.');
      yield [];
      return;
    }
    print('FavoritesService: getFavorites - User UID: ${user.uid}');
    yield await _readFavorites(user.uid);
  }

  Stream<bool> isFavorite(String uniqueName) async* {
    print('FavoritesService: isFavorite called for item: $uniqueName');
    final user = AuthService().getCurrentUser();
    if (user == null) {
      print('FavoritesService: isFavorite - No user logged in.');
      yield false;
      return;
    }
    print('FavoritesService: isFavorite - User UID: ${user.uid}');
    final favorites = await _readFavorites(user.uid);
    yield favorites.any((i) => i.uniqueName == uniqueName);
  }
}