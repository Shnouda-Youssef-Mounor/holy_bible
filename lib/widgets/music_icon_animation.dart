import 'package:flutter/material.dart';

class MusicIconAnimation extends StatefulWidget {
  final bool isPlaying;

  const MusicIconAnimation({super.key, required this.isPlaying});

  @override
  _MusicIconAnimationState createState() => _MusicIconAnimationState();
}

class _MusicIconAnimationState extends State<MusicIconAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    if (widget.isPlaying) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant MusicIconAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isPlaying && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isPlaying && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(1000),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.library_music, size: 80, color: Colors.purple),
      ),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0), // X-axis shaking
          child: child,
        );
      },
    );
  }
}
