# Dart Immutable Data Class Builder

Example Model

``` dart
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
```

Example Usage

``` dart
void main() {
  
  // Properties
  var user = User("Joe Doe", 33, "OK");
  assert(user.name == "Joe Doe");
  assert(user.age == 33);
  assert(user.weight == "OK"); 
  print(user);

  // Equals
  var animal = Animal("Dog");
  assert(animal.name == "Dog");
  assert(Animal("Dog") == Animal("Dog"));  
  print(animal);
  print(animal.hashCode);

  // Named parameters
  var shelter = Shelter(Animal("doggo"), cat: Animal("Tom"), mouse: Animal("Jerry"));
  print(shelter);
}

```