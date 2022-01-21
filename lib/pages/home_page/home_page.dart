import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:int20h_app/pages/home_page/widgets/chat_widget.dart';
import 'package:int20h_app/pages/home_page/widgets/header_widget.dart';
import 'package:int20h_app/pages/home_page/widgets/menu_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final key = GlobalKey<SliderMenuContainerState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            SliderMenuContainer(
              key: key,
              sliderMenu: _SliderMenu(toggleDrawer: toggle),
              sliderMain: _SliderMain(toggleDrawer: toggle),
              hasAppBar: false,
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: MenuButton(onTap: toggle),
              ),
            ),
          ],
        ),
      );

  void toggle() {
    key.currentState!.toggle();
  }
}

class _SliderMenu extends StatelessWidget {
  const _SliderMenu({Key? key, required this.toggleDrawer}) : super(key: key);

  final VoidCallback toggleDrawer;

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.green,
      );
}

class _SliderMain extends StatelessWidget {
  const _SliderMain({Key? key, required this.toggleDrawer}) : super(key: key);

  final VoidCallback toggleDrawer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 1,
          child: HeaderWidget(),
        ),
        Expanded(
          flex: 3,
          child: ChatWidget(),
        ),
      ],
    );
  }
}
