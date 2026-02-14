import 'package:BlackFlipper/utils/formatter.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../LanguageProvider.dart';
import '../bloc/item_bloc/item_bloc.dart';
import '../models/item_model.dart';
import '../components/filter.dart';
import '../components/filter2.dart';
import '../components/bottom_nav_bar.dart';
import 'detail.dart';

class MarketWidget extends StatefulWidget {
  const MarketWidget({super.key});

  static String routeName = 'market';
  static String routePath = '/market';

  @override
  State<MarketWidget> createState() => _MarketWidgetState();
}

class _MarketWidgetState extends State<MarketWidget> with TickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
    _tabController.addListener(_onTabChanged);
    context.read<ItemBloc>().add(TabChanged(isBlackMarket: _tabController.index == 0));
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<ItemBloc>().add(const FetchItems());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<ItemBloc>().add(SearchItems(_searchController.text));
    });
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    context.read<ItemBloc>().add(TabChanged(isBlackMarket: _tabController.index == 0));
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(lang.getText('market')),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              final isBlackMarket = _tabController.index == 0;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return isBlackMarket ? const FilterWidget() : const FilterWidget2();
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFF00B054),
                  ),
                  indicatorPadding: const EdgeInsets.all(2.0),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(icon: Icon(Icons.gavel)),
                    Tab(icon: Icon(Icons.store)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMarketList(lang),
                  _buildMarketList(lang),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 1),
    );
  }

  Widget _buildMarketList(LanguageProvider lang) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ItemBloc>().add(TabChanged(isBlackMarket: _tabController.index == 0));
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: lang.getText('search_hint'),
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          BlocBuilder<ItemBloc, ItemState>(
            builder: (context, state) {
              switch (state) {
                case ItemInitial():
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                case ItemError():
                  return SliverToBoxAdapter(
                    child: Center(child: Text(state.message)),
                  );
                case ItemLoaded():
                  if (state.filteredItems.isEmpty && !state.isLoading) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text(lang.getText('no_items_found')),
                      ),
                    );
                  }
                  return _buildSliverList(state.filteredItems, state.hasReachedMax, state.isLoading, lang);
                default:
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSliverList(List<Item> items, bool hasReachedMax, bool isLoading, LanguageProvider lang) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= items.length) {
            return isLoading ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink();
          }
          return _buildMarketItemCard(
            context: context,
            lang: lang,
            item: items[index],
          );
        },
        childCount: items.length + (isLoading ? 1 : 0),
      ),
    );
  }

  Widget _buildMarketItemCard({
    required BuildContext context,
    required LanguageProvider lang,
    required Item item,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(item: item),
          ),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${item.title} - T${item.tier}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildCityPrice(
                        lang.getText('buy_text'), item.buyCity, item.buyPrice, Colors.redAccent),
                  ),
                  Expanded(
                    child: _buildCityPrice(lang.getText('sell_text'), item.sellCity, item.sellPrice,
                        Colors.greenAccent),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: Colors.grey),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.trending_up, color: Colors.greenAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${lang.getText('profit_text')}: ${formatNumber(item.profit)} (${item.profitMargin.toStringAsFixed(2)}%)',
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCityPrice(
      String label, String city, int price, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          softWrap: true,
        ),
        const SizedBox(height: 4),
        Text(
          city,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          softWrap: true,
        ),
        const SizedBox(height: 4),
        Text(
          '${formatNumber(price)} Silver',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
          softWrap: true,
        ),
      ],
    );
  }
}