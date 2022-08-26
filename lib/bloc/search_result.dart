import 'package:flutter/foundation.dart' show immutable;
import 'package:testing_rx_dart/models/thing.dart';

@immutable
abstract class SearchResult {
  SearchResult();
}

@immutable
class SearchResultLoading implements SearchResult {
  const SearchResultLoading();
}

@immutable
class SearchResultHasError implements SearchResult {
  final Object error;
  const SearchResultHasError(this.error);
}

@immutable
class SearchResultNoResult implements SearchResult {
  const SearchResultNoResult();
}

@immutable
class SearchResultWithResults implements SearchResult {
  final List<Thing> results;
  const SearchResultWithResults(this.results);
}
