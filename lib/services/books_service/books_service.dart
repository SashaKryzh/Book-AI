import 'package:injectable/injectable.dart';
import 'package:int20h_app/models/book_types.dart';
import 'package:int20h_app/services/books_service/models/book.dart';
import 'package:int20h_app/services/books_service/models/theme_books.dart';
import 'package:books_finder/books_finder.dart' as google_books;

@lazySingleton
class BooksService {
  final Map<BookType, String> _bookSearchRequests = Map.fromEntries([
    MapEntry(BookType.procrastination, "Procrastination"),
    MapEntry(BookType.selfCare, "Self care"),
    MapEntry(BookType.anxiety, "Anxiety"),
    MapEntry(BookType.burnout, "Burnout"),
    MapEntry(BookType.communicationProblems, "Communication Problems"),
    MapEntry(BookType.workLifeBalance, "Work Life Balance"),
  ]);

  Future<ThemeBooks> getBooksOnTheme(BookType theme) async {
    final searchTitle = _bookSearchRequests[theme] ?? "Problem Solving";
    final books = await google_books.queryBooks(
      searchTitle,
      maxResults: 6,
      printType: google_books.PrintType.books,
      orderBy: google_books.OrderBy.relevance,
      reschemeImageLinks: true,
    );
    var visualBooks = books
        .map((b) => Book(
              title: b.info.title,
              description: b.info.description,
              url: "http://books.google.com.ua/books?id=" + b.id,
              imageUrl: b.info.imageLinks['thumbnail']?.toString() ?? '',
            ))
        .toList();

    return ThemeBooks(
      title: searchTitle,
      description: 'Description of theme',
      books: visualBooks,
    );
  }

  Future<List<ThemeBooks>> getThemes(List<BookType> bookTypes) async {
    return Stream.fromIterable(bookTypes)
        .asyncMap((event) => getBooksOnTheme(event))
        .toList();
  }
}
