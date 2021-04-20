import 'package:flutter/material.dart';

Widget tasksBuilderItem(Map model) => Padding(
  padding: const EdgeInsets.all(20.0),
  child:   Row(

    children: [

      CircleAvatar(

        radius: 40.0,

        child: Text('${model['time']}'),

      ),

      SizedBox(width: 20.0,),

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,

        children: [

          Text(

            '${model['title']}',

            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),

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

    ],

  ),
);