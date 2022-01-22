import 'package:int20h_app/models/book_types.dart';
import 'package:int20h_app/models/mood_types.dart';

class DialogueSummary {
  MoodType? moodType;
  BookType? bookType;
  double overallSentiment = 0.5;
  List<String> bookList = ['Book1', 'Book2', 'Book3'];
}
