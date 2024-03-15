import 'package:flutter/material.dart';
import 'package:hobbio/login_screen.dart';
import 'package:hobbio/user_registration.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

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
              animation: _animation,
              builder: (BuildContext context, Widget? child) {
                return CustomPaint(
                  painter: CircleBackgroundPainter(
                    animationValue: _animation.value,
                  ),
                );
              },
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _animation,
              child: const Text(
                'Hobbio',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
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
      ..color = Colors.blue.withOpacity(0.2) // Circle color
      ..style = PaintingStyle.fill;

    final cornerOffsets = [
      const Offset(0, 0), // Top-left corner
      Offset(size.width, 0), // Top-right corner
      Offset(size.width, size.height), // Bottom-right corner
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