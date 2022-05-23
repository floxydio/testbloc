import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class TodosEvent {}

class TodosInit extends TodosEvent {}

@immutable
abstract class TodosState {}

class TodoInitial extends TodosState {}

class TodoLoading extends TodosState {}

class TodoLoaded extends TodosState {
  final List<dynamic> data;

  TodoLoaded({required this.data});
}

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  TodosBloc() : super(TodoInitial()) {
    on<TodosEvent>((event, emit) async {
      if (event is TodosInit) {
        emit(TodoLoading());
        var response =
            await Dio().get("https://jsonplaceholder.typicode.com/todos");
        print(response.data);

        emit(TodoLoaded(data: response.data));
      }
    });
  }
}
