import 'package:flutter/material.dart';
import 'dart:math' as math;

class LeafPainter extends CustomPainter {
  LeafPainter({required this.angle, required this.color});
  final double angle;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    // Draw the stem
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width / 2, size.height / 5);

    // Draw the leaf
    final leafWidth = size.width / 2;
    final leafHeight = size.height / 3;
    final controlPointY = size.height / 3;
    final xControlPoint = size.width / 2 - leafWidth * 0.2;
    final yControlPoint = controlPointY + leafHeight * 0.3;

    path.quadraticBezierTo(
      xControlPoint,
      yControlPoint,
      size.width / 2 - leafWidth / 2,
      controlPointY,
    );
    path.quadraticBezierTo(
      size.width / 2,
      controlPointY - leafHeight,
      size.width / 2 + leafWidth / 2,
      controlPointY,
    );
    path.quadraticBezierTo(
      xControlPoint + leafWidth * 0.2,
      yControlPoint,
      size.width / 2,
      size.height / 5,
    );

    // Rotate the path
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(angle);
    canvas.translate(-size.width / 2, -size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LeafPainter oldDelegate) =>
      angle != oldDelegate.angle || color != oldDelegate.color;
}

class AnimatedLeafLoading extends StatefulWidget {
  const AnimatedLeafLoading({super.key});

  @override
  _AnimatedLeafLoadingState createState() => _AnimatedLeafLoadingState();
}

class _AnimatedLeafLoadingState extends State<AnimatedLeafLoading>
    with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) => CustomPaint(
        painter: LeafPainter(
          angle: _controller!.value * 2 * math.pi,
          color: Colors.green,
        ),
      ),
    );
  }
}
