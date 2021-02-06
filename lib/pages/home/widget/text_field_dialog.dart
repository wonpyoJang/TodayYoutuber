import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

Future<String> showTextFieldDialog(
  BuildContext context,
) async {
  assert(context != null);

  TextEditingController setCategoryNameTextController = TextEditingController();
  bool isConfirmed = false;
  PublishSubject<bool> isMoreThanOneCharStream = PublishSubject<bool>();

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          actions: [
            StreamBuilder<Object>(
                stream: isMoreThanOneCharStream.stream,
                initialData: false,
                builder: (context, isMoreThanOneStreamSnapshot) {
                  return FlatButton(
                    color: Colors.red,
                    textColor: isMoreThanOneStreamSnapshot.data
                        ? Colors.white
                        : Colors.grey,
                    child: Text("확인"),
                    onPressed: () {
                      if (isMoreThanOneStreamSnapshot.data) {
                        isConfirmed = true;
                        Navigator.of(context).pop();
                      }
                    },
                  );
                })
          ],
          content: Container(
              color: Colors.white,
              width: 100,
              height: 100,
              child: TextField(
                controller: setCategoryNameTextController,
                onChanged: (text) {
                  if (text.length > 0) {
                    isMoreThanOneCharStream.add(true);
                  } else {
                    isMoreThanOneCharStream.add(false);
                  }
                },
              )));
    },
  );

  isMoreThanOneCharStream.close();

  if (isConfirmed == false) {
    return null;
  }

  return setCategoryNameTextController.text;
}
