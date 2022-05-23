import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
abstract class AuthEvent {}

class AuthLogin extends AuthEvent {
  final String? email;
  final String? password;

  AuthLogin({@required this.email, @required this.password});
}

class AuthLogout extends AuthEvent {}

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthCheckLogin extends AuthState {
  final String? isLoggedIn;

  AuthCheckLogin({@required this.isLoggedIn});
}

class AuthCheckLoginOff extends AuthState {}

class LoginInitial extends AuthState {}

class RouteHomePage extends AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthLogin) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", "123456");
      } else if (event is AuthLogout) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove("token");
      }
    });
  }
}
