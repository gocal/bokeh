import 'package:bokeh/bokeh.dart';

part 'models.g.dart';

@data
abstract class User implements _$User {
  User._();
  factory User(String name, int age, String weight) = _$User$._;
}

@data
abstract class Animal implements _$Animal {
  Animal._();
  factory Animal(String name) = _$Animal$._;
}

@data
abstract class Home implements _$Home {
  Home._();
  factory Home(User owner, Animal cat) = _$Home$._;
}

@data
abstract class Shelter implements _$Shelter {
  Shelter._();
  factory Shelter(Animal dog, {Animal cat, Animal mouse}) = _$Shelter$._;
}
