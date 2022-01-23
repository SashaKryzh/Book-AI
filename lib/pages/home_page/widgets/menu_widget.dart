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
    final theme = Theme.of(context);

    return FadeTransition(
      opacity: animation,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              Text(
                'Book AI',
                style: theme.textTheme.headline3!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                ' by Клевер team',
                style: theme.textTheme.bodyText2!.copyWith(color: Colors.white),
              ),
              SizedBox(height: 40),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MenuButton(text: 'Create an account', bold: true),
                    _MenuButton(text: 'Choose your assistant'),
                    SizedBox(height: 20),
                    _MenuButton(text: 'Share with friends'),
                    _MenuButton(text: 'Rate our app'),
                    _MenuButton(text: 'Contact us'),
                    SizedBox(height: 20),
                    _MenuButton(text: 'Delete my data'),
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

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    Key? key,
    required this.text,
    this.onTap,
    this.bold = false,
  }) : super(key: key);

  final String text;
  final VoidCallback? onTap;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.white,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
              ),
        ),
      ),
    );
  }
}
