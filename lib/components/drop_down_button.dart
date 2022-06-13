import 'package:flutter/material.dart';

class MyStatefulWidget extends StatefulWidget {
  String dropdownValue;

  MyStatefulWidget({Key? key, this.dropdownValue = ''}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState(dropdownValue);
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String dropdownValue;
  _MyStatefulWidgetState(this.dropdownValue);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['Administrador', 'Responsável interno', 'Gerente externo']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}