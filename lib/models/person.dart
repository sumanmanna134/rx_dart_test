import 'package:flutter/foundation.dart' show immutable;
import 'package:testing_rx_dart/models/thing.dart';

@immutable
class Person extends Thing {
  final String companyName;
  final String email;

  Person({required String name, required this.companyName, required this.email})
      : super(name: name);
  @override
  String toString() =>
      'Person, Name: $name, Company: $companyName, email: $email';

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
        name: json["name"], companyName: json["company"], email: json["email"]);
  }
}
