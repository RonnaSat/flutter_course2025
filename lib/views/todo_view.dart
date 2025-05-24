import 'package:flutter/cupertino.dart';
import '../viewModels/todo_view_model.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TodoViewModel _viewModel = TodoViewModel();
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Todo'),
        border: null,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      controller: _controller,
                      placeholder: 'Add todo',
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      clearButtonMode: OverlayVisibilityMode.editing,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    child: const Icon(CupertinoIcons.add_circled, size: 26),
                    onPressed: () {
                      setState(() {
                        _viewModel.addTodo(_controller.text);
                        _controller.clear();
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: CupertinoColors.systemGrey5,
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: _viewModel,
                builder: (context, _) {
                  return ListView.builder(
                    itemCount: _viewModel.todos.length,
                    itemBuilder: (context, index) {
                      final todo = _viewModel.todos[index];
                      return Dismissible(
                        key: ValueKey(todo.title + index.toString()),
                        background: Container(
                          color: CupertinoColors.systemGrey6,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 16),
                          child: const Icon(CupertinoIcons.check_mark,
                              color: CupertinoColors.systemGrey, size: 20),
                        ),
                        secondaryBackground: Container(
                          color: CupertinoColors.systemGrey6,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(CupertinoIcons.delete,
                              color: CupertinoColors.systemGrey, size: 20),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            setState(() {
                              _viewModel.toggleTodo(index);
                            });
                            return false;
                          } else if (direction == DismissDirection.endToStart) {
                            setState(() {
                              _viewModel.deleteTodo(index);
                            });
                            return true;
                          }
                          return false;
                        },
                        child: CupertinoListTile(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 2),
                          leading: Icon(
                            todo.isDone
                                ? CupertinoIcons.check_mark_circled_solid
                                : CupertinoIcons.circle,
                            color: todo.isDone
                                ? CupertinoColors.activeGreen
                                : CupertinoColors.systemGrey,
                            size: 22,
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              fontSize: 16,
                              decoration: todo.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: todo.isDone
                                  ? CupertinoColors.systemGrey
                                  : CupertinoColors.label,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _viewModel.toggleTodo(index);
                            });
                          },
                          trailing: CupertinoButton(
                            padding: const EdgeInsets.all(0),
                            child: const Icon(
                              CupertinoIcons.delete,
                              size: 20,
                              color: CupertinoColors.systemGrey,
                            ),
                            onPressed: () {
                              setState(() {
                                _viewModel.deleteTodo(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
