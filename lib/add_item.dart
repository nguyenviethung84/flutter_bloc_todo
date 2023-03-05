import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_todo/blocs/blocs.dart';
import 'package:flutter_bloc_todo/models/models.dart';

import 'blocs/todos/todos_bloc.dart';

class AddItem extends StatelessWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerId = TextEditingController();
    TextEditingController controllerTask = TextEditingController();
    TextEditingController controllerDescription = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add item"),
      ),
      body: BlocListener<TodosBloc, TodosState>(
        listener: (context, state) {
          if(state is TodosLoaded){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("To do added"))
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              inputField("ID", controllerId),
              inputField("Task", controllerTask),
              inputField("Description", controllerDescription),
              ElevatedButton(
                  onPressed: () {
                    var todo = Todo(
                      id: controllerId.value.text,
                      task: controllerTask.value.text,
                      description: controllerDescription.value.text,
                    );
                    context.read<TodosBloc>().add(
                      AddTodos(todo: todo),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Add")
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column inputField(String field,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$field: ',
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(
          height: 50,
          width: double.infinity,
          child: TextFormField(
            controller: controller,
          ),
        )
      ],
    );
  }
}
