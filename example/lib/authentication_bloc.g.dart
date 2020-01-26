// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_bloc.dart';

// **************************************************************************
// BokehBlocEventsGenerator
// **************************************************************************

abstract class AuthenticationEvent {
  static AuthenticationEvent appStarted() => AppStarted();
  static AuthenticationEvent credentialUpdated({login, password}) =>
      CredentialUpdated(login: login, password: password);
  static AuthenticationEvent loggedIn() => LoggedIn();
  static AuthenticationEvent loggedOut() => LoggedOut();
}

class AppStarted implements AuthenticationEvent {
  const AppStarted();

  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! AppStarted) return false;
    return true;
  }

  int get hashCode {
    super.hashCode;
  }

  String toString() {
    return 'AppStarted []';
  }
}

class CredentialUpdated implements AuthenticationEvent {
  const CredentialUpdated({this.login, this.password});

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
