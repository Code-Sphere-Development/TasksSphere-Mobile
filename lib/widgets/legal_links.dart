import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';
import '../l10n/app_localizations.dart';

/// Oeffnet eine der rechtlichen Seiten der Weboberflaeche im Browser.
///
/// Die Texte leben nur dort - so gibt es keine zweite Fassung, die
/// auseinanderlaufen koennte.
Future<void> openLegalPage(BuildContext context, Uri url) async {
  final opened = await launchUrl(url, mode: LaunchMode.externalApplication);
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.couldNotOpenLink)),
    );
  }
}

/// Eintraege fuer den Drawer.
class LegalDrawerSection extends StatelessWidget {
  const LegalDrawerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(l10n.legalNotice),
          onTap: () => openLegalPage(context, AppConfig.imprintUrl),
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: Text(l10n.privacyPolicy),
          onTap: () => openLegalPage(context, AppConfig.privacyUrl),
        ),
        ListTile(
          leading: const Icon(Icons.mail_outline),
          title: Text(l10n.contact),
          onTap: () => openLegalPage(context, AppConfig.contactUrl),
        ),
      ],
    );
  }
}

/// Eine kompakte Zeile fuer Seiten ohne Anmeldung, etwa den Login.
class LegalLinksRow extends StatelessWidget {
  const LegalLinksRow({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final style = TextStyle(color: Colors.grey[600], fontSize: 12);

    Widget link(String label, Uri url) => TextButton(
          onPressed: () => openLegalPage(context, url),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(0, 32),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(label, style: style),
        );

    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        link(l10n.legalNotice, AppConfig.imprintUrl),
        link(l10n.privacyPolicy, AppConfig.privacyUrl),
        link(l10n.contact, AppConfig.contactUrl),
      ],
    );
  }
}
