import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:int20h_app/constants.dart';
import 'package:int20h_app/core/injection/injection.dart';
import 'package:int20h_app/pages/home_page/cubit/chat_cubit.dart';

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
                child: _MenuButton(onTap: toggle),
              ),
            ),
          ],
        ),
      );

  void toggle() {
    key.currentState!.toggle();
  }
}

class _MenuButton extends StatefulWidget {
  const _MenuButton({
    Key? key,
    this.onTap,
  }) : super(key: key);

  final VoidCallback? onTap;

  @override
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton>
    with TickerProviderStateMixin {
  late final AnimationController animationController;
  bool isOpen = false;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
        if (isOpen) {
          animationController.reverse();
        } else {
          animationController.forward();
        }
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
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
            ),
          ],
        ),
        child: Center(
          child: AnimatedIcon(
            icon: AnimatedIcons.close_menu,
            progress: animationController,
          ),
        ),
      ),
    );
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

class _SliderMain extends StatefulWidget {
  const _SliderMain({Key? key, required this.toggleDrawer}) : super(key: key);

  final VoidCallback toggleDrawer;

  @override
  State<_SliderMain> createState() => _SliderMainState();
}

class _SliderMainState extends State<_SliderMain> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Container(color: Colors.blue),
          flex: 1,
        ),
        Expanded(
          flex: 3,
          child: BlocProvider(
            create: (_) => getIt<ChatCubit>()..loadMessages(),
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return Chat(
                  user: myUser,
                  onAttachmentPressed: () {},
                  onMessageTap: (_, __) {},
                  onPreviewDataFetched: (_, __) {},
                  onSendPressed: (text) =>
                      context.read<ChatCubit>().sendMessage(text.text),
                  messages: state.messages,
                  disableImageGallery: true,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
