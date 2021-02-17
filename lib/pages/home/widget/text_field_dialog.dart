import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:easy_localization/easy_localization.dart';

Future<String> showTextFieldDialog(BuildContext context,
    {String title, String description}) async {
  assert(context != null);

  TextEditingController setCategoryNameTextController = TextEditingController();
  bool isConfirmed = false;
  PublishSubject<bool> isMoreThanOneCharStream = PublishSubject<bool>();
  FocusNode newCategoryNameFocus = FocusNode();

  await showDialog(
    context: context,
    builder: (context) {
      FocusScope.of(context).requestFocus(newCategoryNameFocus);

      return AlertDialog(
          actions: [
            StreamBuilder<Object>(
                stream: isMoreThanOneCharStream.stream,
                initialData: false,
                builder: (context, isMoreThanOneStreamSnapshot) {
                  return FlatButton(
                    color: Colors.pink[200],
                    textColor: isMoreThanOneStreamSnapshot.data
                        ? Colors.white
                        : Colors.grey,
                    child: Text("submit".tr().toString()),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 10),
                  Text(description),
                  SizedBox(height: 20),
                  TextField(
                    focusNode: newCategoryNameFocus,
                    controller: setCategoryNameTextController,
                    onChanged: (text) {
                      if (text.length > 0) {
                        isMoreThanOneCharStream.add(true);
                      } else {
                        isMoreThanOneCharStream.add(false);
                      }
                    },
                    onSubmitted: (text) {
                      if (text.length > 0) {
                        isConfirmed = true;
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              )));
    },
  );

  isMoreThanOneCharStream.close();

  if (isConfirmed == false) {
    return null;
  }

  return setCategoryNameTextController.text;
}
