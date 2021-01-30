import 'package:flutter/material.dart';

Future<String> showTextFieldDialog(
  BuildContext context,
) async {
  assert(context != null);

  TextEditingController setCategoryNameTextController = TextEditingController();

  bool isConfirmed = false;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          actions: [
            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text("확인"),
              onPressed: () {
                isConfirmed = true;
                Navigator.of(context).pop();
              },
            )
          ],
          content: Container(
              color: Colors.white,
              width: 100,
              height: 100,
              child: TextField(
                controller: setCategoryNameTextController,
              )));
    },
  );

  if (isConfirmed == false) {
    return null;
  }

  return setCategoryNameTextController.text;
}
