import 'package:flutter/material.dart';

class SliderMenu extends StatefulWidget {
  const SliderMenu({
    Key? key,
    required this.toggleDrawer,
    required this.isOpen,
  }) : super(key: key);

  final bool isOpen;
  final VoidCallback toggleDrawer;

  @override
  State<SliderMenu> createState() => _SliderMenuState();
}

class _SliderMenuState extends State<SliderMenu> with TickerProviderStateMixin {
  late final AnimationController animation;
  bool isOpen = false;

  @override
  void initState() {
    animation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    isOpen = widget.isOpen;
    super.initState();
  }

  @override
  void didUpdateWidget(SliderMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.isOpen ? animation.forward() : animation.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              Text('Book AI'),
              SizedBox(height: 40),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Text('Button 1'),
                    Text('Button 1'),
                    Text('Button 1'),
                    Text('Button 1'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
