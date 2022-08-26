import 'dart:convert';
import 'dart:io';

import 'package:testing_rx_dart/models/animal.dart';
import 'package:testing_rx_dart/models/person.dart';

import '../models/thing.dart';

typedef SearchTerm = String;

class Api {
  List<Animal>? _animals;
  List<Person>? _persons;
  Api();

  Future<List<Thing>> search(SearchTerm searchTerm) async {
    final term = searchTerm.trim().toLowerCase();
    final cachedResults = _extractThingsUsingSearchTerm(term);
    if (cachedResults != null) {
      return cachedResults;
    }
    final person = await _getJson('http://127.0.0.1:5500/apis/persons.json')
        .then((json) => json.map((e) => Person.fromJson(e)));
    _persons = person.toList();

    final animals = await _getJson('http://127.0.0.1:5500/apis/animals.json')
        .then((json) => json.map((e) => Animal.fromJson(e)));
    _animals = animals.toList();

    return _extractThingsUsingSearchTerm(term) ?? [];
  }

  List<Thing>? _extractThingsUsingSearchTerm(SearchTerm term) {
    final cachedAnimal = _animals;
    final cachedPerson = _persons;
    if (cachedAnimal != null && cachedPerson != null) {
      List<Thing> result = [];
      for (final animal in cachedAnimal) {
        if (animal.name.trimmedContains(term) ||
            animal.type.name.trimmedContains(term)) {
          result.add(animal);
        }
      }

      for (final person in cachedPerson) {
        if (person.name.trimmedContains(term) ||
            person.companyName.trimmedContains(term) ||
            person.email.trimmedContains(term)) {
          result.add(person);
        }
      }
      return result;
    } else {
      return null;
    }
  }

  Future<List<dynamic>> _getJson(String url) => HttpClient()
      .getUrl(Uri.parse(url))
      .then((req) => req.close())
      .then((response) => response
          .transform(utf8.decoder)
          .join()
          .then((jsonString) => json.decode(jsonString) as List<dynamic>));
}

extension TrimmedCaseInsensitiveContain on String {
  bool trimmedContains(String other) =>
      trim().toLowerCase().contains(other.trim().toLowerCase());
}
