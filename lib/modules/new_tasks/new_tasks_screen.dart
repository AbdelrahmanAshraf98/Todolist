import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_udemycourse/shared/components/components.dart';
import 'package:form_udemycourse/shared/components/constants.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView.separated(
        itemBuilder: (context, index) => tasksBuilderItem(tasks[index]),
        separatorBuilder: (context, index) => Container(
          color: Colors.grey[300],
          height: 1.0,
          width: double.infinity,
        ),
        itemCount: tasks.length,
      ),
    );
  }
}
