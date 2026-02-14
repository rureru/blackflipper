import 'dart:core';

class Item {
  final String uniqueName;
  final String title;
  final String buyCity;
  final int buyPrice;
  final String sellCity;
  final int sellPrice;
  final int profit;
  final double profitMargin;
  final int tier;
  final int enchantment;
  final int quality;

  Item({
    required this.uniqueName,
    required this.title,
    required this.buyCity,
    required this.buyPrice,
    required this.sellCity,
    required this.sellPrice,
    required this.profit,
    required this.profitMargin,
    required this.tier,
    required this.enchantment,
    required this.quality,
  });

  static int _parseTier(String uniqueName) {
    final match = RegExp(r'^T(\d)').firstMatch(uniqueName);
    return match != null ? int.tryParse(match.group(1) ?? '') ?? 0 : 0;
  }

  static int _parseEnchantment(String uniqueName) {
    final match = RegExp(r'@(\d)').firstMatch(uniqueName);
    return match != null ? int.tryParse(match.group(1) ?? '') ?? 0 : 0;
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    final uniqueName = json['uniqueName'] as String? ?? '';
    return Item(
      uniqueName: uniqueName,
      title: json['title'] as String? ?? 'Unknown Item',
      buyCity: json['buyCity'] as String? ?? 'Unknown',
      buyPrice: json['buyPrice'] as int? ?? 0,
      sellCity: json['sellCity'] as String? ?? 'Unknown',
      sellPrice: json['sellPrice'] as int? ?? 0,
      profit: json['profit'] as int? ?? 0,
      profitMargin: (json['profitMargin'] as num? ?? 0.0).toDouble(),
      quality: json['quality'] as int? ?? 1,
      tier: _parseTier(uniqueName),
      enchantment: _parseEnchantment(uniqueName),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uniqueName': uniqueName,
      'title': title,
      'buyCity': buyCity,
      'buyPrice': buyPrice,
      'sellCity': sellCity,
      'sellPrice': sellPrice,
      'profit': profit,
      'profitMargin': profitMargin,
      'tier': tier,
      'enchantment': enchantment,
      'quality': quality,
    };
  }
}