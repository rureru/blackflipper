import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../LanguageProvider.dart';
import 'legal_document.dart';

class TermsWidget extends StatelessWidget {
  const TermsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    return LegalDocumentWidget(
      title: lang.getText('terms_conditions'),
      content: lang.getText('terms_conditions_content'),
      icon: FontAwesomeIcons.fileContract,
    );
  }
}