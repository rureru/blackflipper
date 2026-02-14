import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../data/repositories/item_repository.dart';
import '../../models/item_model.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepository itemRepository;
  bool? _isBlackMarket;

  ItemBloc({required this.itemRepository}) : super(ItemInitial()) {
    on<FetchItems>(_onFetchItems, transformer: droppable());
    on<SearchItems>(_onSearchItems);
    on<FilterItems>(_onFilterItems);
    on<TabChanged>(_onTabChanged);
  }

  List<Item> _applyFilters(ItemLoaded currentState) {
    return currentState.allItems.where((item) {
      // Search Query Filter
      if (currentState.query != null && currentState.query!.isNotEmpty) {
        if (!item.title.toLowerCase().contains(currentState.query!.toLowerCase())) {
          return false;
        }
      }

      // Tier Filter
      if (currentState.tier != null && currentState.tier!.length > 1) {
        if (item.tier.toString() != currentState.tier!.substring(1)) return false;
      }

      // Enchant Filter
      if (currentState.enchant != null && currentState.enchant!.length > 1) {
        if (item.enchantment.toString() != currentState.enchant!.substring(1)) return false;
      }

      // Quality Filter
      if (currentState.quality != null) {
        if (item.quality.toString() != currentState.quality) return false;
      }

      // Min Profit Filter
      if (currentState.minProfit != null) {
        if (item.profit < currentState.minProfit!) return false;
      }

      // Min Profit Percent Filter
      if (currentState.minProfitPercent != null) {
        if (item.profitMargin < currentState.minProfitPercent!) return false;
      }

      // Item Type Filter is complex, assuming item.uniqueName contains type info
      // Example: 'T4_ARMOR_PLATE_SET1'
      // if (currentState.itemType != null && currentState.itemType!.isNotEmpty) {
      //   if (!item.uniqueName.toLowerCase().contains(currentState.itemType!.toLowerCase())) return false;
      // }

      return true;
    }).toList();
  }

  Future<void> _onFetchItems(FetchItems event, Emitter<ItemState> emit) async {
    final currentState = state is ItemLoaded ? state as ItemLoaded : const ItemLoaded();

    if (currentState.hasReachedMax && !event.forceRefresh) return;

    try {
      if (event.forceRefresh) {
        emit(const ItemLoaded(isLoading: true));
        final items = await itemRepository.fetchItems(page: 1, isBlackMarket: _isBlackMarket, forceRefresh: true);
        final filtered = _applyFilters(ItemLoaded(allItems: items));
        emit(ItemLoaded(allItems: items, filteredItems: filtered, hasReachedMax: items.isEmpty));
      } else {
        emit(currentState.copyWith(isLoading: true));
        final nextPage = (currentState.allItems.length / 20).ceil() + 1;
        final newItems = await itemRepository.fetchItems(page: nextPage, isBlackMarket: _isBlackMarket);

        if (newItems.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true, isLoading: false));
        } else {
          final updatedAllItems = List.of(currentState.allItems)..addAll(newItems);
          final filtered = _applyFilters(currentState.copyWith(allItems: updatedAllItems));
          emit(currentState.copyWith(
            allItems: updatedAllItems,
            filteredItems: filtered,
            isLoading: false,
          ));
        }
      }
    } catch (e) {
      emit(ItemError(e.toString()));
    }
  }

  void _onSearchItems(SearchItems event, Emitter<ItemState> emit) {
    if (state is ItemLoaded) {
      final currentState = state as ItemLoaded;
      final newState = currentState.copyWith(query: () => event.query);
      final filtered = _applyFilters(newState);
      emit(newState.copyWith(filteredItems: filtered));
    }
  }

  void _onFilterItems(FilterItems event, Emitter<ItemState> emit) {
    if (state is ItemLoaded) {
      final currentState = state as ItemLoaded;
      final newState = currentState.copyWith(
        itemType: () => event.itemType,
        tier: () => event.tier,
        enchant: () => event.enchant,
        quality: () => event.quality,
        minProfit: () => event.minProfit,
        minProfitPercent: () => event.minProfitPercent,
      );
      final filtered = _applyFilters(newState);
      emit(newState.copyWith(filteredItems: filtered));
    }
  }

  Future<void> _onTabChanged(TabChanged event, Emitter<ItemState> emit) async {
    _isBlackMarket = event.isBlackMarket;
    add(FetchItems(forceRefresh: true, isBlackMarket: _isBlackMarket));
  }
}