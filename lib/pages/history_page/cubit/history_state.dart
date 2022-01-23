part of 'history_cubit.dart';

@freezed
class HistoryState with _$HistoryState {
  const factory HistoryState.initial() = _Initial;

  const factory HistoryState.loading() = _Loading;

  const factory HistoryState.loaded({
    @Default([]) List<ThemeBooks> themeBooks,
    @Default(false) bool bookTypeSpecified,
  }) = HistoryLoaded;
}
