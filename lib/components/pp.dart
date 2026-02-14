import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../LanguageProvider.dart';
import 'legal_document.dart';

class PpWidget extends StatelessWidget {
  const PpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    return LegalDocumentWidget(
      title: lang.getText('privacy_policy'),
      content: lang.getText('privacy_policy_content'),
      icon: FontAwesomeIcons.shield,
    );
  }
}