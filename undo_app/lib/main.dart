import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'input_screen.dart'; // Import the InputScreen
import 'settings_screen.dart'; // Import the SettingsScreen
import 'dart:async'; // Import for Timer (if needed later for refresh)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define colors based on the brief
    const Color offWhiteBackground = Color(0xFFFAFAFA); // Example off-white
    const Color softIndigoPurple = Colors.deepPurple; // Placeholder, refine later

    return MaterialApp(
      title: 'UNDO', // App title
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: softIndigoPurple,
          background: offWhiteBackground,
        ),
        scaffoldBackgroundColor: offWhiteBackground,
        // TODO: Add Serif font (e.g., Spectral) - requires adding font file to pubspec.yaml
        // fontFamily: 'Spectral',
        appBarTheme: const AppBarTheme(
          backgroundColor: offWhiteBackground, // Keep AppBar background consistent
          foregroundColor: Colors.black87, // Adjust text/icon color for contrast
          elevation: 0, // Minimalist: remove shadow
          centerTitle: true, // Center the title
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: softIndigoPurple, // Button background
            foregroundColor: Colors.white, // Button text color
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(
              fontSize: 16,
              // fontFamily: 'Spectral', // Apply font here too
            ),
            // Style for disabled button
            disabledBackgroundColor: Colors.grey[300],
            disabledForegroundColor: Colors.grey[500],
          ),
        ),
        // Define bottom sheet theme for consistent appearance
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: offWhiteBackground, // Match background
          shape: RoundedRectangleBorder( // Optional: rounded corners
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(), // Set HomeScreen as the initial route
      debugShowCheckedModeBanner: false, // Hide debug banner
    );
  }
}

// Convert HomeScreen to StatefulWidget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isButtonEnabled = false; // Start as disabled until checked
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
      // Check if less than 24 hours have passed
      if (now.difference(lastSubmissionTime) < const Duration(hours: 24)) {
        allowed = false;
      }
    }

    // Update the state only if the widget is still mounted
    if (mounted) {
      setState(() {
        _isButtonEnabled = allowed;
      });
    }
  }

  // Function to call when navigating back from ConfirmationScreen
  // This ensures the button state is updated immediately after submission
  void _refreshButtonState() {
     _checkSubmissionTime();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UNDO'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              // Show the SettingsScreen in a modal bottom sheet
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
          // Disable button visually and functionally if not allowed
          onPressed: _isButtonEnabled
              ? () async {
                  // Navigate to Input Screen
                  // We wait for the result (popping back) to refresh the state
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InputScreen()),
                  );
                  // Refresh state when returning from Input/Confirmation flow
                  _refreshButtonState();
                }
              : null, // null onPressed disables the button
          child: Text(
            _isButtonEnabled ? 'Release a Moment' : 'Come back tomorrow',
          ),
        ),
      ),
    );
  }
}
