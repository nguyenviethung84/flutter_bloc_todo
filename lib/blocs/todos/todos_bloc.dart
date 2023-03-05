
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_todo/models/models.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  TodosBloc() : super(TodosLoading()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodos>(_onAddTodos);
    on<UpdateTodos>(_onUpdateTodos);
    on<DeleteTodos>(_onDeleteTodos);
  }

  void _onLoadTodos(LoadTodos event, Emitter<TodosState> emit){
    emit(
      TodosLoaded(todos: event.todos),
    );
  }

  void _onAddTodos(AddTodos event, Emitter<TodosState> emit){
    final state = this.state;
    if(state is TodosLoaded){
      emit(
        TodosLoaded(
          todos: List.from(state.todos)..add(event.todo),
        )
      );
    }
  }

  void _onUpdateTodos(UpdateTodos event, Emitter<TodosState> emit){
    final state = this.state;
    if(state is TodosLoaded){
      List<Todo> todos = (state.todos.map((todo){
        return todo.id == event.todo.id ? event.todo : todo;
      })).toList();
      emit(TodosLoaded(todos: todos));
    }
  }

  void _onDeleteTodos(DeleteTodos event, Emitter<TodosState> emit){
    final state = this.state;
    if(state is TodosLoaded){
      List<Todo> todos = state.todos.where((todo){
        return todo.id != event.todo.id;
      }).toList();
      emit(TodosLoaded(todos: todos));
    }
  }
}
