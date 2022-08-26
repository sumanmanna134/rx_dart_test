import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testing_rx_dart/bloc/search_result.dart';
import 'package:testing_rx_dart/models/animal.dart';
import 'package:testing_rx_dart/models/person.dart';

class SearchResultView extends StatelessWidget {
  final Stream<SearchResult?> searchResult;
  const SearchResultView({Key? key, required this.searchResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SearchResult?>(
        stream: searchResult,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            final result = snapshot.data;
            if (result is SearchResultHasError) {
              return const Text("Got Error");
            } else if (result is SearchResultLoading) {
              return const CupertinoActivityIndicator(
                radius: 30,
              );
            } else if (result is SearchResultNoResult) {
              return const Text(
                  "No Result found for your search term, try with another one!");
            } else if (result is SearchResultWithResults) {
              final results = result.results;
              return Expanded(
                  child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final item = results[index];
                  final String title;
                  if (item is Animal) {
                    title = 'Animal';
                  } else if (item is Person) {
                    title = 'Person';
                  } else {
                    title = 'Unknown';
                  }

                  return ListTile(
                    title: Text(title),
                    subtitle: Text(item.toString()),
                  );
                },
              ));
            } else {
              return const Text('Unknown State');
            }
          } else {
            return const Text('Waiting');
          }
        }));
  }
}
