import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:int20h_app/pages/history_page/history_page.dart';
import 'package:int20h_app/pages/home_page/home_page.dart';

part 'app_router.gr.dart';

@singleton
@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: HomePage, initial: true),
    AutoRoute(page: HistoryPage),
  ],
)
class AppRouter extends _$AppRouter {}
