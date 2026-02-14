part of 'item_bloc.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object> get props => [];
}

class FetchItems extends ItemEvent {
  final bool forceRefresh;
  final bool? isBlackMarket;

  const FetchItems({this.forceRefresh = false, this.isBlackMarket});

  @override
  List<Object> get props => [forceRefresh, isBlackMarket ?? false];
}

class SearchItems extends ItemEvent {
  final String query;

  const SearchItems(this.query);

  @override
  List<Object> get props => [query];
}

class FilterItems extends ItemEvent {
  final String? itemType;
  final String? tier;
  final String? enchant;
  final String? quality;
  final int? minProfit;
  final double? minProfitPercent;

  const FilterItems({
    this.itemType,
    this.tier,
    this.enchant,
    this.quality,
    this.minProfit,
    this.minProfitPercent,
  });

  @override
  List<Object> get props => [
        itemType ?? '',
        tier ?? '',
        enchant ?? '',
        quality ?? '',
        minProfit ?? 0,
        minProfitPercent ?? 0.0,
      ];
}

class TabChanged extends ItemEvent {
  final bool isBlackMarket;

  const TabChanged({required this.isBlackMarket});

  @override
  List<Object> get props => [isBlackMarket];
}
