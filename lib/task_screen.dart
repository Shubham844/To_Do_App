import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';

class TaskScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('To-Do List')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: taskProvider.tasks.length,
                itemBuilder: (context, index) {
                  final task = taskProvider.tasks[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(task.title),
                      trailing: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) {
                          task.isCompleted = !task.isCompleted;
                          taskProvider.updateTask(task);
                        },
                      ),
                      leading: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          taskProvider.deleteTask(task.id!);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'New Task',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        taskProvider.addTask(Task(title: _controller.text));
                        _controller.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
