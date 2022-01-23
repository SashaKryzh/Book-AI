import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:int20h_app/core/injection/injection.dart';
import 'package:int20h_app/models/book_types.dart';
import 'package:int20h_app/pages/history_page/cubit/history_cubit.dart';
import 'package:int20h_app/pages/history_page/widgets/book_body_widget.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HistoryCubit>()..load(BookType.values),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Books for you'),
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
        ),
        body: BookBodyWidget(),
      ),
    );
  }
}
