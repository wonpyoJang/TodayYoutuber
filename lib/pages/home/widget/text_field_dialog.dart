import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

Future<String> showTextFieldDialog(
  BuildContext context,
) async {
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
              height: 150,
              child: Column(
                children: [
                  Text("카테고리 추가"),
                  SizedBox(height: 10),
                  Text("새 카테고리 명을 입력해 주세요"),
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
