import 'package:injectable/injectable.dart';
import 'package:int20h_app/services/books_service/models/book.dart';
import 'package:int20h_app/services/books_service/models/theme_books.dart';
import 'package:books_finder/books_finder.dart' as g;

@lazySingleton
class BooksService {
  Future<ThemeBooks> getBooksOnTheme(dynamic theme) async {
    final books = await g.queryBooks(
      'twilight',
      maxResults: 6,
      printType: g.PrintType.books,
      orderBy: g.OrderBy.relevance,
      reschemeImageLinks: true,
    );
    var visualBooks = books
        .map((b) => Book(
              title: b.info.title,
              description: '',
              url: b.selfLink.toString(),
              imageUrl: b.info.imageLinks.entries.first.value.toString(),
            ))
        .toList();

    return ThemeBooks(
      title: 'Default',
      description: 'Description of theme',
      books: visualBooks,
    );
  }

  Future<List<ThemeBooks>> getThemes() async {
    return [
      await getBooksOnTheme(1),
      await getBooksOnTheme(1),
      await getBooksOnTheme(1),
    ];
  }
}
