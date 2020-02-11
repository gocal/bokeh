# Bloc Boilerplate generator

Example Authentication Bloc 

``` dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bokeh/bokeh.dart';

part 'authentication_bloc.g.dart';

/// Events
@protocol
abstract class _AuthenticationEvent {
  appStarted(int timestamp);
  credentialUpdated({String login, String password = "loremIpsum"});
  loggedIn();
  loggedOut();
}

/// States
@protocol
abstract class _AuthenticationState {
  idle();
  loading({int progress, String message});
  error(Exception e);
}

/// Bloc
@BlocOf(state: _AuthenticationState, event: _AuthenticationEvent)
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  @override
  AuthenticationState get initialState => AuthenticationState.idle();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    yield* event.when(
      //
      appStarted: (_) async* {
        final current = state as Loading;
        yield current.copyWith(progress: 20);
        await Future.delayed(Duration(seconds: 2));
        yield AuthenticationState.idle();
        yield AuthenticationState.loading();
        await Future.delayed(Duration(seconds: 4));
        yield AuthenticationState.loading(progress: 200);
        yield AuthenticationState.idle();
      },
      //
      credentialUpdated: (_) async* {
        await Future.delayed(Duration());
      },

      //
      loggedOut: () async* {
        yield AuthenticationState.idle();
      },
      loggedIn: () async* {
        // skip
      },
    );
  }
}
```