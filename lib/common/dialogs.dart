import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showDBConnectionFailDailog(BuildContext context) async {
  await _showErrorDialog(context, "내부 DB 연결 실패(client)",
      "죄송합니다. 내부 클라이언트 내부 DB 연결에 실패했습니다. 다시 시도해 주세요.");
}

Future<void> showDuplicatedChannelDailog(BuildContext context) async {
  await _showErrorDialog(context, "이미 존재하는 채널", "현재 목록에 이미 존재하는 채널입니다.");
}

Future<void> showDuplicatedCategoryDailog(BuildContext context) async {
  await _showErrorDialog(context, "이미 존재하는 카테고리", "현재 이미 존재하는 카테고리입니다.");
}

Future<void> _showErrorDialog(
  BuildContext context,
  String title,
  String content,
) async {
  await showDialog<void>(
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

Future<void> showCategoryMenu(BuildContext context,
    {Function onPressedEdit, Function onPressedDelete}) async {
  await showCupertinoSelectionMenu(context, "메뉴", [
    CupertinoActionSheetAction(
        onPressed: () async {
          await onPressedEdit();
          Navigator.of(context).pop();
        },
        child: Text("편집")),
    CupertinoActionSheetAction(
        onPressed: () async {
          await onPressedDelete();
          Navigator.of(context).pop();
        },
        child: Text("삭제"))
  ]);
}

Future<void> showCupertinoSelectionMenu(BuildContext context, String title,
    List<CupertinoActionSheetAction> actions) async {
  await showModalBottomSheet(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(title),
          actions: actions,
          cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("취소")),
        );
      });
}