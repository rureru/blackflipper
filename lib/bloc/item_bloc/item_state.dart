part of 'item_bloc.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object?> get props => [];
}

class ItemInitial extends ItemState {}

class ItemError extends ItemState {
  final String message;

  const ItemError(this.message);

  @override
  List<Object> get props => [message];
}

class ItemLoaded extends ItemState {
  final List<Item> allItems;
  final List<Item> filteredItems;
  final bool hasReachedMax;
  final bool isLoading;

  final String? query;
  final String? itemType;
  final String? tier;
  final String? enchant;
  final String? quality;
  final int? minProfit;
  final double? minProfitPercent;

  const ItemLoaded({
    this.allItems = const [],
    this.filteredItems = const [],
    this.hasReachedMax = false,
    this.isLoading = false,
    this.query,
    this.itemType,
    this.tier,
    this.enchant,
    this.quality,
    this.minProfit,
    this.minProfitPercent,
  });

  ItemLoaded copyWith({
    List<Item>? allItems,
    List<Item>? filteredItems,
    bool? hasReachedMax,
    bool? isLoading,
    String? Function()? query,
    String? Function()? itemType,
    String? Function()? tier,
    String? Function()? enchant,
    String? Function()? quality,
    int? Function()? minProfit,
    double? Function()? minProfitPercent,
  }) {
    return ItemLoaded(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoading: isLoading ?? this.isLoading,
 query: query != null ? query() : this.query,
      itemType: itemType != null ? itemType() : this.itemType, // Use function call
      tier: tier != null ? tier() : this.tier, // Use function call
      enchant: enchant != null ? enchant() : this.enchant, // Use function call
      quality: quality != null ? quality() : this.quality, // Use function call
      minProfit: minProfit != null ? minProfit() : this.minProfit, // Use function call
      minProfitPercent: minProfitPercent != null ? minProfitPercent() : this.minProfitPercent, // Use function call
    );
  }

  @override
  List<Object?> get props => [
        allItems,
        filteredItems,
        hasReachedMax,
        isLoading,
        query,
        itemType,
        tier,
        enchant,
        quality,
        minProfit,
        minProfitPercent,
      ];
}
