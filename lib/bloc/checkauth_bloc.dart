import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
abstract class CheckLogin {}

class CheckTokenBeforeGo extends CheckLogin {}

@immutable
abstract class CheckTokenState {}

class TokenIsEmpty extends CheckTokenState {}

class TokenInitial extends CheckTokenState {}

class TokenIsAvailable extends CheckTokenState {
  final String? token;

  TokenIsAvailable({@required this.token});
}

class TokenBloc extends Bloc<CheckLogin, CheckTokenState> {
  TokenBloc() : super(TokenInitial()) {
    on<CheckLogin>((event, emit) async {
      if (event is CheckTokenBeforeGo) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var token = prefs.getString("token");
        if (prefs.getString("token") == null) {
          emit(TokenIsEmpty());
        } else {
          emit(TokenIsAvailable(token: token));
        }
      }
    });
  }
}
