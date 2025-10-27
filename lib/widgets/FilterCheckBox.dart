import 'package:flutter/material.dart';

class FilterCheckbox extends StatelessWidget {
  const FilterCheckbox({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      // width: 100,
      child: Row(
        children: <Widget>[
          Checkbox(
            value: value,
            onChanged: (bool? newValue) {
              onChanged(newValue);
            },
            visualDensity: VisualDensity.standard,
          ),
          Text(label),
        ],
      ),
    );
  }
}
