import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_udemycourse/modules/todo/cubit/cubit.dart';
import 'package:form_udemycourse/modules/todo/cubit/states.dart';
import 'package:form_udemycourse/shared/components/components.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) =>  Padding(
        padding: const EdgeInsets.all(10.0),
        child: taskBuilder(tasks: AppCubit.get(context).newTasks),
      ),
    );
  }
}
