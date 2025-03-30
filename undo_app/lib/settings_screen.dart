import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
// TODO: Import a package like url_launcher to open links if needed
// import 'package:url_launcher/url_launcher.dart';

// Convert to StatefulWidget
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = false; // Default sound off
  static const String _soundEnabledKey = 'sound_enabled';

  @override
  void initState() {
    super.initState();
    _loadSoundPreference();
  }

  // Load the sound preference from SharedPreferences
  Future<void> _loadSoundPreference() async {
    final prefs = await SharedPreferences.getInstance();
    // Get the value, defaulting to false if not found
    final bool isEnabled = prefs.getBool(_soundEnabledKey) ?? false;
    if (mounted) {
      setState(() {
        _soundEnabled = isEnabled;
      });
    }
  }

  // Save the sound preference to SharedPreferences
  Future<void> _setSoundPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, value);
    if (mounted) {
      setState(() {
        _soundEnabled = value;
      });
    }
  }

  // Helper function to launch URLs (requires url_launcher package)
  // Future<void> _launchURL(String urlString) async {
  //   final Uri url = Uri.parse(urlString);
  //   if (!await launchUrl(url)) {
  //     // print('Could not launch $urlString'); // Keep potential error print if uncommented
  //     // Optionally show an error message to the user
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Using ListView for potential future expansion
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        shrinkWrap: true, // Make ListView take minimum height
        children: <Widget>[
          // Optional: Add a title or handle to the sheet
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(),
          // Sound Toggle
          SwitchListTile(
            title: const Text('Enable Sound Effect'),
            secondary: Icon(_soundEnabled ? Icons.volume_up_outlined : Icons.volume_off_outlined),
            value: _soundEnabled,
            onChanged: _setSoundPreference, // Call save method on change
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About / What This Is'),
            onTap: () {
              // TODO: Show an AlertDialog or navigate to a dedicated About page
              // print('About tapped'); // Removed print
              Navigator.pop(context); // Close the bottom sheet
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About UNDO'),
                  content: const Text(
                      'UNDO is a minimalist app for symbolic release. '
                      'Let go of a thought or memory by typing it and pressing Undo. '
                      'Nothing is saved. Use it once a day as a mindful ritual.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {
              // TODO: Replace with actual URL and uncomment url_launcher logic
              // print('Privacy Policy tapped'); // Removed print
              // _launchURL('YOUR_PRIVACY_POLICY_URL_HERE');
              Navigator.pop(context); // Close the bottom sheet
              // Show placeholder dialog for now
               showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Privacy Policy'),
                  content: const Text('We do not collect or store any personal data. All input is ephemeral and vanishes.'),
                  actions: [ TextButton( onPressed: () => Navigator.pop(context), child: const Text('OK'),),],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel_outlined),
            title: const Text('Terms of Use'),
            onTap: () {
              // TODO: Replace with actual URL and uncomment url_launcher logic
              // print('Terms of Use tapped'); // Removed print
              // _launchURL('YOUR_TERMS_OF_USE_URL_HERE');
               Navigator.pop(context); // Close the bottom sheet
               // Show placeholder dialog for now
               showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Terms of Use'),
                  content: const Text('Use this app responsibly as a tool for mindfulness. No guarantees are made.'),
                  actions: [ TextButton( onPressed: () => Navigator.pop(context), child: const Text('OK'),),],
                ),
              );
            },
          ),
          // Optional: Donate Link
          // ListTile(
          //   leading: const Icon(Icons.favorite_border),
          //   title: const Text('Support UNDO'),
          //   onTap: () {
          //     // TODO: Replace with your Stripe link and uncomment url_launcher
          //     // print('Donate tapped'); // Removed print
          //     // _launchURL('YOUR_STRIPE_DONATION_LINK_HERE');
          //      Navigator.pop(context);
          //   },
          // ),
        ],
      ),
    );
  }
}