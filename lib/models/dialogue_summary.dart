import 'package:int20h_app/models/book_types.dart';
import 'package:int20h_app/models/mood_types.dart';

class DialogueSummary {
  MoodType moodType = MoodType.undefined;
  BookType bookType = BookType.undefined;
  double overallSentiment = 0.5;
  bool isFinalReached = false;
  List<String> bookList = ['Book1', 'Book2', 'Book3'];
}
