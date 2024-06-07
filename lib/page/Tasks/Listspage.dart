// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_lists/modal/Tasks.dart';
import 'package:to_do_lists/page/Tasks/DetailPage.dart';
import 'package:to_do_lists/page/Tasks/MarkedPage.dart';

class ListsPage extends StatelessWidget {
  static const routeName = '/';

  const ListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lists Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<Tasks>(
        builder: (context, value, child) => value.tasks.isNotEmpty
            ? ListView.builder(
                itemCount: value.tasks.length,
                controller: ScrollController(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemBuilder: (context, index) => ItemTile(
                  value.tasks[index].taskId,
                  value.tasks[index].taskName,
                  value.tasks[index].taskTime,
                  value.tasks[index].tasksCompleted,
                ),
              )
            : const Center(
                child: Text('No Tasks'),
              ),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.blue,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                DetailPage.routeName,
                arguments: {
                  'taskType': TaskType(0, '', 0, false),
                  'navigate': 'create',
                },
              );
            },
            tooltip: 'Add new Tasks',
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.add,
              color: Colors.blue,
            ),
          ),
          const SizedBox(
            width: 100,
          ),
          FloatingActionButton(
            onPressed: () {
              // Navigator.pushNamed(context, '/MarkedPage');
              Navigator.pushNamed(context, MarkedPage.routeName);
            },
            tooltip: 'Marked tasks',
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.bookmark,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class ItemTile extends StatelessWidget {
  final int taskId;
  final String? taskName;
  final int taskTime;
  final bool tasksCompleted;

  const ItemTile(
    this.taskId,
    this.taskName,
    this.taskTime,
    this.tasksCompleted, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tasksList = context.watch<Tasks>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.primaries[taskId % Colors.primaries.length],
        ),
        title: Text(
          "$taskName , Time - $taskTime",
          key: Key('text_$taskId'),
        ),
        subtitle: Text(
          tasksCompleted ? 'Completed' : 'Incompleted',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              key: Key('edit_icon_$taskId'),
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  DetailPage.routeName,
                  arguments: {
                    'taskType':
                        TaskType(taskId, taskName!, taskTime, tasksCompleted),
                    'navigate': 'edit',
                  },
                );
              },
            ),
            IconButton(
              key: Key('delete_icon_$taskId'),
              icon: const Icon(Icons.delete),
              onPressed: () {
                tasksList.removeTask(taskId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Task "$taskId" deleted'),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            IconButton(
              key: Key('icon_$taskId'),
              icon: tasksList.getMarkedTaskIds().contains(taskId)
                  ? const Icon(Icons.check_box_outlined)
                  : const Icon(Icons.check_box_outline_blank_sharp),
              onPressed: () {
                !tasksList.getMarkedTaskIds().contains(taskId)
                    ? tasksList.addMarkedTask(taskId, taskName)
                    : tasksList.removeMarkedTask(taskId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(tasksList.getMarkedTaskIds().contains(taskId)
                        ? 'Added "$taskId" to Marked'
                        : 'Removed "$taskId" from Marked'),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


// This project included functions...
//1. Navigate between widget and pass parameter. (go_router)
//2. CRUD with local arrays.
//3. UI is changing when user create,edit and delete on lists (provider)