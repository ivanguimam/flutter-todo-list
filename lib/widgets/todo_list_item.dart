import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    super.key,
    required this.todo,
    required this.onDelete,
    required this.onEdit,
  });

  final Todo todo;
  final Function(Todo) onDelete;
  final Function(Todo) onEdit;

  @override
  Widget build(BuildContext context) {
    TextStyle dateStyle = TextStyle(
      fontSize: 12,
    );
    Text date = Text(DateFormat('dd/MM/yyyy - HH:mm').format(todo.dateTime),
        style: dateStyle);

    TextStyle nameStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    Text name = Text(todo.title, style: nameStyle);

    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [date, name],
    );

    BoxDecoration decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: Colors.grey[200],
    );

    Container container = Container(
      decoration: decoration,
      padding: EdgeInsets.all(16),
      child: column,
    );

    SlidableDrawerActionPane actionPane = SlidableDrawerActionPane();
    IconSlideAction deleteAction = IconSlideAction(
      caption: 'Deletar',
      color: Colors.red,
      icon: Icons.delete,
      onTap: () {
        onDelete(todo);
      },
    );

    IconSlideAction editAction = IconSlideAction(
      caption: 'Editar',
      color: Colors.blue,
      icon: Icons.edit,
      onTap: () {
        onEdit(todo);
      },
    );

    Slidable slidable = Slidable(
      actionPane: actionPane,
      secondaryActions: [deleteAction, editAction],
      child: container,
    );

    Padding padding = Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: slidable,
    );

    return padding;
  }
}
