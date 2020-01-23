// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_bloc.dart';

// **************************************************************************
// BokehBlocEventsGenerator
// **************************************************************************

class AppStarted_AuthenticationEvent {
  const AppStarted_AuthenticationEvent();
}

class CredentialUpdated_AuthenticationEvent {
  const CredentialUpdated_AuthenticationEvent({this.login, this.password});

  final String login;

  final String password;
}

class LoggedIn_AuthenticationEvent {
  const LoggedIn_AuthenticationEvent();
}

class LoggedOut_AuthenticationEvent {
  const LoggedOut_AuthenticationEvent();
}
