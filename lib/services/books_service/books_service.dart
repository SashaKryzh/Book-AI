import 'package:injectable/injectable.dart';
import 'package:int20h_app/services/books_service/models/book.dart';
import 'package:int20h_app/services/books_service/models/theme_books.dart';

@lazySingleton
class BooksService {
  Future<ThemeBooks> getBooksOnTheme(dynamic theme) async {
    return ThemeBooks(
      title: 'Default',
      description: 'Description of theme',
      books: [
        Book(
          title: 'Book 1',
          description: 'Book 1 description',
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/Books_HD_%288314929977%29.jpg/1280px-Books_HD_%288314929977%29.jpg',
          url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        ),
        Book(
          title: 'Book 2',
          description: 'Book 1 description',
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/Books_HD_%288314929977%29.jpg/1280px-Books_HD_%288314929977%29.jpg',
          url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        ),
        Book(
          title: 'Book 3',
          description: 'Book 1 description',
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/Books_HD_%288314929977%29.jpg/1280px-Books_HD_%288314929977%29.jpg',
          url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        ),
      ],
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
