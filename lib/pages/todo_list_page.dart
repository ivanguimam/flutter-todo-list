import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/repositories/todo_repository.dart';
import 'package:todo_list/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Todo> todos = [];
  String? errorText;

  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  void onPressed() {
    if (todoController.text.isEmpty) {
      setState(() {
        errorText = 'O título não deve ser vázio';
      });

      return;
    }

    setState(() {
      todos.add(Todo(
        dateTime: DateTime.now(),
        title: todoController.text,
      ));

      todoController.clear();
      todoRepository.save(todos);
      errorText = null;
    });
  }

  void onSubmitted(String value) {
    onPressed();
  }

  void cancelClear() {
    Navigator.of(context).pop();
  }

  void confirmClear() {
    Navigator.of(context).pop();
    clear();
  }

  void showClearConfirmationDiablog() {
    Text title = Text('Limpar Tudo?');
    Text message = Text('Você tem certeza que deseja apagar todas as Tarefas?');

    Text cancelText = Text('Cancelar');
    ButtonStyle cancelStyle = TextButton.styleFrom(foregroundColor: Color(0xFF00D7F3));
    TextButton cancel = TextButton(
      style: cancelStyle,
      onPressed: cancelClear,
      child: cancelText
    );

    Text confirmText = Text('Limpar tudo');
    ButtonStyle confirmStyle = TextButton.styleFrom(foregroundColor: Colors.red);
    TextButton confirm = TextButton(
      style: confirmStyle,
      onPressed: confirmClear,
      child: confirmText
    );

    AlertDialog alertDialog = AlertDialog(
      actions: [cancel, confirm],
      content: message,
      title: title,
    );

    showDialog(
      context: context,
      builder: (context) => alertDialog,
    );
  }

  void clear() {
    setState(() {
      todos.clear();
      todoRepository.save(todos);
    });
  }

  void undo(int index, Todo todo) {
    setState(() {
      todos.insert(index, todo);
      todoRepository.save(todos);
    });
  }

  void onDelete(Todo todo) {
    Todo deletedTodo = todo;
    int deletedIndex = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
      todoRepository.save(todos);
    });

    ScaffoldMessenger.of(context).clearSnackBars();

    TextStyle messageStyle = TextStyle(
      color: Color(0XFF060708)
    );
    Text message = Text('Tarefa "${todo.title}" foi removida com sucesso', style: messageStyle);

    SnackBarAction action = SnackBarAction(
      label: 'Desfazer',
      onPressed: () {
        undo(deletedIndex, deletedTodo);
      },
      textColor: Color(0XFF00D7F3)
    );

    SnackBar snackBar = SnackBar(
      action: action,
      backgroundColor: Colors.white,
      content: message,
      duration: Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void onEdit(Todo todo) {
    todoController.text = todo.title;
    // setState(() {
    //   todos.remove(todo);
    // });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      todoRepository.start().then((void a) {
        todos = todoRepository.getAll();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TextField field = TextField(
      controller: todoController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        errorText: errorText,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0XFF00D7F3), width: 2),
        ),
        hintText: 'Ex: Estudar flutter',
        labelStyle: TextStyle(color: errorText != null ? Colors.red : Color(0XFF00D7F3)),
        labelText: 'Adicione uma tarefa',
      ),
      onSubmitted: onSubmitted,
    );

    Expanded fieldExpanded = Expanded(
      child: field
    );

    Icon addIcon = Icon(
      Icons.add,
      size: 30,
    );
    ButtonStyle btnStyle = ElevatedButton.styleFrom(
      backgroundColor: Color(0XFF00D7F3),
      padding: EdgeInsets.all(14),
    );
    ElevatedButton addBtn = ElevatedButton(
      onPressed: onPressed,
      style: btnStyle,
      child: addIcon
    );

    SizedBox space = SizedBox(width: 8);

    Row addNewToDoRow = Row(
      children: [fieldExpanded, space, addBtn],
    );

    Text clearText = Text('Você possui ${todos.length} tarefas pendentes');
    Expanded clearTextExpanded = Expanded(
      child: clearText
    );

    SizedBox clearHorizontalSeparator = SizedBox(
      width: 8,
    );

    Text clearTextBtn = Text('Limpar tudo');
    ElevatedButton clearBtn = ElevatedButton(
      onPressed: todos.isEmpty ? null : showClearConfirmationDiablog,
      style: btnStyle,
      child: clearTextBtn
    );

    Row clearRow = Row(
      children: [clearTextExpanded, clearHorizontalSeparator, clearBtn],
    );

    SizedBox rowsSeparator = SizedBox(
      height: 16,
    );

    ListView todoList = ListView(
      shrinkWrap: true,
      children: [
        for (Todo todo in todos) TodoListItem(todo: todo, onDelete: onDelete, onEdit: onEdit)
      ],
    );

    Flexible listContainer = Flexible(child: todoList);

    Column column = Column(
      mainAxisSize: MainAxisSize.min,
      children: [addNewToDoRow, rowsSeparator, listContainer, rowsSeparator, clearRow],
    );

    Padding padding = Padding(
      padding: EdgeInsets.all(16),
      child: column,
    );

    Center body = Center(
      child: padding,
    );

    Scaffold scaffold = Scaffold(body: body);

    SafeArea safeArea = SafeArea(child: scaffold);

    return safeArea;
  }
}
