import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:int20h_app/core/injection/injection.dart';
import 'package:int20h_app/core/router/app_router.dart';
import 'package:int20h_app/utils/simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();
  
  BlocOverrides.runZoned(
    () => runApp(const Int20hApp()),
    blocObserver: SimpleBlocObserver(),
  );
}

class Int20hApp extends StatelessWidget {
  const Int20hApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        minTextAdapt: true,
        builder: () => MaterialApp.router(
          routerDelegate: getIt<AppRouter>().delegate(),
          routeInformationParser: getIt<AppRouter>().defaultRouteParser(),
          title: 'Int20h App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          builder: (context, child) {
            ScreenUtil.setContext(context);

            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            );
          },
        ),
      );
}
