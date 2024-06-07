// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:to_do_lists/modal/Tasks.dart';

// Using Controller for TextFormField

class DetailPage extends StatefulWidget {
  static const routeName = 'detail_Page';
  static const fullPath = '/$routeName';

  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //TODO Controller for TextFieldForm is Good?
  late TextEditingController _taskNameController;
  late TextEditingController _taskTimeController;
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController();
    _taskTimeController = TextEditingController();
    _isChecked = false;
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasksList = context.watch<Tasks>();

    final Map args = ModalRoute.of(context)!.settings.arguments as Map;

    final String navigate = args['navigate'];
    final taskType = args['taskType'];

    if (_taskNameController.text.isEmpty && _taskTimeController.text.isEmpty) {
      _taskNameController.text = taskType.taskName;
      _taskTimeController.text = taskType.taskTime.toString();
      _isChecked = taskType.tasksCompleted;
    }

    return Scaffold(
      appBar: AppBar(
        title: navigate == 'edit'
            ? const Text(
                'Edit Page',
                style: TextStyle(color: Colors.white),
              )
            : const Text(
                'Create Page',
                style: TextStyle(color: Colors.white),
              ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _taskNameController,
                autofocus: true,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Task Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _taskTimeController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Task Time',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Checkbox(
                value: _isChecked,
                onChanged: (value) {
                  //TODO when user click checkbox page is re-render
                  setState(() {
                    _isChecked = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _submitForm(tasksList, navigate, taskType.taskId);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(Tasks tasksList, String navigate, int taskId) {
    if (_formKey.currentState!.validate()) {
      final int submitTaskId =
          tasksList.tasks.isNotEmpty ? tasksList.tasks.last.taskId + 1 : 1;
      final String submitTaskName = _taskNameController.text.trim();
      final int submitTaskTime = int.parse(_taskTimeController.text.trim());
      if (navigate == 'edit') {
        tasksList.editTask(taskId, submitTaskName, submitTaskTime, _isChecked);
      } else {
        tasksList.addTask(
            submitTaskId, submitTaskName, submitTaskTime, _isChecked);
      }
      Navigator.pop(context);
    }
  }
}
