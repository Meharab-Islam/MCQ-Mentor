import 'dart:async';
import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration speed;
  final bool loop;
  final Duration fadeDuration;
  final Duration restartDelay;

  const TypewriterText({
    Key? key,
    required this.text,
    required this.style,
    this.speed = const Duration(milliseconds: 100),
    this.loop = false,
    this.fadeDuration = const Duration(milliseconds: 150),
    this.restartDelay = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  String displayedText = "";
  int _currentIndex = 0;
  Timer? _timer;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(widget.speed, (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      if (_currentIndex < widget.text.length) {
        if (mounted) {
          setState(() {
            displayedText += widget.text[_currentIndex];
            _currentIndex++;
          });
        }
      } else {
        // ✅ finished typing
        timer.cancel();
        if (widget.loop && !_isDisposed) {
          Future.delayed(widget.restartDelay, () async {
            if (!_isDisposed && mounted) {
              await _fadeOutText();
              if (!_isDisposed && mounted) {
                setState(() {
                  displayedText = "";
                  _currentIndex = 0;
                });
                _startTyping(); // restart safely
              }
            }
          });
        }
      }
    });
  }

  Future<void> _fadeOutText() async {
    for (int i = displayedText.length; i >= 0; i--) {
      await Future.delayed(const Duration(milliseconds: 5));
      if (_isDisposed || !mounted) return; // ✅ stop if disposed
      setState(() {
        displayedText = displayedText.substring(0, i);
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: widget.fadeDuration,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: Text(
            displayedText,
            key: ValueKey(displayedText),
            style: widget.style,
          ),
        ),
        // Optional blinking cursor
        AnimatedOpacity(
          opacity: (_currentIndex % 2 == 0) ? 1 : 0,
          duration: const Duration(milliseconds: 500),
          child: Text("|", style: widget.style),
        ),
      ],
    );
  }
}
