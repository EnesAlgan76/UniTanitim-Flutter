

import 'package:flutter/material.dart';

class EnesShowUpText extends StatefulWidget {
  final String text;

  EnesShowUpText({required this.text});

  @override
  _EnesShowUpTextState createState() => _EnesShowUpTextState();
}

class _EnesShowUpTextState extends State<EnesShowUpText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _translateAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _translateAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
          offset: Offset(0, _translateAnimation.value),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Text(widget.text,
              style: TextStyle(fontSize: 16,color: Colors.black87,  decoration: TextDecoration.none),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
