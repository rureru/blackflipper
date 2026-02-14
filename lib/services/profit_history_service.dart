import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfitHistoryService {
  static const _maxHistoryLength = 5;

  Future<void> saveProfit(String itemId, int profit) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'profit_history_$itemId';

    final history = await getProfitHistory(itemId);
    history.add(profit);

    if (history.length > _maxHistoryLength) {
      history.removeAt(0);
    }

    await prefs.setString(key, json.encode(history));
  }

  Future<List<int>> getProfitHistory(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'profit_history_$itemId';

    final historyString = prefs.getString(key);
    if (historyString != null) {
      return (json.decode(historyString) as List<dynamic>).cast<int>();
    }

    return [];
  }
}
