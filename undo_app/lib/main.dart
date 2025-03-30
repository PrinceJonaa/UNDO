import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart'; // Import google_fonts
import 'input_screen.dart';
import 'settings_screen.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define refined colors based on the brief
    const Color offWhiteBackground = Color(0xFFF8F8F8); // Refined off-white
    const Color softIndigoPurple = Color(0xFF6A5ACD); // SlateBlue as soft indigo/purple

    // Get the base text theme
    final baseTextTheme = Theme.of(context).textTheme;
    // Apply Spectral font using google_fonts
    final spectralTextTheme = GoogleFonts.spectralTextTheme(baseTextTheme);

    return MaterialApp(
      title: 'UNDO', // App title
      theme: ThemeData(
        // Apply the Spectral font theme globally
        textTheme: spectralTextTheme,
        primaryTextTheme: spectralTextTheme, // Apply to primary elements too

        colorScheme: ColorScheme.fromSeed(
          seedColor: softIndigoPurple,
          background: offWhiteBackground,
          brightness: Brightness.light, // Ensure light theme for contrast
        ),
        scaffoldBackgroundColor: offWhiteBackground,

        appBarTheme: AppBarTheme(
          backgroundColor: offWhiteBackground,
          foregroundColor: Colors.black87, // Keep contrast
          elevation: 0,
          centerTitle: true,
          // Apply font explicitly to title (optional, theme should handle)
          titleTextStyle: GoogleFonts.spectral(
            textStyle: baseTextTheme.titleLarge?.copyWith(color: Colors.black87),
            fontWeight: FontWeight.w600, // Example weight adjustment
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: softIndigoPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            // Apply font explicitly to button text (optional, theme should handle)
            textStyle: GoogleFonts.spectral(
              textStyle: baseTextTheme.labelLarge?.copyWith(color: Colors.white),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            // Style for disabled button
            disabledBackgroundColor: Colors.grey[350], // Slightly adjusted grey
            disabledForegroundColor: Colors.grey[600],
          ),
        ),
        // Define bottom sheet theme for consistent appearance
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: offWhiteBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
        ),
        // Apply font to general text elements if needed
        // textTheme: spectralTextTheme.copyWith(
        //   bodyMedium: GoogleFonts.spectral(textStyle: baseTextTheme.bodyMedium),
        //   // Apply to other text styles as needed
        // ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// HomeScreen StatefulWidget remains the same
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isButtonEnabled = false;
  static const String _lastSubmissionKey = 'last_submission_timestamp';

  @override
  void initState() {
    super.initState();
    _checkSubmissionTime();
  }

  Future<void> _checkSubmissionTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSubmissionMillis = prefs.getInt(_lastSubmissionKey);

    bool allowed = true;
    if (lastSubmissionMillis != null) {
      final lastSubmissionTime = DateTime.fromMillisecondsSinceEpoch(lastSubmissionMillis);
      final now = DateTime.now();
      if (now.difference(lastSubmissionTime) < const Duration(hours: 24)) {
        allowed = false;
      }
    }

    if (mounted) {
      setState(() {
        _isButtonEnabled = allowed;
      });
    }
  }

  void _refreshButtonState() {
     _checkSubmissionTime();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Title will inherit font from AppBarTheme
        title: const Text('UNDO'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return const SettingsScreen();
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _isButtonEnabled
              ? () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InputScreen()),
                  );
                  _refreshButtonState();
                }
              : null,
          // Text will inherit font from ElevatedButtonTheme
          child: Text(
            _isButtonEnabled ? 'Release a Moment' : 'Come back tomorrow',
          ),
        ),
      ),
    );
  }
}
