import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:int20h_app/core/injection/injection.dart';
import 'package:int20h_app/pages/history_page/cubit/history_cubit.dart';
import 'package:int20h_app/services/books_service/models/book.dart';
import 'package:int20h_app/services/books_service/models/theme_books.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HistoryCubit>()..load(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('History'),
        ),
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget loading() => Center(child: CircularProgressIndicator());

    Widget list(List<ThemeBooks> books) {
      return ListView.separated(
        itemCount: books.length,
        itemBuilder: (_, index) => _ThemeBooks(themeBooks: books[index]),
        separatorBuilder: (_, __) => SizedBox(height: 20),
      );
    }

    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) => state.when(
        initial: loading,
        loading: loading,
        loaded: list,
      ),
    );
  }
}

class _ThemeBooks extends StatelessWidget {
  const _ThemeBooks({
    Key? key,
    required this.themeBooks,
  }) : super(key: key);

  final ThemeBooks themeBooks;

  @override
  Widget build(BuildContext context) {
    Widget book(Book book) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(5),
          child: AspectRatio(
            aspectRatio: 1 / 1.3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          themeBooks.title,
          style: Theme.of(context).textTheme.headline5,
        ),
        Text(
          themeBooks.description,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(
          height: 170,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: themeBooks.books.map(book).toList(),
          ),
        ),
      ],
    );
  }
}
