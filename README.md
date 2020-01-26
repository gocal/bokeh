# Dart Immutable Data Class Builder

Example Authentication Bloc 

``` dart
import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:bokeh/bokeh.dart';

part 'authentication_bloc.g.dart';

///
/// Events
///
@blocEvents
@BlocSelector(statesClass: AuthenticationStates)
abstract class AuthenticationEvents {
  AppStarted(int timestamp);
  CredentialUpdated({String login, String password = "loremIpsum"});
  LoggedIn();
  LoggedOut();
}

///
/// States
///
@blocStates
abstract class AuthenticationStates {
  Idle();
  Loading();
  Error(Exception e);
}

///
/// Bloc
///
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  @override
  AuthenticationState get initialState => null;

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    yield* event.when(
      //
      appStarted: (event) async* {
        await Future.delayed(Duration());
        yield AuthenticationState.idle();
        yield AuthenticationState.loading();
      },
      //
      credentialUpdated: (event) async* {
        await Future.delayed(Duration());
      },

      //
      loggedOut: () async* {
        yield AuthenticationState.idle();
      },
      loggedIn: () async* {},
    );
  }
}
```