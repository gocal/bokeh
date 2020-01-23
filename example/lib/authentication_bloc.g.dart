// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_bloc.dart';

// **************************************************************************
// BokehBlocEventsGenerator
// **************************************************************************

class AppStarted_AuthenticationEvent implements AuthenticationEvent {
  const AppStarted_AuthenticationEvent();

  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! AppStarted_AuthenticationEvent) return false;
    return true;
  }

  int get hashCode {
    super.hashCode;
  }

  String toString() {
    return 'AppStarted_AuthenticationEvent <>';
  }
}

class CredentialUpdated_AuthenticationEvent implements AuthenticationEvent {
  const CredentialUpdated_AuthenticationEvent({this.login, this.password});

  final String login;

  final String password;

  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! CredentialUpdated_AuthenticationEvent) return false;
    return true && this.login == other.login && this.password == other.password;
  }

  int get hashCode {
    return $jf($jc($jc(0, login.hashCode), password.hashCode));
  }

  String toString() {
    return 'CredentialUpdated_AuthenticationEvent <\'login\': ${this.login},\'password\': ${this.password},>';
  }
}

class LoggedIn_AuthenticationEvent implements AuthenticationEvent {
  const LoggedIn_AuthenticationEvent();

  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! LoggedIn_AuthenticationEvent) return false;
    return true;
  }

  int get hashCode {
    super.hashCode;
  }

  String toString() {
    return 'LoggedIn_AuthenticationEvent <>';
  }
}

class LoggedOut_AuthenticationEvent implements AuthenticationEvent {
  const LoggedOut_AuthenticationEvent();

  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! LoggedOut_AuthenticationEvent) return false;
    return true;
  }

  int get hashCode {
    super.hashCode;
  }

  String toString() {
    return 'LoggedOut_AuthenticationEvent <>';
  }
}
