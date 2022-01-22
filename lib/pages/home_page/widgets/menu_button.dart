import 'package:flutter/material.dart';

class MenuButton extends StatefulWidget {
  const MenuButton({
    Key? key,
    this.onTap,
  }) : super(key: key);

  final VoidCallback? onTap;

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> with TickerProviderStateMixin {
  late final AnimationController animationController;
  bool isOpen = false;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      value: 1,
      duration: Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
        isOpen ? animationController.forward() : animationController.reverse();
        isOpen = !isOpen;
      },
      child: Container(
        height: 35,
        width: 35,
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: AnimatedIcon(
            icon: AnimatedIcons.arrow_menu,
            progress: animationController,
          ),
        ),
      ),
    );
  }
}
