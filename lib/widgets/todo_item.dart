import 'package:flutter/material.dart';

import '../model/todo.dart';
import '../constants/colors.dart';

class ToDoItem extends StatelessWidget {
  final Curiosities todo;
  final Function(Curiosities) onToDoChanged;
  final Function(String) onDeleteItem;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        title: Text(
          todo.CuriosText ?? '',
          style: TextStyle(
            fontSize: 16,
            color: tdBlack,
           
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              todo.isDone ? Icons.favorite : Icons.favorite_outline,
              color: const Color.fromARGB(255, 50, 49, 51),
            ),
            const SizedBox(width: 10),
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 53, 50, 50),
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                color: Colors.white,
                iconSize: 16,
                icon: const Icon(Icons.share),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
