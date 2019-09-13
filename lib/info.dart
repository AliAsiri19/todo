import 'package:flutter/material.dart';

import 'application_loclizations.dart';

class AppInfo extends StatelessWidget {
  BuildContext context;

  final List<String> _info = []
    ..add('Information Page')
    ..add('Delete item')
    ..add('Sort items')
    ..add('New Item')
    ..add('Double click on item for update')
    ..add('Check box mean task is finished');

  final List<Icon> _icons = []
    ..add(Icon(Icons.info))
    ..add(Icon(Icons.delete))
    ..add(Icon(Icons.swap_vert))
    ..add(Icon(Icons.add_circle))
    ..add(Icon(null))
    ..add(Icon(Icons.check_box_outline_blank));

  AppInfo(this.context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f0e6),
      appBar: AppBar(
        title: Text(_z('Informations')),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _z('msg_info_app'),
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Pacifico',
                      color: Color(0xffa87d40),
                    ),
                  ),
                )),
            Expanded(
              flex: 9,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: _icons[index],
                    title: Text(
                      _z(_info[index]),
                      style: TextStyle(
                          color: (index % 2) == 0
                              ? Color(0xffd9a702)
                              : Color(0xffa86b16)),
                    ),
                  );
                },
                itemCount: _info.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: OutlineButton(
                child: Text(_z('btn_exit_info')),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  String _z(String key) {
    return AppLocalizations.of(context).translate(key);
  }
}
