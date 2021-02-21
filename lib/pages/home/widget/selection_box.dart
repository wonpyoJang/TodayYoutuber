import 'package:TodayYoutuber/common/dialogs.dart';
import 'package:TodayYoutuber/models/category.dart';
import 'package:TodayYoutuber/pages/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:easy_localization/easy_localization.dart';

class SelectionBox extends StatefulWidget {
  final String tag;
  final BehaviorSubject<int> selectedCategoryStream;

  SelectionBox({Key key, this.tag, this.selectedCategoryStream})
      : super(key: key);

  @override
  _SelectionBoxState createState() => _SelectionBoxState();
}

class _SelectionBoxState extends State<SelectionBox> {
  String value = "selection".tr().toString();

  @override
  Widget build(BuildContext context) {
    HomeViewModel _homeViewModel = Provider.of(context, listen: false);
    List<Category> categories = _homeViewModel.categories;

    return GestureDetector(
      onTap: () async {
        // 초기값
        value = categories[0].title;
        widget.selectedCategoryStream.add(0);
        setState(() {});

        await showSelectFromCategories(context, categories,
            onSelect: (category) {
              value = category.title;
              widget.selectedCategoryStream.add(categories.indexOf(category));
              setState(() {});
            }, onSubmit: () {
              Navigator.of(context).pop();
            });
      },
      child: Container(
        child: Container(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                height: 44,
                width: 70,
                alignment: Alignment.centerLeft,
                child: Text(widget.tag,
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
                child: Container(
                    height: 44,
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(value,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 13,
                            )),
                        Icon(Icons.arrow_downward_rounded),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        border: Border.all(width: 1, color: Colors.black))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}