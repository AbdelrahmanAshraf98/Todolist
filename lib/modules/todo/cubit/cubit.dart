import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_udemycourse/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:form_udemycourse/modules/done_tasks/done_tasks_screen.dart';
import 'package:form_udemycourse/modules/new_tasks/new_tasks_screen.dart';
import 'package:sqflite/sqflite.dart';

import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<String> appBar = ['Tasks', 'Done Tasks', 'Archived Tasks'];
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase('todo.db', version: 1,
        onCreate: (database, version) {
      print('Database Created');
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT ,date TEXT ,time TEXT ,status TEXT )')
          .then(
            (value) => print('Table Created'),
          )
          .catchError((error) {
        print('Error while creating table ${error.toString()}');
      });
    }, onOpen: (database) {
      print('Database opened');
      getFromDatabase(database);
    }).then((value) => {
      database = value,
      emit(AppCreateDatabaseState()),
        });
  }

  insertToDatabase({
    @required String title,
    @required String date,
    @required String time,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');

        emit(AppInsertDatabaseState());

        getFromDatabase(database);

      }).catchError((error) {
        print('Error while inserting record ${error.toString()}');
      });
      return null;
    });
  }

  void getFromDatabase(database) {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element){
        // print(element['title']);
        if(element['status'] == 'new'){
          print(element['title']);
          newTasks.add(element);
        }
        else if(element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateDatabase({
    @required String status,
    @required int id,
  }) async{
     database.rawUpdate(
        'UPDATE tasks SET status = ?  WHERE id = ?',
        ['$status','$id']).then((value) {
          getFromDatabase(database);
          emit(AppUpdateDatabaseState());

     });

  }

  void deleteFormDatabase({@required int id}){
      database.rawDelete('DELETE FROM tasks WHERE id = ?',[id],).then((value) {
        getFromDatabase(database);
        emit(AppDeleteFromDatabaseState());
      });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    @required bool isShow,
    @required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
