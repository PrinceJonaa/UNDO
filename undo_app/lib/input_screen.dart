import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart'; // Import audioplayers
import 'confirmation_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

// Add SingleTickerProviderStateMixin for animation controller
class _InputScreenState extends State<InputScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  static const String _lastSubmissionKey = 'last_submission_timestamp';
  static const String _soundEnabledKey = 'sound_enabled'; // Key for sound preference

  // Animation variables
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Audio player variables
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _soundEnabled = false;
  bool _isProcessingUndo = false; // Flag to prevent double taps

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500), // Adjust duration as needed
      vsync: this,
    );
    // Initialize fade animation (fades out)
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    // Load sound preference
    _loadSoundPreference();
  }

  Future<void> _loadSoundPreference() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _soundEnabled = prefs.getBool(_soundEnabledKey) ?? false;
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose(); // Dispose animation controller
    _audioPlayer.dispose(); // Dispose audio player
    super.dispose();
  }

  Future<void> _handleUndo() async {
    // Prevent multiple simultaneous executions
    if (_isProcessingUndo) return;
    setState(() { _isProcessingUndo = true; });

    // final text = _textController.text; // Keep if needed for logging/analytics later
    // print('Undo tapped. Text was: "$text"'); // Removed print

    // Play sound if enabled
    if (_soundEnabled) {
      try {
        // Assumes you have 'undo_sound.mp3' in 'assets/audio/'
        await _audioPlayer.play(AssetSource('audio/undo_sound.mp3'));
        // print('Played sound effect.'); // Removed print
      } catch (e) {
        print('Error playing sound: $e'); // Keep error print
        // Handle error (e.g., file not found) - maybe log it
      }
    }

    // Start the fade-out animation
    try {
      await _animationController.forward().orCancel;
    } on TickerCanceled {
      // Handle cancellation if the widget is disposed during animation
      // print("Animation cancelled"); // Removed print
       setState(() { _isProcessingUndo = false; });
      return;
    }


    // Save the submission timestamp (after animation)
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastSubmissionKey, DateTime.now().millisecondsSinceEpoch);
      // print('Submission timestamp saved.'); // Removed print
    } catch (e) {
      print('Error saving timestamp: $e'); // Keep error print
    }

    // Clear input field
    _textController.clear();

    // Reset animation before navigating (so it's ready if user comes back quickly)
    _animationController.reset();


    // Check if the widget is still mounted before navigating
    if (!mounted) {
       setState(() { _isProcessingUndo = false; });
       return;
    }

    // Navigate to Confirmation Screen
    Navigator.pushReplacement(
      context,
      // Use PageRouteBuilder for a potentially smoother transition (optional)
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const ConfirmationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Keep the confirmation screen opaque during transition
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 200), // Short fade-in for next screen
      ),
      // MaterialPageRoute(builder: (context) => const ConfirmationScreen()),
    );

     // Reset processing flag (though screen is replaced, good practice)
     if (mounted) {
        setState(() { _isProcessingUndo = false; });
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Let Go'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      // Wrap the body content with FadeTransition
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'What are you ready to let go of?',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Type here...',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                maxLines: null,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                // Disable button while processing
                onPressed: _isProcessingUndo ? null : _handleUndo,
                child: const Text('Undo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}