import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'application_loclizations.dart';
import 'data.dart';
import 'database_helper.dart';
import 'info.dart';

class Home extends StatefulWidget {
  String title;

  Home({Key key, this.title}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  DatabaseHelper _databaseHelper = DatabaseHelper();
  int count;
  List<Todo> items;

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      items = List<Todo>();
    }
    updateTodoList();
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Exit application.'),
                actions: <Widget>[
                  FlatButton.icon(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      icon: Icon(Icons.exit_to_app),
                      label: Text('Quit')),
                  FlatButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.cancel),
                    label: Text('Cancel'),
                  )
                ],
              );
            });
      },
      child: Scaffold(
        key: _globalKey,
        appBar: AppBar(
          leading: Text(''),
          title: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: Text(
                      _z('app_name'),
//                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                        icon: Icon(
                          Icons.swap_vert,
                        ),
                        onPressed: () {
                          _databaseHelper.flipSorting();
                          setState(() {});
                        }),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return AppInfo(context);
                          }));
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: futureTodoListView,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addNewItem();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget get futureTodoListView {
    return FutureBuilder<List<Todo>>(
      future: updateTodoList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (items.length == 0) {
            return getEmptyWidget();
          }

          return ListView.builder(
            itemCount: this.count,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Checkbox(
                    value: items[index].isCompleted,
                    onChanged: (state) {
                      items[index].isCompleted = state;
                      _databaseHelper.updateOldTodoItem(items[index]);
                      setState(() {});
                    },
                    checkColor: Colors.black,
//                    activeColor: Colors.grey,
                  ),
                  title: GestureDetector(
                    child: Text(
                      items[index].body,
                      style: TextStyle(
                        color: items[index].isCompleted
                            ? Colors.grey
                            : Colors.black,
                        decoration: items[index].isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    onDoubleTap: () {
                      _updateItem(items, index);
                    },
                  ),
                  trailing: GestureDetector(
                    child: Icon(Icons.delete),
                    onTap: () {
                      _delete(items, index);
                    },
                  ),
                ),
              );
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  // delete item from list and Database table for ever.
  void _delete(List<Todo> items, int index) {
    showDialog(
        context: (context),
        builder: (context) {
          return AlertDialog(
            title: Text("${_z('btn_delete')} : ${_z('msg_check_title')}"),
            content: Text('${_z('btn_delete')} ((${items[index].body})) '),
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () {
                    _databaseHelper.deleteTodoItem(items[index].id);
//                    items.removeAt(index);
                    _snackBar(_z('btn_delete'));
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.delete),
                  label: Text(_z('btn_delete'))),
              FlatButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  icon: Icon(Icons.cancel),
                  label: Text(_z('btn_cancel')))
            ],
          );
        },
        barrierDismissible: false);
  }

  // Add new item to list and database table.
  void _addNewItem() {
    TextEditingController _controller = TextEditingController();
    showDialog(
        context: (context),
        builder: (context) {
          return AlertDialog(
            title: Text(_z('msg_add_item')),
            content: Container(
              height: 100,
              child: Column(
                children: <Widget>[
//                  Expanded(flex: 1,child: Text(_z('msg_add_titel'))),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _controller,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _databaseHelper.addNewTodoItem(Todo(_controller.text));
                      _snackBar('New item saved .');
                      setState(() {});
                    }
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.save),
                  label: Text(_z('btn_save'))),
              FlatButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.cancel),
                  label: Text(_z('btn_cancel'))),
            ],
          );
        },
        barrierDismissible: false);
  }

  // update selected item to new values.
  void _updateItem(List<Todo> items, int index) {
    TextEditingController _controller =
        TextEditingController(text: items[index].body);
    showDialog(
        barrierDismissible: false,
        context: (context),
        builder: (context) {
          return AlertDialog(
            title: Text(_z('msg_update_item')),
            content: Container(
              height: 150,
//          height: 200,
              child: Column(
                children: <Widget>[
//                  Text(_z('msg_update_title')),
                  TextField(
                    controller: _controller,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      items[index].body = _controller.text;
                      var result =
                          _databaseHelper.updateOldTodoItem(items[index]);
                      _snackBar(_z('msg_update_item'));
                      setState(() {});
                    }
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.update),
                  label: Text(_z('btn_update'))),
              FlatButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.cancel),
                  label: Text(_z('btn_cancel')))
            ],
          );
        });
  }

  // display snack bar in bottom of the screen
  void _snackBar(String str) {
    SnackBar snackBar = SnackBar(
      content: Text(
        str,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.amber,
    );
    _globalKey.currentState.showSnackBar(snackBar);
  }

  // sort the list of items inside memory of mobile only.
  void sortItems() {
    items.sort((a, b) {
      return a.isCompleted.toString().compareTo(b.isCompleted.toString());
    });
  }

  // return widget r=that tell us - no item / add new .
  Widget getEmptyWidget() {
    // draw screen with note picture and message to add new items
    return Wrap(  // avoid overflow when add new item in first time
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(    // Image when database table is empty
              height: 300,
              child: Image.asset('notes_icon.png'),
            ),
            Row(
              // message tell the user how to add new item
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
//              color: Colors.amber,
                  child: Text(
                    '${_z("msg_no_items")},${_z("msg_press_this_button")}',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold),
                  ),
                ),
//            SizedBox(width: 5),
                // down arrow icon induct the button to press
                Icon(Icons.arrow_downward)
              ],
            ),
          ],
        ),
      ],
    );
  }

  Future<List<Todo>> updateTodoList() async {
    var database = await _databaseHelper.initializeDatebase();
    this.items = List.from(await _databaseHelper.getListOfTodo());
    this.count = this.items.length;

    this.items.sort((item1, item2) {
      return item1.isCompleted
          .toString()
          .compareTo(item2.isCompleted.toString());
    });
    return this.items;
  }

  /// *******************************************************

  String _z(String key) {
    return AppLocalizations.of(context).translate(key);
  }
} // end of state class
