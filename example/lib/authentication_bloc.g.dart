// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_bloc.dart';

// **************************************************************************
// BokehBlocEventsGenerator
// **************************************************************************

abstract class AuthenticationEvent {
  static AuthenticationEvent appStarted(int timestamp) => AppStarted(timestamp);
  static AuthenticationEvent credentialUpdated(
          {String login, String password}) =>
      CredentialUpdated(login: login, password: password);
  static AuthenticationEvent loggedIn() => LoggedIn();
  static AuthenticationEvent loggedOut() => LoggedOut();
}

class AppStarted implements AuthenticationEvent {
  const AppStarted([int this.timestamp]);

  final int timestamp;

  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! AppStarted) return false;
    return true && this.timestamp == other.timestamp;
  }

  int get hashCode {
    return $jf($jc(0, timestamp.hashCode));
  }

  String toString() {
    return 'AppStarted [\'timestamp\': ${this.timestamp},]';
  }
}

class CredentialUpdated implements AuthenticationEvent {
  const CredentialUpdated({String this.login, String this.password});

  final String login;

  final String password;

  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! CredentialUpdated) return false;
    return true && this.login == other.login && this.password == other.password;
  }

  int get hashCode {
    return $jf($jc($jc(0, login.hashCode), password.hashCode));
  }

  String toString() {
    return 'CredentialUpdated [\'login\': ${this.login},\'password\': ${this.password},]';
  }
}

class LoggedIn implements AuthenticationEvent {
  const LoggedIn();

  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! LoggedIn) return false;
    return true;
  }

  int get hashCode {
    super.hashCode;
  }

  String toString() {
    return 'LoggedIn []';
  }
}

class LoggedOut implements AuthenticationEvent {
  const LoggedOut();

  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! LoggedOut) return false;
    return true;
  }

  int get hashCode {
    super.hashCode;
  }

  String toString() {
    return 'LoggedOut []';
  }
}

// **************************************************************************
// BokehBlocStatesGenerator
// **************************************************************************

abstract class AuthenticationState {
  static AuthenticationState idle() => Idle();
  static AuthenticationState loading() => Loading();
  static AuthenticationState error(Exception e) => Error(e);
}

class Idle implements AuthenticationState {
  const Idle();

  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! Idle) return false;
    return true;
  }

  int get hashCode {
    super.hashCode;
  }

  String toString() {
    return 'Idle []';
  }

  Idle copyWith() {
    return Idle();
  }
}

class Loading implements AuthenticationState {
  const Loading();

  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! Loading) return false;
    return true;
  }

  int get hashCode {
    super.hashCode;
  }

  String toString() {
    return 'Loading []';
  }

  Loading copyWith() {
    return Loading();
  }
}

class Error implements AuthenticationState {
  const Error([Exception this.e]);

  final Exception e;

  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! Error) return false;
    return true && this.e == other.e;
  }

  int get hashCode {
    return $jf($jc(0, e.hashCode));
  }

  String toString() {
    return 'Error [\'e\': ${this.e},]';
  }

  Error copyWith({Exception e}) {
    return Error(
      e ?? this.e,
    );
  }
}

// **************************************************************************
// BokehBlocSelectorGenerator
// **************************************************************************

extension AuthenticationEventExtension on AuthenticationEvent {
  Stream<AuthenticationState> when(
      {@required
          Stream<AuthenticationState> Function(AppStarted) appStarted,
      @required
          Stream<AuthenticationState> Function(CredentialUpdated)
              credentialUpdated,
      @required
          Stream<AuthenticationState> Function() loggedIn,
      @required
          Stream<AuthenticationState> Function() loggedOut}) async* {
    if (this is AppStarted) {
      yield* appStarted(this as AppStarted);
      return;
    }
    if (this is CredentialUpdated) {
      yield* credentialUpdated(this as CredentialUpdated);
      return;
    }
    if (this is LoggedIn) {
      yield* loggedIn();
      return;
    }
    if (this is LoggedOut) {
      yield* loggedOut();
      return;
    }
  }
}
