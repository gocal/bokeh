import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bokeh/bokeh.dart';

part 'authentication_bloc.g.dart';

/// Events
@blocEvents
abstract class AuthenticationEvent {
  appStarted();
  loggedIn();
  loggedOut();
}

/// States
@blocStates
abstract class AuthenticationState {
  idle();
  loading();
  error(Exception e);
}

/// Bloc
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  @override
  AuthenticationState get initialState => null;

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {}
}
