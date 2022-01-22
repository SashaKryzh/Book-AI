import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:int20h_app/services/books_service/models/book.dart';

part 'theme_books.freezed.dart';

@freezed
class ThemeBooks with _$ThemeBooks {
  factory ThemeBooks({
    required String title,
    required String description,
    required List<Book> books,
  }) = _ThemeBooks;
}
