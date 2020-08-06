import 'package:flutter/material.dart';

GlobalKey<RichTextFieldState> richTextFieldKey = GlobalKey();

class RichTextField extends StatefulWidget {
  final RichTextFieldController controller;
  RichTextField({this.controller}) : super(key: richTextFieldKey);
  @override
  State createState() => RichTextFieldState();
}

class RichTextFieldState extends State<RichTextField> {
  RichTextFieldController controller;
  @override
  void initState() {
    controller = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration.collapsed(hintText: "Body"),
      expands: true,
      maxLines: null,
      maxLength: null,
      textInputAction: TextInputAction.newline,
    );
  }
}

class RichTextFieldController extends TextEditingController {
  TextSpan textSpan;
  List<TextStyle> spanStyles = new List();
  RichTextFieldController(
      {this.textSpan =
          const TextSpan(style: TextStyle(color: Colors.black, height: 1.5))})
      : super(text: textSpan.toPlainText());

  @override
  TextSpan buildTextSpan({TextStyle style, bool withComposing}) {
    int count = -1;
    List<TextSpan> textSpans = value.text.split(" ").toList().map((text) {
      count++;
      TextStyle spanStyle;
      try {
        spanStyle = spanStyles[count];
      } catch (err) {
        spanStyles.add(style);
      }

      return TextSpan(
          style: spanStyles[count],
          text: count == value.text.split(" ").length - 1 ? text : text + " ");
    }).toList();
    while (spanStyles.length - 1 > count) {
      spanStyles.removeLast();
    }
    textSpan = TextSpan(
      style: style,
      children: <TextSpan>[...textSpans],
    );
    return textSpan;
  }

  @override
  set value(TextEditingValue newValue) {
    bool shiftCursor = false;
    String append = "";
    try {
      //after regex replace, the last character gets removed
      //the last character is appended back after replacement
      String temp = newValue.text.replaceAll(RegExp("[ \n]"), "");
      append = temp[temp.length - 1];
    } catch (err) {}
    String modifiedText =
        newValue.text.replaceAll(RegExp("[^ \n]\n"), "$append \n");
    if (newValue.text != modifiedText) {
      shiftCursor = true;
    }
    TextEditingValue modifiedVal = TextEditingValue(
      text: modifiedText,
      composing: shiftCursor == true
          ? TextRange.collapsed(modifiedText.length)
          : newValue.composing,
      selection: shiftCursor == true
          ? TextSelection.collapsed(offset: modifiedText.length)
          : newValue.selection,
    );
    super.value = modifiedVal;
    print(newValue.text);
    if (newValue.text.length == 0) {
      spanStyles = new List();
    }
  }

  List<int> getSelectedSpansIndex(int selectionStart, int selectionEnd) {
    int count = 0;
    List<int> selected = new List();
    int base = 0;
    textSpan.visitChildren((span) {
      if (selectionStart <= base &&
          selectionEnd >= base + span.toPlainText().length) {
        print("true");
        selected.add(count);
      }
      count++;
      base += span.toPlainText().length;
      return true;
    });
    return selected;
  }

  int getTextSpanLength() {
    int count = 0;
    textSpan.visitChildren((span) {
      count++;
      return true;
    });
    return count;
  }
}
