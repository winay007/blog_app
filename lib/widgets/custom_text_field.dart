import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
   final controller;
  
   CustomTextField({
    Key key,
    this.hint,
    this.controller,
  }) : super(key: key);
  final String hint;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.yellow)),
        child: TextFormField(
          controller: controller ,
          maxLines: 2,
          minLines: 1,
          decoration: InputDecoration(border: InputBorder.none, hintText: hint),
        ));
  }
}
