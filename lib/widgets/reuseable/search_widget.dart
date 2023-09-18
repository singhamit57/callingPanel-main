import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;
  final TextEditingController? controller;

  // ignore: use_key_in_widget_constructors
  const SearchWidget({
    required this.text,
    required this.onChanged,
    required this.hintText,
    this.controller,
  });

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    final styleActive = TextStyle(
        color: Get.theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
        fontSize: 12);
    final styleHint = TextStyle(
        color: Get.theme.colorScheme.primary.withOpacity(.7),
        fontWeight: FontWeight.w600,
        fontSize: 12);
    final style = widget.text.isEmpty ? styleHint : styleActive;

    return Container(
      alignment: Alignment.center,
      height: 42,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Get.theme.colorScheme.background,
        border: Border.all(color: Get.theme.colorScheme.primary),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: TextField(
        controller: widget.controller,
        cursorColor: Get.theme.colorScheme.primary,
        cursorWidth: 1.5,
        cursorHeight: 20,
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Get.theme.colorScheme.primary),
          suffixIcon: widget.text.isNotEmpty
              ? GestureDetector(
                  child: Icon(Icons.close, color: style.color),
                  onTap: () {
                    widget.controller!.clear();
                    widget.onChanged('');
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              : null,
          hintText: widget.hintText,
          hintStyle: styleHint,
          border: InputBorder.none,
        ),
        style: styleActive,
        onChanged: widget.onChanged,
      ),
    );
  }
}
