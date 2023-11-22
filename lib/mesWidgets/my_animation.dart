import 'dart:async';

import 'package:flutter/material.dart';

class MyAnimation extends StatefulWidget {
  int time;
  Widget child;
  MyAnimation({required this.time, required this.child, super.key});

  @override
  State<MyAnimation> createState() => _MyAnimationState();
}

class _MyAnimationState extends State<MyAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    CurvedAnimation curvedAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.linear);
    animation = Tween<Offset>(begin: Offset(0, 5), end: Offset.zero)
        .animate(curvedAnimation);
    Timer(Duration(seconds: widget.time), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: animation,
        child: widget.child,
      ),
    );
  }
}
