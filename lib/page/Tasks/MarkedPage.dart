// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_lists/modal/Tasks.dart';

class MarkedPage extends StatelessWidget {
  static const routeName = 'marked_page';
  static const fullPath = '/$routeName';

  const MarkedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Marked Page",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<Tasks>(
        builder: (context, value, child) => value.tasksmarked.isNotEmpty
            ? ListView.builder(
                itemCount: value.tasksmarked.length,
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemBuilder: (context, index) => TaskItemTile(
                  value.tasksmarked[index].markedTaskId,
                  value.tasksmarked[index].markedTasksName,
                ),
              )
            : const Center(
                child: Text('No Marded'),
              ),
      ),
    );
  }
}

class TaskItemTile extends StatelessWidget {
  final int? markedTaskId;
  final String? markedTaskName;

  const TaskItemTile(this.markedTaskId, this.markedTaskName, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            Colors.primaries[markedTaskId! % Colors.primaries.length],
      ),
      title: Text(
        markedTaskName!,
        key: Key('marked_key_$markedTaskId'),
      ),
      trailing: IconButton(
        key: Key('remove_icon_$markedTaskId'),
        icon: const Icon(Icons.close),
        onPressed: () {
          context.read<Tasks>().removeMarkedTask(markedTaskId);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Removed from Tasks.'),
              duration: Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
}
