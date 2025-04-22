import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // ... other settings items

          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () => launchUrl(
              Uri.parse('https://hortivise.com/privacy-policy'),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Service'),
            onTap: () => launchUrl(
              Uri.parse('https://hortivise.com/terms-of-service'),
            ),
          ),

          // ... other settings items
        ],
      ),
    );
  }
}
