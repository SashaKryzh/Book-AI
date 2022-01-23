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
      child: Stack(children: [
        RiveAnimation.asset(
          'assets/ai-2.riv',
          fit: BoxFit.cover,
        ),
        RiveAnimation.asset(
          'assets/ai-2.riv',
          fit: BoxFit.cover,
        ),
      ]),
    );
  }
}
