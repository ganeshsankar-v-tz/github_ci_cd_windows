import 'package:flutter/material.dart';

class MyTotalTile extends StatelessWidget {
  final dynamic item;
  const MyTotalTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: 242,
      height: 150,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(colors: [
          Color(0xFF9795D4),
          Color(0xCC9795D4),
        ]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/money_bag.png',
                width: 24,
                height: 24,
              ),
              SizedBox(width: 4),
              Text(
                item['title'],
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            item['amount'],
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              item['description'],
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
