import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:int20h_app/core/injection/injection.dart';
import 'package:int20h_app/models/book_types.dart';
import 'package:int20h_app/pages/history_page/cubit/history_cubit.dart';
import 'package:int20h_app/pages/history_page/widgets/book_body_widget.dart';

class BookPopupWidget extends StatelessWidget {
  const BookPopupWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      child: BlocProvider(
        create: (_) => getIt<HistoryCubit>()..load([BookType.burnout]),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Books for you'),
            elevation: 0,
            foregroundColor: Colors.black,
            backgroundColor: Colors.transparent,
          ),
          body: BookBodyWidget(),
        ),
      ),
    );
  }
}
