// import 'package:example/example.dart';

import 'package:example/models.dart';

/// Simple usage examples for built_value.
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
