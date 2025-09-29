import 'package:flutter/material.dart';
import 'dart:math' as math;

class LogoLoader extends StatefulWidget {
  final String assetPath; // logo path
  final double size;

  const LogoLoader({
    super.key,
    required this.assetPath,
    this.size = 100,
  });

  @override
  State<LogoLoader> createState() => _LogoLoaderState();
}

class _LogoLoaderState extends State<LogoLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(); // keep flipping
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final angle = _controller.value * 2 * math.pi; // 0 → 360°

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateY(angle), // ✅ Flip left-right
          child: child,
        );
      },
      child: Image.asset(
        widget.assetPath,
        width: widget.size,
        height: widget.size,
      ),
    );
  }
}
