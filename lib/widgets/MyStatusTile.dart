import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keymap/keymap.dart';

class MyStatusTile extends StatelessWidget {
  final String status;
  final String currentStatus;

  const MyStatusTile({
    Key? key,
    required this.status,
    required this.currentStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, top: 8),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: Color(0xFF939393), width: 0.4),
        ),
        title: Text('${status.toUpperCase()}', style: TextStyle(fontSize: 14),),
        selectedTileColor: Colors.yellow,
        enabled: status == currentStatus ? true : false,
        //selected: status == currentStatus ? true : false,
        trailing: Icon(status == currentStatus ? Icons.circle: null, color: Colors.red,),
      ),
    );
  }
}
