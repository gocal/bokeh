// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// bokehDataGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

abstract class _$User {
  _$User._();

  String get name;

  int get age;

  String get weight;
}

class _$User$ extends User {
  _$User$._(this.name, this.age, this.weight) : super._();

  @override
  final String name;

  @override
  final int age;

  @override
  final String weight;

  @override
  String toString() {
    return "User[name=${name}, age=${age}, weight=${weight}]";
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, name.hashCode), age.hashCode), weight.hashCode));
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
        name == other.name &&
        age == other.age &&
        weight == other.weight;
  }
}

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

abstract class _$Animal {
  _$Animal._();

  String get name;
}

class _$Animal$ extends Animal {
  _$Animal$._(this.name) : super._();

  @override
  final String name;

  @override
  String toString() {
    return "Animal[name=${name}]";
  }

  @override
  int get hashCode {
    return $jf($jc(0, name.hashCode));
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Animal && name == other.name;
  }
}

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

abstract class _$Home {
  _$Home._();

  User get owner;

  Animal get cat;
}

class _$Home$ extends Home {
  _$Home$._(this.owner, this.cat) : super._();

  @override
  final User owner;

  @override
  final Animal cat;

  @override
  String toString() {
    return "Home[owner=${owner}, cat=${cat}]";
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, owner.hashCode), cat.hashCode));
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Home && owner == other.owner && cat == other.cat;
  }
}

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

abstract class _$Shelter {
  _$Shelter._();

  Animal get dog;

  Animal get cat;

  Animal get mouse;
}

class _$Shelter$ extends Shelter {
  _$Shelter$._(this.dog, {this.cat, this.mouse}) : super._();

  @override
  final Animal dog;

  @override
  final Animal cat;

  @override
  final Animal mouse;

  @override
  String toString() {
    return "Shelter[dog=${dog}, cat=${cat}, mouse=${mouse}]";
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, dog.hashCode), cat.hashCode), mouse.hashCode));
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Shelter &&
        dog == other.dog &&
        cat == other.cat &&
        mouse == other.mouse;
  }
}
