import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bokeh/bokeh.dart';

part 'authentication_bloc.g.dart';

///
/// Model
///

@data
abstract class _$Employee {
  int get id;
  String get name;
}

@data
abstract class _$Employee {
  int get id;
  String get name;
}

///
/// Events
///
@protocol
abstract class AuthenticationEvents {
  appStarted(int timestamp);
  credentialUpdated({String login, String password = "loremIpsum"});
  loggedIn();
  loggedOut();
}

///
/// States
///
@protocol
abstract class _$AuthenticationStates {
  idle();
  loading({int progress, String message});
  error(Exception e);
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
    /*
    @Selector(statesClass: AuthenticationStates)
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
    */
  }
}
