import 'package:flutter/material.dart';

class LabeledSwitch extends StatelessWidget {
  const LabeledSwitch({
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
      width: 120,
      child: Row(
        children: <Widget>[
          Text(label),
          Switch(
            value: value,
            onChanged: (bool value) {
              onChanged(value);
            },
          ),
        ],
      ),
    );
  }
}