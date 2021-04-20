import 'dart:core';
import 'package:conditional/conditional.dart';
import 'package:flutter/material.dart';
import 'package:form_udemycourse/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:form_udemycourse/modules/done_tasks/done_tasks_screen.dart';
import 'package:form_udemycourse/modules/new_tasks/new_tasks_screen.dart';
import 'package:form_udemycourse/shared/components/constants.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class HomeLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  List<String> appBar = [
   'Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();



  void createDatabase() async {
    database = await openDatabase('todo.db', version: 1,
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
      getFromDatabase(database).then((value) {
        tasks = value;
        print(tasks);
      });
    });
  }

  Future insertToDatabase({
    @required String title,
    @required String date,
    @required String time,
  }) async {
    return await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
      }).catchError((error) {
        print('Error while inserting record ${error.toString()}');
      });
      return null;
    });
  }

  Future<List<Map>> getFromDatabase(database)async{
    return await database.rawQuery('SELECT * FROM tasks');
  }

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(appBar[currentIndex]),
      ),
      body: Conditional(condition: tasks.length > 0,
        onConditionFalse: Center(child: CircularProgressIndicator()),
        onConditionTrue: screens[currentIndex]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState.validate()) {
              insertToDatabase(
                title: titleController.text,
                date: dateController.text,
                time: timeController.text,
              ).then((value) {
                getFromDatabase(database).then((value) {
                  setState(() {
                    Navigator.pop(context);
                    isBottomSheetShown = false;
                    fabIcon = Icons.edit;
                    tasks = value;
                    print(tasks);
                  });

                });

              });
            }
          } else {
            scaffoldKey.currentState.showBottomSheet(
                (context) => Container(
                      padding: EdgeInsets.all(20.0),
                      color: Colors.white,
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: titleController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Task must not be empty';
                                } else
                                  return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.title),
                                labelText: 'Task Title',
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black54),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              onTap: () {
                                showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now())
                                    .then((value) {
                                  timeController.text = value.format(context);
                                });
                              },
                              controller: timeController,
                              keyboardType: TextInputType.datetime,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Time must not be empty';
                                } else
                                  return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.watch_later),
                                labelText: 'Task Time',
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black54),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              onTap: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2021-05-03'))
                                    .then((value) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value);
                                });
                              },
                              controller: dateController,
                              keyboardType: TextInputType.datetime,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Date must not be empty';
                                } else
                                  return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.calendar_today),
                                labelText: 'Task Time',
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black54),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                elevation: 20.0).closed.then((value) {
                  isBottomSheetShown = false;
                  setState(() {
                    fabIcon = Icons.edit;
                  });
            });
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Done'),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archived'),
        ],
      ),
    );
  }
}
