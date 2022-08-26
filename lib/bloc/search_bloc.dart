import 'package:flutter/foundation.dart' show immutable;
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:testing_rx_dart/bloc/api.dart';
import 'package:testing_rx_dart/bloc/search_result.dart';

@immutable
class SearchBloc {
  final Sink<String> search;
  final Stream<SearchResult?> results;

  void dispose() {
    search.close();
  }

  factory SearchBloc({required Api api}) {
    final textChanges = BehaviorSubject<String>();
    final results = textChanges
        .distinct()
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap<SearchResult?>((String searchTerm) {
      if (searchTerm.isEmpty) {
        return Stream<SearchResult?>.value(null);
      } else {
        final foo = Rx.fromCallable(() => api.search(searchTerm))
            .delay(const Duration(seconds: 1))
            .map((result) => result.isEmpty
                ? const SearchResultNoResult()
                : SearchResultWithResults(result))
            .startWith(const SearchResultLoading())
            .onErrorReturnWith((error, _) => SearchResultHasError(error));
        return foo;
      }
    });
    return SearchBloc._(search: textChanges.sink, results: results);
  }
  SearchBloc._({required this.search, required this.results});
}
