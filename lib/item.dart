
import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  const Item({Key? key, required this.id, required this.name}) : super(key: key);
  final int id;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("#$id: "),
        Expanded(child: Text(name)),
        IconButton(onPressed: (){}, icon: const Icon(Icons.edit)),
        IconButton(onPressed: (){}, icon: const Icon(Icons.delete)),
      ],
    );
  }
}
