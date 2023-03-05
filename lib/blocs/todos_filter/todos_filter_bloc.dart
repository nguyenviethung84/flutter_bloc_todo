import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_todo/blocs/blocs.dart';
import 'package:flutter_bloc_todo/blocs/todos/todos_bloc.dart';
import 'package:flutter_bloc_todo/models/models.dart';

part 'todos_filter_event.dart';
part 'todos_filter_state.dart';

class TodosFilterBloc extends Bloc<TodosFilterEvent, TodosFilterState> {
  final TodosBloc _todosBloc;
  late StreamSubscription _todosSubscription;

  TodosFilterBloc({required TodosBloc todosBloc}) : _todosBloc = todosBloc, super(TodosFilterLoading()) {
    on<UpdateFilter>(_onUpdateFilter);
    on<UpdateTodosFilter>(_onUpdateTodosFilter);

    _todosSubscription = todosBloc.stream.listen((state) {
      add(
        const UpdateFilter()
      );
    });
  }

  void _onUpdateFilter(UpdateFilter event, Emitter<TodosFilterState> emit){
    if(state is TodosFilterLoading){
      add(
        const UpdateTodosFilter(todosFilter: TodosFilter.pending)
      );
    }

    if(state is TodosFilterLoaded){
      final state = this.state as TodosFilterLoaded;

      add(
        UpdateTodosFilter(todosFilter: state.todosFilter)
      );
    }
  }

  void _onUpdateTodosFilter(UpdateTodosFilter event, Emitter<TodosFilterState> emit){
    final state = _todosBloc.state;

    if(state is TodosLoaded){
      List<Todo> todos = state.todos.where((todo){
        switch(event.todosFilter){
          case TodosFilter.all:
            return true;
          case TodosFilter.completed:
            return todo.isCompleted!;
          case TodosFilter.cancelled:
            return todo.isCancelled!;
          case TodosFilter.pending:
            return !(todo.isCompleted! || todo.isCancelled!);
        }
      }).toList();
      emit(TodosFilterLoaded(filteredTodos: todos, todosFilter: event.todosFilter));
    }
  }
}
