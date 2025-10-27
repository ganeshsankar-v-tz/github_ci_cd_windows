import 'package:abtxt/view/dashboard/dashboard_controller.dart';
import 'package:abtxt/view/dashboard/product_sales_analysis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constant.dart';
import '../../widgets/MyDropdownButtonFormField.dart';
import '../../widgets/MyTotalTile.dart';
import '../../widgets/bar_chart_graph.dart';

class DashboardThree extends StatefulWidget {
  const DashboardThree({Key? key}) : super(key: key);

  @override
  State<DashboardThree> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardThree> {
  DashboardController controller = Get.put(DashboardController());
  List<Item> _books = [];

  @override
  void initState() {
    _books = generateItems(8);
    super.initState();
  }

  List<Item> generateItems(int numberOfItems) {
    return List.generate(numberOfItems, (int index) {
      return Item(
        headerValue: 'Book $index',
        expandedValue: 'Details for Book $index goes here',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9F3FF),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: Get.height,
                      color: Colors.red,
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                      height: Get.height,
                      width: Get.width,
                    ),
                  ),
                ],
              ),
              Container(
                height: 400,
                color: Colors.yellow,
                child: Column(
                  children: [
                    ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          _books[index].isExpanded = !isExpanded;
                        });
                      },
                      children: _books.map<ExpansionPanel>((Item step) {
                        return ExpansionPanel(
                          headerBuilder: (BuildContext context, bool isExpanded) {
                            return ListTile(
                              title: Text(step.headerValue),
                            );
                          },
                          body: ListTile(
                            title: Text(step.expandedValue),
                          ),
                          isExpanded: step.isExpanded,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = true,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}
