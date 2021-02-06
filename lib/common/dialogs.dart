import 'package:flutter/material.dart';

showDBConnectionFailDailog(BuildContext context) {
  _showErrorDialog(context, "내부 DB 연결 실패(client)",
      "죄송합니다. 내부 클라이언트 내부 DB 연결에 실패했습니다. 다시 시도해 주세요.");
}

Future<void> _showErrorDialog(
  BuildContext context,
  String title,
  String content,
) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(content),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('확인'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
