import 'package:flutter/material.dart';
//import 'package:get/get.dart';

class CircularAnimationWidget extends StatefulWidget {
  final Widget child;
  const CircularAnimationWidget({Key? key, required this.child})
      : super(key: key);

  @override
  State<CircularAnimationWidget> createState() =>
      _CircularAnimationWidgetState();
}

class _CircularAnimationWidgetState extends State<CircularAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000));
    controller.forward();
    controller.repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(controller),
        child: widget.child);
  }
}
