// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables, use_build_context_synchronously, sized_box_for_whitespace, sort_child_properties_last, non_constant_identifier_names, no_logic_in_create_state, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, must_be_immutable, avoid_unnecessary_containers, unnecessary_null_comparison

import 'package:flutter/material.dart';

class RadioForm extends StatefulWidget {
  RadioForm({required this.title, required this.option, required this.onChange, this.selected, Key? key}) : super(key: key);
  List<String> option;
  String title;
  String ?selected;
  final Function onChange;
  @override
  _RadioFormState createState() => _RadioFormState(option: option, title: title);
}

class _RadioFormState  extends State<RadioForm> {
  _RadioFormState({required this.title, required this.option});
  List<String> option;
  String title;
  String output = "";
  @override
  void initState() {
    super.initState();
    setState(() {
      output = option.first;
      for(int a=0; a<option.length; a++){
        if(widget.selected == option[a]) output = option[a];
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChange(output);
    });
    });
  }


  @override
  Widget build(BuildContext context) { 
    return Container(
      child : Column(
        children: [
          SizedBox(height: 20),
          SizedBox(
            width: 500,
            height: (MediaQuery.of(context).size.width/8.5 > title.length) ? 30 : ((MediaQuery.of(context).size.width/8.5)*2 > title.length) ? 45 : 70,
            // height: 45,
            child: ListTile(
              title: Text(title),
            ),
          ),
          for(int i=0; i<option.length; i++)
            SizedBox(
              width: 500,
              height: 30,
              child: ListTile(
                title: Text(option[i]),
                leading: Radio<String>(
                  value: option[i],
                  groupValue: output,
                  onChanged: (String? value) {
                    setState(() {
                      output = value!;
                    });
                    if(output != "Lainnya")widget.onChange(value);
                  },
                ),
              ),
            ),
            if(output == "Lainnya") Container(
              margin: EdgeInsets.only(top: 20, left:30, right: 30),
              // height: 60,
              child: TextField(
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Lainnya',
                  labelStyle: TextStyle(fontSize: 20),
                  // errorText: _error[1] ? 'Value Can\'t Be Empty' : null,
                ),
                onChanged: (value){
                  if(value != null && value != ""){
                    widget.onChange(value);
                  }
                },
              ), // controller: _data[1],
            ),
        ]
      ),
    );
  }
}