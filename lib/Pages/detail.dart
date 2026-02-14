import 'package:BlackFlipper/OverlayProvider.dart';
import 'package:BlackFlipper/utils/formatter.dart';
import 'package:BlackFlipper/services/favorites_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../LanguageProvider.dart';
import '../RoleProvider.dart';
import '../models/item_model.dart';
import '../services/profit_history_service.dart';

class DetailPage extends StatefulWidget {
  final Item item;

  const DetailPage({super.key, required this.item});

  static String routeName = 'Detail';
  static String routePath = '/detail';

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ProfitHistoryService _profitHistoryService = ProfitHistoryService();
  final FavoritesService _favoritesService = FavoritesService();
  late Future<List<int>> _profitHistoryFuture;
  late Stream<bool> _isFavoriteStream;

  @override
  void initState() {
    super.initState();
    _profitHistoryFuture = _profitHistoryService.getProfitHistory(widget.item.uniqueName);
    _isFavoriteStream = _favoritesService.isFavorite(widget.item.uniqueName);
  }

  String _getQualityName(int quality) {
    switch (quality) {
      case 1:
        return 'Normal';
      case 2:
        return 'Good';
      case 3:
        return 'Outstanding';
      case 4:
        return 'Excellent';
      case 5:
        return 'Masterpiece';
      default:
        return 'Unknown';
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, LanguageProvider lang, Item item) {
    // final lastUpdatedString = timeago.format(DateTime.fromMillisecondsSinceEpoch(item.timestamp));

    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lang.getText('details'), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildDetailRow('Tier', 'T${item.tier}'),
            _buildDetailRow('Enchantment', item.enchantment > 0 ? '.${item.enchantment}' : 'None'),
            _buildDetailRow('Quality', _getQualityName(item.quality)),
            const Divider(color: Colors.white24),
            _buildDetailRow(lang.getText('buy_text'), '${formatNumber(item.buyPrice)} Silver (${item.buyCity})'),
            _buildDetailRow(lang.getText('sell_text'), '${formatNumber(item.sellPrice)} Silver (${item.sellCity})'),
            _buildDetailRow(lang.getText('profit_text'), '${formatNumber(item.profit)} (${item.profitMargin.toStringAsFixed(2)}%)'),
            // _buildDetailRow(lang.getText('last_updated'), lastUpdatedString),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(BuildContext context, LanguageProvider lang) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lang.getText('profit_history'), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: FutureBuilder<List<int>>(
                future: _profitHistoryFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No profit history found.'));
                  }

                  final profitHistory = snapshot.data!;
                  final spots = <FlSpot>[
                    for (int i = 0; i < profitHistory.length; i++) FlSpot(i.toDouble(), profitHistory[i].toDouble()),
                  ];

                  return LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        getDrawingHorizontalLine: (value) => const FlLine(color: Colors.white10, strokeWidth: 1),
                        getDrawingVerticalLine: (value) => const FlLine(color: Colors.white10, strokeWidth: 1),
                      ),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: const Color(0xFF00B054),
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: const Color(0xFF00B054).withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, LanguageProvider lang) {
    final roleProvider = Provider.of<RoleProvider>(context, listen: true);
    final overlayProvider = Provider.of<OverlayProvider>(context, listen: false);

    if (roleProvider.userRole == UserRole.freemium) {
      return Container(); // Return an empty container for freemium users
    }
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            child: Text(lang.getText('show_on_overlay')),
            onPressed: () {
              overlayProvider.toggleOverlayWithPermission(true, item: widget.item);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StreamBuilder<bool>(
            stream: _isFavoriteStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final isFavorite = snapshot.data ?? false;
              return ElevatedButton(
                child: Text(isFavorite ? lang.getText('remove_from_favorites') : lang.getText('add_to_favorites')),
                onPressed: () {
                  if (isFavorite) {
                    _favoritesService.removeFavorite(widget.item.uniqueName);
                  } else {
                    _favoritesService.addFavorite(widget.item);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFavorite ? Colors.red : const Color(0xFF00B054),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: 217.0,
            pinned: true,
            floating: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.item.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: CachedNetworkImage(
                imageUrl: 'https://render.albiononline.com/v1/item/${widget.item.uniqueName}.png?quality=${widget.item.quality}',
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDetailsCard(context, lang, widget.item),
                  const SizedBox(height: 16),
                  _buildChartCard(context, lang),
                  const SizedBox(height: 16),
                  _buildActionButtons(context, lang),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}