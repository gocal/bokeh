import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bokeh/bokeh.dart';

part 'authentication_bloc.g.dart';

///
/// Model
///
@data
abstract class _Employee {
  double x;
  double y;
}

///
/// Events
///
@protocol
@Selector(statesClass: AuthenticationStates)
abstract class AuthenticationEvents {
  AppStarted(int timestamp);
  CredentialUpdated({String login, String password = "loremIpsum"});
  LoggedIn();
  LoggedOut();
}

///
/// States
///
@protocol
abstract class AuthenticationStates {
  Idle();
  Loading({int progress, String message});
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
        final current = state as Loading;

        yield current.copyWith(progress: 20);

        await Future.delayed(Duration());
        yield AuthenticationState.idle();
        yield AuthenticationState.loading();
        yield AuthenticationState.loading(progress: 200);
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
