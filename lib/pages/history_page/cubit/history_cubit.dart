import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:int20h_app/services/books_service/books_service.dart';
import 'package:int20h_app/services/books_service/models/theme_books.dart';

part 'history_state.dart';
part 'history_cubit.freezed.dart';

@injectable
class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._booksService) : super(HistoryState.initial());

  BooksService _booksService;
}
