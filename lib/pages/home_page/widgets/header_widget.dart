import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:int20h_app/core/router/app_router.dart';
import 'package:int20h_app/pages/home_page/cubit/chat_cubit.dart';
import 'package:rive/rive.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key, required this.isOpen}) : super(key: key);

  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.center,
            child: AspectRatio(
              aspectRatio: 1,
              child: Center(
                child: _Rive(
                  isOpen: isOpen,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(top: 15, right: 12),
              child: GestureDetector(
                onTap: () => context.router.push(HistoryRoute()),
                child: SizedBox(
                  height: 35,
                  width: 35,
                  child: Center(
                    child: Icon(
                      Icons.history,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(
                bottom: 10,
                right: 14,
              ),
              child: _VolumeButton(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Rive extends StatelessWidget {
  const _Rive({Key? key, required this.isOpen}) : super(key: key);

  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.scale(
          scale: 1.5,
          child: Stack(
            children: [
              RiveAnimation.asset(
                'assets/ai-2.riv',
                fit: BoxFit.cover,
              ),
              RiveAnimation.asset(
                'assets/ai-2.riv',
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VolumeButton extends StatelessWidget {
  const _VolumeButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => context.read<ChatCubit>().toggleVolume(),
          child: SizedBox(
            height: 35,
            width: 35,
            child: Center(
              child: Icon(
                state.isVolumeOn
                    ? Icons.volume_up_rounded
                    : Icons.volume_off_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }
}
