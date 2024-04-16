import 'package:flutter/material.dart';
import 'package:Hobbio/login_screen.dart';
import 'package:Hobbio/user_dashboard.dart';
import 'package:Hobbio/user_registration.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, -0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.white, // Background color
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (BuildContext context, Widget? child) {
                return CustomPaint(
                  painter: CircleBackgroundPainter(
                    animationValue: _fadeAnimation.value,
                  ),
                );
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: const Text(
                      'Hobbio',
                      style: TextStyle(
                        fontFamily: 'Hobbio',
                        fontSize: 66,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 10, 128, 224),
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 5), // Adjust the height between the texts as needed
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Text(
                      'Follow your passion',
                      style: TextStyle(
                        fontFamily: 'Hobbio7',
                        fontSize: 30, // You can adjust the font size as needed
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 32, 99, 181), // Adjust the color according to your design
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CircleBackgroundPainter extends CustomPainter {
  final double animationValue;

  CircleBackgroundPainter({
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 2, 107, 193).withOpacity(0.2) // Circle color
      ..style = PaintingStyle.fill;

    final cornerOffsets = [
      const Offset(20, 20), // Top-left corner
      Offset(size.width - 60, size.height - 60), // Bottom-right corner with increased size
    ];

    final maxRadius = size.longestSide * 0.2; // Max radius for circles

    for (final offset in cornerOffsets) {
      final scaledRadius = maxRadius * animationValue;
      canvas.drawCircle(offset, scaledRadius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
