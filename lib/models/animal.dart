import 'package:flutter/foundation.dart' show immutable;
import 'package:testing_rx_dart/models/thing.dart';

enum AnimalType { dog, cat, rabbit, unknown }

@immutable
class Animal extends Thing {
  final AnimalType type;

  Animal({required String name, required this.type}) : super(name: name);
  @override
  String toString() => 'Animal, Name: $name, type: $type';

  factory Animal.fromJson(Map<String, dynamic> json) {
    final AnimalType animalType;
    switch ((json["type"] as String).toLowerCase().trim()) {
      case "rabbit":
        animalType = AnimalType.rabbit;
        break;
      case "cat":
        animalType = AnimalType.cat;
        break;
      default:
        animalType = AnimalType.unknown;
    }
    return Animal(name: json["name"], type: animalType);
  }
}
