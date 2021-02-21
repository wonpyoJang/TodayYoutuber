import 'package:flutter/material.dart';

class ChannelInfoItem extends StatelessWidget {
  final String tag;
  final String value;
  final bool enableTextField;
  final TextEditingController textEditingController;

  const ChannelInfoItem(
      {Key key,
        this.tag,
        this.value,
        this.enableTextField = false,
        this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              height: 44,
              width: 70,
              alignment: Alignment.centerLeft,
              child: Text(tag,
                  style: TextStyle(
                    fontSize: 13,
                  )),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(width: 1, color: Colors.black),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Stack(
                children: [
                  Container(
                      height: 44,
                      padding: EdgeInsets.all(4),
                      alignment: Alignment.centerLeft,
                      child: Text(value,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 13,
                          )),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(width: 1, color: Colors.black))),
                  if (enableTextField)
                    TextField(
                      controller: textEditingController,
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}