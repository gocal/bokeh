// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_bloc.dart';

// **************************************************************************
// BokehProtocolGenerator
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

  String toString() {
    return 'AppStarted [\'timestamp\': ${this.timestamp},]';
  }

  int get hashCode {
    return $jf($jc(0, timestamp.hashCode));
  }

  AppStarted copyWith({int timestamp}) {
    return AppStarted(
      timestamp ?? this.timestamp,
    );
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

  String toString() {
    return 'CredentialUpdated [\'login\': ${this.login},\'password\': ${this.password},]';
  }

  int get hashCode {
    return $jf($jc($jc(0, login.hashCode), password.hashCode));
  }

  CredentialUpdated copyWith({String login, String password}) {
    return CredentialUpdated(
      login: login ?? this.login,
      password: password ?? this.password,
    );
  }
}

class LoggedIn implements AuthenticationEvent {
  const LoggedIn();

  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! LoggedIn) return false;
    return true;
  }

  String toString() {
    return 'LoggedIn []';
  }

  LoggedIn copyWith() {
    return LoggedIn();
  }
}

class LoggedOut implements AuthenticationEvent {
  const LoggedOut();

  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! LoggedOut) return false;
    return true;
  }

  String toString() {
    return 'LoggedOut []';
  }

  LoggedOut copyWith() {
    return LoggedOut();
  }
}

abstract class AuthenticationState {
  static AuthenticationState idle() => Idle();
  static AuthenticationState loading({int progress, String message}) =>
      Loading(progress: progress, message: message);
  static AuthenticationState error(Exception e) => Error(e);
}

class Idle implements AuthenticationState {
  const Idle();

  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! Idle) return false;
    return true;
  }

  String toString() {
    return 'Idle []';
  }

  Idle copyWith() {
    return Idle();
  }
}

class Loading implements AuthenticationState {
  const Loading({int this.progress, String this.message});

  final int progress;

  final String message;

  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! Loading) return false;
    return true &&
        this.progress == other.progress &&
        this.message == other.message;
  }

  String toString() {
    return 'Loading [\'progress\': ${this.progress},\'message\': ${this.message},]';
  }

  int get hashCode {
    return $jf($jc($jc(0, progress.hashCode), message.hashCode));
  }

  Loading copyWith({int progress, String message}) {
    return Loading(
      progress: progress ?? this.progress,
      message: message ?? this.message,
    );
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

  String toString() {
    return 'Error [\'e\': ${this.e},]';
  }

  int get hashCode {
    return $jf($jc(0, e.hashCode));
  }

  Error copyWith({Exception e}) {
    return Error(
      e ?? this.e,
    );
  }
}

// **************************************************************************
// BokehBlocGenerator
// **************************************************************************

extension AuthenticationEventExtension on AuthenticationEvent {
  Stream<AuthenticationState> when(
      {Stream<AuthenticationState> Function(AppStarted) appStarted,
      Stream<AuthenticationState> Function(CredentialUpdated) credentialUpdated,
      Stream<AuthenticationState> Function() loggedIn,
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
