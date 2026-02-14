import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../utils/responsive_size.dart';
import '../LanguageProvider.dart';

class LegalDocumentWidget extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const LegalDocumentWidget({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const primaryColor = Color(0xFF00B054);
    const cardBorderRadius = 20.0;
    const defaultPadding = 24.0;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cardBorderRadius),
          gradient: LinearGradient(
            colors: [Colors.grey[900]!, Colors.grey[850]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, icon, title, primaryColor),
              const SizedBox(height: 16),
              const Divider(color: Colors.white24),
              const SizedBox(height: 16),
              _buildContent(context, content),
              const SizedBox(height: 24),
              _buildDoneButton(context, primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, IconData icon, String title, Color iconColor) {
    return Row(
      children: [
        FaIcon(
          icon,
          color: iconColor,
          size: responsiveSize(context, 20, min: 18, max: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: responsiveSize(context, 18, min: 16, max: 22),
              fontWeight: FontWeight.bold,
            ),
            softWrap: true,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, String content) {
    return Expanded(
      flex: 5,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black,
              Colors.black,
              Colors.transparent,
            ],
            stops: [0.0, 0.05, 0.95, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              content,
              style: TextStyle(
                color: Colors.white70,
                fontSize: responsiveSize(context, 14, min: 12, max: 16),
                height: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoneButton(BuildContext context, Color backgroundColor) {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: responsiveSize(context, 20, min: 16, max: 24),
            vertical: responsiveSize(context, 10, min: 8, max: 12),
          ),
        ),
        child: Text(
          Provider.of<LanguageProvider>(context, listen: false).getText('done'),
          style: TextStyle(
            fontSize: responsiveSize(context, 14, min: 12, max: 16),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}