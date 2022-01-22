import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:int20h_app/core/injection/injection.dart';
import 'package:int20h_app/pages/home_page/cubit/chat_cubit.dart';
import 'package:int20h_app/pages/home_page/widgets/chat_widget.dart';
import 'package:int20h_app/pages/home_page/widgets/header_widget.dart';
import 'package:int20h_app/pages/home_page/widgets/menu_button.dart';
import 'package:int20h_app/pages/home_page/widgets/menu_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final key = GlobalKey<SliderMenuContainerState>();

  bool isOpen = false;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt<ChatCubit>()..loadMessages(),
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFF7051).withOpacity(0.5),
                  Color(0xFFFE27CF).withOpacity(0.7),
                ],
                stops: [0.65, 1],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
            child: Stack(
              children: [
                SliderMenuContainer(
                  key: key,
                  sliderMenu: SliderMenu(
                    toggleDrawer: toggle,
                    isOpen: isOpen,
                  ),
                  sliderMain: _SliderMain(toggleDrawer: toggle),
                  appBarColor: Colors.transparent,
                  hasAppBar: false,
                  isDraggable: false,
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: MenuButton(onTap: toggle),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  void toggle() {
    key.currentState!.toggle();
    setState(() {
      isOpen = !isOpen;
    });
  }
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
