import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:BlackFlipper/models/item_model.dart';

class ItemRepository {
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(bucket: "flipping-results");

  final Map<String, List<Reference>> _fileListCache = {};
  final Map<String, DateTime> _cacheTimestamp = {};

  Future<List<Item>> fetchItems({
    int page = 1,
    bool? isBlackMarket,
    bool forceRefresh = false,
    String? query,
    String? itemType,
    String? tier,
    String? enchant,
    String? quality,
    int? minProfit,
    double? minProfitPercent,
  }) async {
    final String folderPath = (isBlackMarket == true) ? 'blackmarket-trades' : 'city-trades';

    try {
      final bool isCacheInvalid = forceRefresh || 
                                  _fileListCache[folderPath] == null || 
                                  _cacheTimestamp[folderPath] == null || 
                                  DateTime.now().difference(_cacheTimestamp[folderPath]!).inHours > 0;

      if (isCacheInvalid) {
        print("Fetching file list from Cloud Storage folder: $folderPath");
        final listResult = await _storage.ref(folderPath).listAll();
        
        listResult.items.sort((a, b) => a.name.compareTo(b.name));
        
        _fileListCache[folderPath] = listResult.items;
        _cacheTimestamp[folderPath] = DateTime.now();
        print("Found ${_fileListCache[folderPath]!.length} batch files in $folderPath.");
      }

      final List<Reference> fileList = _fileListCache[folderPath]!;
      final fileIndex = page - 1;

      if (fileIndex < 0 || fileIndex >= fileList.length) {
        print("Page index $fileIndex is out of bounds for folder $folderPath. Reached max.");
        return [];
      }

      final fileToDownload = fileList[fileIndex];
      print("Fetching batch file: ${fileToDownload.fullPath}");

      final Uint8List? fileData = await fileToDownload.getData(10 * 1024 * 1024);

      if (fileData == null) {
        throw Exception('Failed to download file data for ${fileToDownload.fullPath}');
      }

      // Decode the JSON and access the list within the 'items' key.
      final String jsonString = utf8.decode(fileData);
      final Map<String, dynamic> decodedData = json.decode(jsonString);
      final List<dynamic> jsonList = decodedData['items'] as List<dynamic>? ?? [];

      final items = jsonList.map((json) => Item.fromJson(json)).toList();
      
      return items;

    } on FirebaseException catch (e) {
      print("Firebase Storage Error: ${e.code} - ${e.message}");
      if (e.code == 'object-not-found') {
        throw Exception('The folder $folderPath was not found in the flipping-results bucket.');
      }
      throw Exception('Failed to load data from Cloud Storage. Check permissions and network.');
    } catch (e) {
      print("An unexpected error occurred in ItemRepository: $e");
      throw Exception('An error occurred while processing data.');
    }
  }
}