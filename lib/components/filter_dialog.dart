import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../LanguageProvider.dart';
import '../bloc/item_bloc/item_bloc.dart';
import '../utils/responsive_size.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? itemType;
  String? tier;
  String? enchant;
  String? quality;
  final TextEditingController minProfitController = TextEditingController();
  final TextEditingController minProfitPercentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final itemState = context.read<ItemBloc>().state;
    if (itemState is ItemLoaded) {
      setState(() {
        itemType = itemState.itemType;
        tier = itemState.tier;
        enchant = itemState.enchant;
        quality = itemState.quality;
        if (itemState.minProfit != null) {
          minProfitController.text = itemState.minProfit.toString();
        }
        if (itemState.minProfitPercent != null) {
          minProfitPercentController.text = itemState.minProfitPercent.toString();
        }
      });
    }
  }

  @override
  void dispose() {
    minProfitController.dispose();
    minProfitPercentController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      itemType = null;
      tier = null;
      enchant = null;
      quality = null;
      minProfitController.clear();
      minProfitPercentController.clear();
    });
    context.read<ItemBloc>().add(const FilterItems(
          itemType: null,
          tier: null,
          enchant: null,
          quality: null,
          minProfit: null,
          minProfitPercent: null,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context, listen: true);
    return Dialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FaIcon(FontAwesomeIcons.filter, color: const Color(0xFF00B054), size: responsiveSize(context, 20, min: 18, max: 24)),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Text(
                      lang.getText('filter_title'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsiveSize(context, 18, min: 16, max: 22),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildChoiceChipGroup(context, lang.getText('tier'), tier,
                  ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8'], (val) => setState(() => tier = val)),
              const SizedBox(height: 16),
              _buildChoiceChipGroup(context, lang.getText('enchant'), enchant,
                  ['EN', 'E1', 'E2', 'E3', 'E4'], (val) => setState(() => enchant = val)),
              const SizedBox(height: 16),
              _buildChoiceChipGroup(
                  context,
                  lang.getText('quality'),
                  quality,
                  [
                    lang.getText('normal'),
                    lang.getText('medium'),
                    lang.getText('good'),
                    lang.getText('very_good'),
                    lang.getText('excellent'),
                  ],
                  (val) => setState(() => quality = val)),
              const SizedBox(height: 24),
              _buildTextField(context, lang.getText('min_profit'), minProfitController),
              const SizedBox(height: 16),
              _buildTextField(context, lang.getText('min_profit_percent'), minProfitPercentController),
              const SizedBox(height: 32),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16.0,
                runSpacing: 16.0,
                children: [
                  TextButton(
                    onPressed: _resetFilters,
                    child: Text(
                      lang.getText('reset'),
                      style: TextStyle(color: Colors.white70, fontSize: responsiveSize(context, 14, min: 12, max: 16)),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          lang.getText('cancel'),
                          style: TextStyle(color: Colors.white70, fontSize: responsiveSize(context, 14, min: 12, max: 16)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          final minProfit = int.tryParse(minProfitController.text);
                          final minProfitPercent = double.tryParse(minProfitPercentController.text);
                          context.read<ItemBloc>().add(FilterItems(
                                itemType: itemType,
                                tier: tier,
                                enchant: enchant,
                                quality: quality,
                                minProfit: minProfit,
                                minProfitPercent: minProfitPercent,
                              ));
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B054),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: responsiveSize(context, 20, min: 16, max: 24), vertical: responsiveSize(context, 10, min: 8, max: 12)),
                        ),
                        child: Text(
                          lang.getText('save'),
                          style: TextStyle(fontSize: responsiveSize(context, 14, min: 12, max: 16), color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceChipGroup(
    BuildContext context,
    String label,
    String? selectedValue,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: responsiveSize(context, 16, min: 14, max: 18),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: items.map((item) {
            final isSelected = selectedValue == item;
            return ChoiceChip(
              label: Text(item),
              selected: isSelected,
              onSelected: (selected) {
                onChanged(selected ? item : null);
              },
              backgroundColor: Colors.grey[800],
              selectedColor: const Color(0xFF00B054),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected ? const Color(0xFF00B054) : Colors.grey[700]!,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTextField(BuildContext context, String label, TextEditingController controller, {IconData? icon}) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.white, fontSize: responsiveSize(context, 14, min: 12, max: 16)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70, fontSize: responsiveSize(context, 14, min: 12, max: 16)),
        filled: true,
        fillColor: Colors.grey[850],
        prefixIcon: icon != null ? Icon(icon, color: Colors.white70, size: 16) : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00B054)),
        ),
      ),
    );
  }
}
