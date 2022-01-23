import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:int20h_app/models/book_types.dart';
import 'package:int20h_app/services/books_service/books_service.dart';
import 'package:int20h_app/services/books_service/models/theme_books.dart';

part 'history_state.dart';
part 'history_cubit.freezed.dart';

@injectable
class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._booksService) : super(HistoryState.initial());

  final BooksService _booksService;

  void load(BookType? bookType) async {
    final type = bookType != null ? [bookType] : BookType.values;
    emit(HistoryState.loading());
    final themeBooks = await _booksService.getThemes(type);
    emit(HistoryState.loaded(
      themeBooks: [...themeBooks],
      bookTypeSpecified: bookType != null,
    ));
  }
}
