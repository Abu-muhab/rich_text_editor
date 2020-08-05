import 'package:flutter/material.dart';
import 'package:rich_text_editor/rich_text_field.dart';

class EditToolBar extends StatelessWidget {
  final RichTextFieldController controller;
  EditToolBar({this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      color: Colors.grey[50],
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              int selectedSpanCount = controller.selection
                  .textInside(controller.value.text)
                  .split(" ")
                  .length;
              for (int x = 0; x < selectedSpanCount; x++) {
                controller.spanStyles[controller.selection
                            .textBefore(controller.value.text)
                            .split(" ")
                            .length -
                        1 +
                        x] =
                    TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25, height: 1.5);
              }
              controller.notifyListeners();
            },
            child: Text(
              "B",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 25, height: 1.5),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            child: Text(
              "I",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 25,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
