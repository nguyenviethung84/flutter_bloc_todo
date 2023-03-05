import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_todo/add_item.dart';
import 'package:flutter_bloc_todo/blocs/blocs.dart';
import 'package:flutter_bloc_todo/models/models.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todo app'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddItem()));
                },
                icon: const Icon(Icons.add)
            ),
          ],
          bottom: TabBar(
            onTap: (tabIndex){
              switch(tabIndex){
                case 0:
                  BlocProvider.of<TodosFilterBloc>(context).add(
                    const UpdateTodosFilter(todosFilter: TodosFilter.pending),
                  );
                  break;
                case 1:
                  BlocProvider.of<TodosFilterBloc>(context).add(
                    const UpdateTodosFilter(todosFilter: TodosFilter.completed),
                  );
                  break;
              }
            },
            tabs: const [
              Tab(icon: Icon(Icons.pending),),
              Tab(icon: Icon(Icons.add_task),),
            ]
          ),
        ),
        body: TabBarView(
          children: [
            _todos('Pending todo'),
            _todos('Complete todo')
          ],
        ),
      ),
    );
  }

  BlocBuilder<TodosFilterBloc, TodosFilterState> _todos(String title) {
    return BlocBuilder<TodosFilterBloc, TodosFilterState>(
      builder: (context, state) {
        if(state is TodosFilterLoading){
          return const CircularProgressIndicator();
        }
        if(state is TodosFilterLoaded){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.filteredTodos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return todoCard(context, state.filteredTodos[index]);
                    }
                )
              ],
            ),
          );
        }else{
          return const Text('Wrong something!');
        }

      },
    );
  }

  Card todoCard(BuildContext context, Todo todo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '#${todo.id}: ${todo.task}',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      context.read<TodosBloc>().add(
                        UpdateTodos(todo: todo.copyWith(isCompleted: true))
                      );
                    },
                    icon: const Icon(Icons.add_task)
                ),
                IconButton(
                    onPressed: () {
                      context.read<TodosBloc>().add(
                        DeleteTodos(todo: todo)
                      );
                    },
                    icon: const Icon(Icons.cancel)
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
