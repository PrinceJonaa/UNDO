import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart'; // Import HomeScreen to navigate back

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start a timer to navigate back after a delay
    _startTimer();
  }

  void _startTimer() {
    // Duration for displaying the confirmation message
    const Duration displayDuration = Duration(seconds: 4);

    _timer = Timer(displayDuration, () {
      // Navigate back to HomeScreen after the timer expires
      // Using pushAndRemoveUntil to clear the navigation stack
      if (mounted) { // Check if the widget is still in the tree
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false, // Remove all previous routes
        );
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer if the widget is disposed before the timer fires
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use GestureDetector to allow tapping to dismiss early (optional)
    return GestureDetector(
      onTap: () {
        _timer?.cancel(); // Cancel timer if tapped
        if (mounted) {
           Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              "Done. But if you remember, it's because you're ready.",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontStyle: FontStyle.italic, // Add a slightly different style
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}