import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:int20h_app/core/router/app_router.dart';
import 'package:rive/rive.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

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
                child: _Rive(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.all(12),
              child: IconButton(
                onPressed: () => context.router.push(HistoryRoute()),
                icon: Icon(
                  Icons.history,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Rive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.5,
      child: RiveAnimation.asset(
        'assets/ai-2.riv',
        fit: BoxFit.cover,
      ),
    );
  }
}
