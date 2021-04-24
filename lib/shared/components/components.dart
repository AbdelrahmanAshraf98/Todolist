import 'package:conditional/conditional.dart';
import 'package:flutter/material.dart';
import 'package:form_udemycourse/modules/todo/cubit/cubit.dart';

Widget tasksBuilderItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction){
          AppCubit.get(context).deleteFormDatabase(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text('${model['time']}'),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
                icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
                ),
                onPressed: () {
                  AppCubit.get(context)
                      .updateDatabase(status: 'done', id: model['id']);
                }),
            IconButton(
                icon: Icon(
                  Icons.archive,
                  color: Colors.black54,
                ),
                onPressed: () {
                  AppCubit.get(context)
                      .updateDatabase(status: 'archived', id: model['id']);
                }),
          ],
        ),
      ),
    );

Widget taskBuilder({@required List tasks}){
  return Conditional(
    condition: tasks.length > 0,
    onConditionTrue: ListView.separated(
      itemBuilder: (context, index) => tasksBuilderItem(tasks[index],context),
      separatorBuilder: (context, index) => Container(
        color: Colors.grey[300],
        height: 1.0,
        width: double.infinity,
      ),
      itemCount: tasks.length,
    ),
    onConditionFalse: Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu,color: Colors.grey,size: 100.0,),
        Text('No Tasks Yet',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.grey),),
      ],
    ),),
  );
}
