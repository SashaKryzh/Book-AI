import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:int20h_app/pages/history_page/cubit/history_cubit.dart';
import 'package:int20h_app/pages/home_page/cubit/chat_cubit.dart';
import 'package:int20h_app/services/books_service/models/book.dart';
import 'package:int20h_app/services/books_service/models/theme_books.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:url_launcher/url_launcher.dart';

class BookBodyWidget extends StatelessWidget {
  const BookBodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget loading() => Center(
          child: JumpingDotsProgressIndicator(
            fontSize: 40,
            dotSpacing: 2,
            milliseconds: 200,
          ),
        );

    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) => state.map(
        initial: (_) => loading(),
        loading: (_) => loading(),
        loaded: (_) => _List(),
      ),
    );
  }
}

class _List extends StatefulWidget {
  const _List({
    Key? key,
  }) : super(key: key);

  @override
  State<_List> createState() => _ListState();
}

class _ListState extends State<_List> {
  bool visible = false;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setState(() {
        visible = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: Duration(milliseconds: 250),
      child: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, s) {
          final state = s as HistoryLoaded;

          if (state.bookTypeSpecified) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  _ThemeBooks(themeBooks: state.themeBooks.first),
                  SizedBox(height: 50),
                  GestureDetector(
                    onTap: () => context.read<ChatCubit>().restart(),
                    child: Text(
                      'Start again',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Color(0xFFE46DCA),
                          ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.only(
              top: 12,
              bottom: 50,
            ),
            itemCount: state.themeBooks.length,
            itemBuilder: (_, index) => _ThemeBooks(
              themeBooks: state.themeBooks[index],
            ),
            separatorBuilder: (_, __) => SizedBox(height: 20),
          );
        },
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
      return Container(
        margin: EdgeInsets.only(right: 5),
        child: GestureDetector(
          onTap: () => launch(book.url),
          child: AspectRatio(
            aspectRatio: 2 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: CachedNetworkImage(
                        imageUrl: book.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: Colors.grey[200],
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: Icon(
                              Icons.error_outline_rounded,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                themeBooks.title,
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        SizedBox(
          height: 170,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 9),
            scrollDirection: Axis.horizontal,
            children: themeBooks.books.map(book).toList(),
          ),
        ),
      ],
    );
  }
}
