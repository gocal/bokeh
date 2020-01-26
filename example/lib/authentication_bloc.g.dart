// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_bloc.dart';

// **************************************************************************
// BokehBlocEventsGenerator
// **************************************************************************

abstract class AuthenticationEvent {
  static AuthenticationEvent appStarted() => null;
  static AuthenticationEvent credentialUpdated({login, password}) =>
      CredentialUpdated();
  static AuthenticationEvent loggedIn() => null;
  static AuthenticationEvent loggedOut() => null;
}

class AppStarted implements AuthenticationEvent {
  const AppStarted();
}

class CredentialUpdated implements AuthenticationEvent {
  const CredentialUpdated({this.login, this.password});

  final String login;

  final String password;
}

class LoggedIn implements AuthenticationEvent {
  const LoggedIn();
}

class LoggedOut implements AuthenticationEvent {
  const LoggedOut();
}
