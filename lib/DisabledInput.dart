// ignore_for_file: must_be_immutable, prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';

Widget disabledInput(String title, String value){
  return Container(
      padding: EdgeInsets.only(left: 20, right: 30),
      height: 30,
      child: TextField(
          enabled: false, 
          style: TextStyle(fontSize: 14),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: title,
            labelStyle: TextStyle(fontSize: 14),
            contentPadding: EdgeInsets.only(left: 10, bottom: 10)
            // errorText: _error[1] ? 'Value Can\'t Be Empty' : null,
          ),
          controller: TextEditingController(text: "${value}"),
        )
    );
}